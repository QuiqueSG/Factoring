// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Verificador.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Verificacio public verifier;

    /// #sender: account-1
    function beforeAll() public {
        verifier = new Verificacio();
        verifier.setOwner(msg.sender);
    }

    /// #sender: account-1
    function verifyAcc1() public {
        try verifier.validate() {
            Assert.ok(false, "Should be false");
        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
    }

    /// #sender: account-2
    function verifyAcc2() public {
        verifier.validate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");
    }

    /// #sender: account-3
    function verifyAcc3() public {
        verifier.validate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");

    }

    /// #sender: account-4
    function verifyAcc4() public {
        verifier.validate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");

    }

    /// #sender: account-5
    function verifyAcc5() public {
        verifier.validate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");
    }

    /// #sender: account-6
    function verifyAcc6() public {
        verifier.validate();
        Assert.equal(verifier.checkValidation(), true, "Should be true");
    }

    /// #sender: account-7
    function denyAcc7() public {
        verifier.denegate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");
    }

    /// #sender: account-8
    function denyAcc8() public {
        verifier.denegate();
        Assert.equal(verifier.checkValidation(), false, "Should be false");
    }

}