// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Interest.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Interest public intFee;
    Interest public intFee1;
    Interest public intFee2;
    Interest public intFee3;
    Interest public intFee4;

    function beforeAll() public {
        intFee = new Interest(15);
        intFee1 = new Interest(15);
        intFee2 = new Interest(12);
        intFee3 = new Interest(35);
        intFee4 = new Interest(6);

    }

    function checkInterest() public {
        intFee.adjustIntCol(100, 86);
        Assert.ok(intFee.rate() >= 13875000000000000000, "Ha de valer 13,875%");
        try intFee.adjustIntCol(100, 86) {
            Assert.ok(false, "Must be false");
        }
        catch Error(string memory reason) {
            Assert.ok(true, "Must be true");
        } 
        catch (bytes memory reason) {
            Assert.ok(true, "Must be true");
        }
        

    }    

    function checkInterest1() public {
        intFee1.adjustIntCol(120 * 10**18, 24000000000000000000);
        Assert.ok(intFee1.rate() >= 15750000000000000000, "Ha de valer 15,75%");
    }  

    function checkInterest2() public {
        intFee2.adjustIntCol(27 * 10**17, 100000000000000000);
        Assert.ok(intFee2.rate() >= 37750000000000000000, "Ha de valer 50,75%");
    }
    
    function checkInterest3() public {
        intFee3.adjustIntCol(10**18, 4* 10**17);
        intFee3.adjustIntVerify();
        intFee3.adjustIntDoc();

        Assert.ok(intFee3.rate() >= 20097656250000000000 , "Ha de valer 26,25%");
    }

    function checkInterest4() public {
        intFee4.adjustIntCol(100000000000000000, 100000000000000000);
        Assert.ok(intFee4.rate() >= 4500000000000000000, "Ha de valer 37,5%");
    }           

}