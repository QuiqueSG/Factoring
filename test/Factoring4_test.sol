// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Factoring.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Factoring public factoring;
    uint256 public tokens;
    uint256 public ethers;

    function beforeAll() public {
        factoring = new Factoring();
        factoring.DOCnewFile("factura.pdf", 10*10**18, 30);
    }

    /// #sender: account-1
    /// #value: 9128000000000000000
    function checkStartFactoring() public payable {
        factoring.start{value: msg.value}(1350);
        
        tokens = factoring.LPtokens();
        ethers = factoring.LPether();

        Assert.equal(factoring.LPether(), 9128000000000000000, "error value");
        Assert.equal(factoring.LPtokens(), 1350*10**18, "error value");
        console.log("Supply before: ", factoring.TFAsupply());
    }



    /// #sender: account-2
    /// #value: 3220000000000000000
    function checkETH2() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
    }

    /// #sender: account-1
    function checkArbit2() public {
        factoring.FINarbit();
        Assert.ok(tokens==factoring.LPtokens(), "Should have same ether as begininng");
    }

    /// #sender: account-3
    /// #value: 1994000000000000000
    function checkETH3() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
    }

    /// #sender: account-1
    function checkArbit3() public {
        this.checkArbit2();
    }

    /// #sender: account-4
    /// #value: 2184000000000000000
    function checkETH4() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
    }

    /// #sender: account-1
    function checkArbit4() public {
        this.checkArbit2();
    }

    /// #sender: account-5
    /// #value: 3015000000000000000
    function checkETH5() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
    }

    /// #sender: account-1
    function checkArbit5() public {
        this.checkArbit2();
    }

    /// #sender: account-1
    function checkChangeTax() public payable {

        uint256 taxRate = factoring.INTrate();
        factoring.DOCsetHash("72fdf437fc2c452e55fc6da520a5967e");
        factoring.DOCsetURL("https://servidor.web/factura.pdf");
        Assert.ok(taxRate > factoring.INTrate(), "Tax didn't change");

    }

    /// #sender: account-1
    /// #value: 11587000668750000000
    
    function checkDepositVALUE() public payable{
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        factoring.LPdeposit{value: msg.value}();
        console.log("Supply after: ", factoring.TFAsupply());
    
        Assert.ok(factoring.LPtokens()>tokens, "Should more TFAs");
        Assert.ok(factoring.LPether()>ethers    , "Should more ETHs");

        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
    }

    /// #sender: account-2
    function checkProfit2() public {
        uint256 beforeBalance = factoring.TFAmybalance();
        uint256 eth_value = factoring.LPether();
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        factoring.FINgetProfit();
        Assert.ok(factoring.TFAmybalance()>beforeBalance, "Should have more TFAs");
        Assert.ok(eth_value>factoring.LPether(), "Should have less ETH");
        console.log("Interes: ", factoring.INTrate());
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        console.log("Profit TFA: ", factoring.TFAmybalance()-beforeBalance);
        console.log("Profit ETH: ", eth_value-factoring.LPether());
    }

    /// #sender: account-3
    function checkProfit3() public {
        uint256 beforeBalance = factoring.TFAmybalance();
        uint256 eth_value = factoring.LPether();
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        factoring.FINgetProfit();
        Assert.ok(factoring.TFAmybalance()>beforeBalance, "Should have more TFAs");
        Assert.ok(eth_value>factoring.LPether(), "Should have less ETH");
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        console.log("Interes: ", factoring.INTrate());
        console.log("Profit TFA: ", factoring.TFAmybalance()-beforeBalance);
        console.log("Profit ETH: ", eth_value-factoring.LPether());
    }

    /// #sender: account-4
    function checkProfit4() public {
        uint256 beforeBalance = factoring.TFAmybalance();
        uint256 eth_value = factoring.LPether();
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        factoring.FINgetProfit();
        Assert.ok(factoring.TFAmybalance()>beforeBalance, "Should have more TFAs");
        Assert.ok(eth_value>factoring.LPether(), "Should have less ETH");
        console.log("Interes: ", factoring.INTrate());
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        console.log("Profit TFA: ", factoring.TFAmybalance()-beforeBalance);
        console.log("Profit ETH: ", eth_value-factoring.LPether());
    }

    /// #sender: account-5
    function checkProfit5() public {
        uint256 beforeBalance = factoring.TFAmybalance();
        uint256 eth_value = factoring.LPether();
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        factoring.FINgetProfit();
        Assert.ok(factoring.TFAmybalance()>beforeBalance, "Should have more TFAs");
        Assert.ok(eth_value>factoring.LPether(), "Should have less ETH");
        console.log("Interes: ", factoring.INTrate());
        console.log("TFA Pool: ", factoring.LPtokens());
        console.log("ETH Pool: ", factoring.LPether());
        console.log("Profit TFA: ", factoring.TFAmybalance()-beforeBalance);
        console.log("Profit ETH: ", eth_value-factoring.LPether());
    }

    function checkState() external {
        Assert.ok(factoring.LPtokens()>1349*10**18, "Should have more TFAs");
        Assert.ok(factoring.LPtokens()<1351*10**18, "Should have more TFAs");
        Assert.ok(factoring.LPether()>9110000000000000000, "Should have more TFAs");
        Assert.ok(factoring.LPether()<9140000000000000000, "Should have more TFAs");        
    }

}