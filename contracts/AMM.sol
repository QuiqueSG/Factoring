// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEX {

        IERC20 tokenERC;

        uint256 public total_liquidity;
        
        //FEE - Profits for deployer
        address private deployer;
        uint256 public fee;

        //Investors
        mapping(address => uint256) public investors;

        //LP Providers
        mapping (address => uint256) public liquidity;

        event Initialize (uint256 _value);
        event TokensSwapped (uint256 _value);
        event ETHSwapped (uint256 _value);
        event Deposit (uint256 _value);
        event Withdraw (uint256 _valueETH, uint256 _valueToken);

        //EVENT VARIABLEs

        uint256 public tokens_received;
        uint256 public eth_received;
        uint256 public liq_added;

        constructor(){
                deployer = tx.origin;
        }

        function initialize(address token_address, uint256 token_amount) external payable {
                require(total_liquidity == 0);
                require(token_amount > 0);
                require(msg.value > 0);

                fee = 0;
                tokenERC = IERC20(token_address);
                
                total_liquidity = address(this).balance;
                liquidity[tx.origin] = total_liquidity;          

                
                require(tokenERC.transferFrom(tx.origin, address(this), token_amount));

                emit Initialize(total_liquidity);
        }

        function calculatePrice(uint256 input_value, uint256 input_pool, uint256 output_pool) internal pure returns (uint256) {
                return (input_value * output_pool) / (input_pool + input_value);
        }


        function priceERC(uint256 eth) external view returns(uint256){
                return calculatePrice(eth, (address(this).balance - eth), tokenERC.balanceOf(address(this)));
        }

        function priceETH(uint256 erc) external view returns(uint256){
                return calculatePrice(erc, tokenERC.balanceOf(address(this)), address(this).balance);
        }

        function ethToErc() external payable {
                uint256 tokens_swapped = calculatePrice(msg.value, (address(this).balance - msg.value), tokenERC.balanceOf(address(this)));

                require(tokenERC.transfer(tx.origin, tokens_swapped));

                fee += msg.value;
                investors[tx.origin] += msg.value;

                tokens_received = tokens_swapped;

                emit TokensSwapped(tokens_swapped);

        }


        function ercToEth(uint256 token_amount) external {

                uint256 eth_swapped = calculatePrice(token_amount, tokenERC.balanceOf(address(this)), address(this).balance);

                (bool success, ) = tx.origin.call{value: eth_swapped}("");
                require(success, "Transfer failed.");    

                require(tokenERC.transferFrom(tx.origin, address(this), token_amount));

                fee += eth_swapped;
                emit ETHSwapped(eth_swapped);
                eth_received = eth_swapped;
        }

        function deposit() external payable {
                require(msg.value > 0);
                uint256 token_amount = ((msg.value * tokenERC.balanceOf(address(this))) / (address(this).balance - msg.value));
                uint256 liquidity_added = (msg.value * total_liquidity) / (address(this).balance - msg.value);

                liquidity[tx.origin] += liquidity_added;

                total_liquidity += liquidity_added;
                require(tokenERC.transferFrom(tx.origin, address(this), token_amount));

                emit Deposit(liquidity_added);
                liq_added = liquidity_added;
        }

        function liquidityAdded(uint256 eth) external view returns (uint256, uint256){
                uint256 token_amount = ((eth * tokenERC.balanceOf(address(this))) / (address(this).balance));
                uint256 liquidity_added = (eth * total_liquidity) / (address(this).balance);

                return (token_amount, liquidity_added);

        }


        function withdraw(uint256 value) external {
                uint256 eth_value = (value * address(this).balance) / total_liquidity;
                uint256 token_value = (value * tokenERC.balanceOf(address(this))) / total_liquidity;

                total_liquidity -= eth_value;

                (bool success, ) = tx.origin.call{value: eth_value}("");
                require(success, "Transfer failed.");    

                require(tokenERC.transfer(tx.origin, token_value));

                emit Withdraw(eth_value, token_value);
                eth_received = eth_value;
                tokens_received = token_value;
        }

        function liquiditySubstracted(uint256 value) external view returns (uint256, uint256){
                uint256 eth_value = (value * address(this).balance) / total_liquidity;
                uint256 token_value = (value * tokenERC.balanceOf(address(this))) / total_liquidity;
                
                return (eth_value, token_value);

        }

        function getTokenBalance() external view returns (uint256) {
                return tokenERC.balanceOf(address(this));
        }

        function getBalance() external view returns (uint256) {
                return address(this).balance;
        }

        function distributeFee() external{
                uint256 profit = (fee * 3) / 1000;
                (bool success, ) = tx.origin.call{value: profit}("");
                require(success, "Transfer failed.");
        }

        function invested(address who) external view returns (uint256){
                return investors[who];
        }

        function finish() external {
                selfdestruct(payable(tx.origin));
        }

}