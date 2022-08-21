// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Verificador.sol";
import "./AMM.sol";
import "./Tokenitzar.sol";
import "./Interest.sol";


contract Factoring {

    //Contract elements:

    //Verified document
    Verificacio public verificador;
    uint256 public value;
    uint public expDays;

    //Collateral
    uint256 public collateral;

    //Tokenization
    Tokfa public tokenitzacio;
    uint256 public tokensInit;

    //Liquidity pool
    DEX public LP;

    //Interest
    Interest public intFee;
    bool private hasLink;
    bool private hasHash;


    constructor(){
        LP = new DEX();
        verificador = new Verificacio();
        intFee = new Interest(15);
    }

    modifier onlyOwner{
        require(verificador.owner() == msg.sender);
        _;
    }


    //Setting new File
    event NewDocument(address indexed owner, string filename, uint256 value, uint daysRemaining);

    function DOCnewFile(string memory _filename, uint256 _value, uint _days) external {
        value = _value;
        expDays = block.timestamp + _days;

        verificador.setFilename(_filename);
        verificador.setOwner(msg.sender);

        emit NewDocument(msg.sender, _filename, _value, _days);

    }


    //Important data that helps to validate
    
    function DOCsetHash(string memory hash) external onlyOwner{
        verificador.setHashDoc(hash);
        hasHash = true;
        if (hasLink && hasHash){
            intFee.adjustIntDoc();
        }
    }

    function DOCgetHash() external view returns(string memory){
        return verificador.hash();
    }

    function DOCsetURL(string memory link) external onlyOwner{
        verificador.setLinkDoc(link);
        hasLink = true;
        if (hasLink && hasHash){
            intFee.adjustIntDoc();
        }
    }
    
    function DOCgetURL() external view returns(string memory){
        return verificador.link();
    }

    //1. VERIFY
    event DOCValidated(address indexed validator, string asset);

    function DOCvalidate() external{
        verificador.validate();

        if (verificador.checkValidation()){
            intFee.adjustIntVerify();
        }

        emit DOCValidated(msg.sender, verificador.filename());
    }

    event DOCDenegated(address indexed denegator, string asset);
    function DOCdeny() external {
        verificador.denegate();

        emit DOCDenegated(msg.sender, verificador.filename());
    }


    //2. TOKENIZATION

    /*
    STEPS:
    1. Tokenize Asset
    2. Give allowance to Contract
    3. Initialize Liquidity Pool
    4. Adjust interest rate
    */

    event StartLP(uint256 assetX, uint256 assetY);
    

    function start(uint256 quants_tokens) external payable {
        collateral = msg.value;
        
        //1.
        tokenitzacio = new Tokfa(quants_tokens);
        uint256 token_amount = quants_tokens * 10**uint(tokenitzacio.decimals());
        tokensInit = token_amount;

        //2.
        tokenitzacio.approve(tx.origin, address(LP), tokenitzacio.totalSupply());


        //3.
        LP.initialize{value:msg.value}(address(tokenitzacio), token_amount);

        //4.

        intFee.adjustIntCol(value, collateral);

        emit StartLP(token_amount, msg.value);


    }

 //----------SWAP ERC------------
    
    event BuyERC(uint256 payed, uint256 tokens_received);
    
    function LPbuyERC() external payable {
        LP.ethToErc{value:msg.value}();
        
        emit BuyERC(msg.value, LP.tokens_received());
    }

 //----------SWAP ETH------------

    event BuyETH(uint256 payed, uint256 tokens_received);

    function LPbuyETH(uint256 tokens) public {

        tokenitzacio.approve(tx.origin, address(LP), tokens);
        LP.ercToEth(tokens);
        emit BuyETH(tokens, LP.eth_received());
    }

 //----------DEPOSIT------------

    event DepositLP(uint256 liquidity);
    function LPdeposit() external payable {
        uint256 tokens_added = tokenAmount(msg.value);
        if (tokens_added > TFAmybalance()){
            tokenitzacio.generate(tokens_added);
        }

        tokenitzacio.approve(tx.origin, address(LP), tokenAmount(msg.value));
        LP.deposit{value:msg.value}();
        emit DepositLP(LP.liq_added());
    }

    function tokenAmount(uint256 eth) internal view returns(uint256){
        
        (uint256 liquidity, ) = LP.liquidityAdded(eth);
        return liquidity;
    }

 //----------WITHDRAW------------

    event WithdrawLP(uint256 eth_received, uint256 tokens_received);
    function LPgetLiquidity(uint256 liquid) public {
        LP.withdraw(liquid);

        emit WithdrawLP(LP.eth_received(), LP.tokens_received());
    }

//----------FINAL FASE------------

    function FINgetProfit() external {
        LPgetLiquidity(intFee.mul(LP.invested(tx.origin)));
    }

    function FINarbit() external {
        uint256 new_tokens = tokensInit - LP.getTokenBalance();
        if (new_tokens > TFAmybalance()){
            tokenitzacio.generate(new_tokens);
        }
        LPbuyETH(new_tokens);
    }

//----------INTERFACES------------


    //LIQUIDITY POOL INTERFACE

    function LPtokens() external view returns(uint256){
        return LP.getTokenBalance();
    }

    function LPether()  external view returns(uint256){
        return LP.getBalance();
    }

    function LPliquidity() external view returns(uint256){
        return LP.total_liquidity();
    }

    function LPpriceForERC(uint256 eth) external view returns(uint256){
        return LP.priceERC(eth);
    }

    function LPpriceForETH(uint256 tokens) external view returns(uint256){
        return LP.priceETH(tokens);
    }

 //----------CHECKERS------------

    function LPadded(uint256 eth) external view returns(uint256, uint256){
        return LP.liquidityAdded(eth);
    }

    function LPsubstracted(uint256 valor) external view returns(uint256, uint256){
        return LP.liquiditySubstracted(valor);
    }
    
    
    
    //TOKENIZATION INTERFACE

    function TFAmybalance() public view returns(uint256){
        return tokenitzacio.balanceOf(tx.origin);
    }

    function TFAbalance(address account) public view returns(uint256){
        return tokenitzacio.balanceOf(account);
    }

    function TFAsupply() external view returns(uint256){
        return tokenitzacio.totalSupply();
    }

    function ETHmybalance() public view returns(uint256){
        return tx.origin.balance;
    }

    function ETHbalance(address account) public view returns(uint256){
        return account.balance;
    }


    //INTEREST INTERFACE
    function INTrate() external view returns(uint256){
        return intFee.rate();
    }





}
    