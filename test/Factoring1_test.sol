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
    Factoring public factoring2;
    Factoring public factoring3;
    Factoring public factoring4;
    Factoring public factoring5;

    function beforeAll() public {
        factoring = new Factoring();
        factoring.DOCnewFile("FACTURA.pdf", 12000 * 10**18, 30);

        factoring2 = new Factoring();
        factoring2.DOCnewFile("FACTURA.pdf", 27 * 10**17 ,30);

        factoring3 = new Factoring();
        factoring3.DOCnewFile("FACTURA.pdf", 1* 10**18 ,30);

        factoring4 = new Factoring();
        factoring4.DOCnewFile("FACTURA.pdf", 10000000 ,30);

        factoring5 = new Factoring();
        factoring5.DOCnewFile("FACTURA.pdf", 100, 30);
    }

    /// #sender: account-1
    /// #value: 12000000000000000000
    function checkStartFactoring() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 1000000000;
        factoring.start{value: msg.value}(ntokens);

        Assert.equal(factoring.LPether(), valor, "error value");
        Assert.equal(factoring.LPtokens(), ntokens*10**18, "error value");
    }

    /// #sender: account-2
    /// #value: 110000000000000000
    function checkStartFactoring2() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 95;
        factoring2.start{value: msg.value}(ntokens);

        Assert.equal(factoring2.LPether(), valor, "error value");
        Assert.equal(factoring2.LPtokens(), ntokens*10**18, "error value");
    }

    /// #sender: account-3
    /// #value: 0
    function checkStartFactoring3() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 10;
        try factoring3.start{value: msg.value}(ntokens) {
            Assert.ok(false, "Must be error");
        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    }

    /// #sender: account-3
    /// #value: 1
    function checkStartFactoring4() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 0;
        try factoring3.start{value: msg.value}(ntokens) {
            Assert.ok(false, "Must be error");
        }
        catch Error(string memory reason) {
            // catch failing revert() and require()
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            // catch failing assert()
            Assert.ok(true, "Must be true");
        }


    }

    /// #sender: account-4
    /// #value: 1000
    function checkStartFactoring5() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 4;
        
        factoring4.start{value: msg.value}(ntokens);

        Assert.equal(factoring4.LPether(), valor, "error value");
        Assert.equal(factoring4.LPtokens(), ntokens*10**18, "error value");
    }

    /// #sender: account-5
    function checkStartFactoring6() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 4;
        try factoring5.start{value: msg.value}(ntokens) {
            Assert.ok(false, "Must be error");
        }
        catch Error(string memory reason) {
            // catch failing revert() and require()
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            // catch failing assert()
            Assert.ok(true, "Must be true");
        }
    }

    /// #sender: account-5
    /// #value: 10
    function checkStartFactoring7() public payable {
        uint256 valor = msg.value;
        uint256 ntokens = 1;
        factoring5.start{value: msg.value}(ntokens);

        Assert.equal(factoring5.LPether(), valor, "error value");
        Assert.equal(factoring5.LPtokens(), ntokens*10**18, "error value");
    }
   
}
    