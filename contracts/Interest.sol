// SPDX-License-Identifier: GPL-3.0

pragma solidity^0.8.15;

contract Interest {


    uint256 public rate;
    uint256 private dec;
    bool private collateralOnce;
    bool private verifiedOnce;

    constructor(uint256 _init){
        dec = 18;
        rate = _init * 10 ** dec;
        collateralOnce = false;
        verifiedOnce = false;
    }

    function adjustIntVerify() public {
        if (!verifiedOnce){
            reduction();
            verifiedOnce = true;
        }
    }

    function adjustIntDoc() public {
        reduction();
    }

    function adjustIntCol(uint256 val, uint256 col) public {
        require(!collateralOnce, "Already executed");
        uint256 valueDec = (val * 10 ** dec);
        uint256 colDec = (col * 10 ** dec);
        uint256 actualRef = valueDec/col;
        uint256 ref = 1250000000000000000;

        if (ref <= actualRef){
            rate += (actualRef-ref);
        }
        else{
            uint256 x = (rate*125) / (val*100);
            uint256 colRes = (valueDec * 80)/100;
            uint256 difCol = colDec - colRes;
            uint256 res = (x * difCol)/(10**dec);
            rate -= res;
        }

        collateralOnce = true;
    }

    function reduction() private {
        rate = (rate * 7) /8;
    }

    function mul(uint256 amount) public view returns(uint256){
        return amount + ((amount * rate)/100)/(10**dec);

    }


}