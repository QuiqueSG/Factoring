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

    /// #sender: account-1
    /// #value: 12000000000000000000
    function beforeAll() public payable {
        factoring = new Factoring();
        factoring.DOCnewFile("FACTURA.pdf", 12000 * 10**18, 30);
        factoring.start{value: msg.value}(1000000000);
        tokens = factoring.LPtokens();
        ethers = factoring.LPether();
    }

    /// #sender: account-2
    /// #value: 14900000000000000
    function checkETH() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
        Assert.ok(ethers < factoring.LPether(), "Should have more ethers");
        Assert.ok(tokens > factoring.LPtokens(), "Should have more tokens");
    }

    /// #sender: account-1
    function checkArbit() public {
        factoring.FINarbit();
        Assert.ok(tokens/10==factoring.LPtokens()/10, "Should have same tokens as beginning");
        Assert.ok(ethers/10==factoring.LPether()/10, "Should have same ethers as beginning");
    }

    /// #sender: account-2
    /// #value: 34000000000000000
    function checkETH2() public payable {
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
        uint256 pastTokens = factoring.TFAmybalance();
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>pastTokens, "Should have more TFAs than before");
        Assert.ok(ethers < factoring.LPether(), "Should have more ethers");
        Assert.ok(tokens > factoring.LPtokens(), "Should have more tokens");
    }

    /// #sender: account-1
    function checkArbit2() public {
        this.checkArbit();
    }

    /// #sender: account-3
    /// #value: 7200000000000000
    function checkETH3() public payable {
        Assert.ok(factoring.TFAmybalance()==0, "Should have 0 TFAs");
        factoring.LPbuyERC{value: msg.value}();
        Assert.ok(factoring.TFAmybalance()>0, "Should have more than 0 TFAs");
        Assert.ok(ethers < factoring.LPether(), "Should have more ethers");
        Assert.ok(tokens > factoring.LPtokens(), "Should have more tokens");
    }

    /// #sender: account-1
    function checkArbit3() public {
        this.checkArbit();
    }

    /// #sender: account-4
    /// #value: 0
    function checkETH4() public payable {

        try factoring.LPbuyERC{value: msg.value}() {

        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    }

    /// #sender: account-4
    function checkETH5() public payable {

        try factoring.LPbuyERC{value: msg.value}() {

        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    }
}   