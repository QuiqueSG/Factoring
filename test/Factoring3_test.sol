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
    /// #value: 4700000000000000000
    function beforeAll() public payable {
        factoring = new Factoring();
        factoring.DOCnewFile("FACTURA.pdf", 55 * 10**18, 30);
        factoring.start{value: msg.value}(33000000);
        tokens = factoring.LPtokens();
        ethers = factoring.LPether();
    }   

    /// #sender: account-1
    /// #value: 580000000000000000
    function checkDeposit() public payable {
        factoring.LPdeposit{value: msg.value}();
        Assert.ok(ethers < factoring.LPether(), "Should have more ethers");
        Assert.ok(tokens < factoring.LPtokens(), "Should have more tokens");
    } 

    /// #sender: account-1
    function checkWithdraw() public payable {
        uint256 myBalance = msg.sender.balance;
        factoring.LPgetLiquidity(580000000000000000);
        Assert.ok(ethers==factoring.LPether(), "Should have same ethers");
        Assert.ok(tokens==factoring.LPtokens(), "Should have same tokens");
        Assert.ok(msg.sender.balance>myBalance, "Should have more ethers");
    }

    /// #sender: account-5
    /// #value: 330000000000000000
    function checkOtherDeposit() public payable {
        
        factoring.LPdeposit{value: msg.value}();
        Assert.ok(ethers < factoring.LPether(), "Should have more ethers");
        Assert.ok(tokens < factoring.LPtokens(), "Should have more tokens");
    } 

    /// #sender: account-6
    function checkOtherWithdraw() public payable {
        uint256 myBalance = msg.sender.balance;
        factoring.LPgetLiquidity(330000000000000000);
        Assert.ok(ethers==factoring.LPether(), "Should have same ethers");
        Assert.ok(tokens==factoring.LPtokens(), "Should have same tokens");
        Assert.ok(msg.sender.balance>myBalance, "Should have more ethers");

    }

    /// #sender: account-1
    /// #value: 0
    function checkCeroDeposit() public payable {
        
        try factoring.LPdeposit{value: msg.value}() {
            Assert.ok(false, "Should fail");

        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    } 

    /// #sender: account-1
    function checkNoDeposit() public payable {
        
        try factoring.LPdeposit{value: msg.value}() {
            Assert.ok(false, "Should fail");

        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    } 

}