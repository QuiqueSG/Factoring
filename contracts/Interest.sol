// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Interest {


    uint256 public rate;
    uint256 private dec;
    bool private collateralOnce;
    bool private verifiedOnce;
    uint256 private constant MAX = 100000000000000000000;
    uint256 private constant MIN = 3000000000000000000;
    uint256 private REF = 1250000000000000000;



    constructor(uint256 _init){
        dec = 18;
        rate = _init * 10 ** dec;
        collateralOnce = false;
        verifiedOnce = false;
    }

    function adjustIntVerify() external {
        if (!verifiedOnce){
            reduction();
            verifiedOnce = true;
        }
    }

    function adjustIntDoc() external {
        reduction();
    }

    function adjustIntCol(uint256 val, uint256 col) external {
        require(!collateralOnce, "Already executed");
        uint256 valueDec = (val * 10 ** dec);
        uint256 actualRef = valueDec/col;

        if (REF <= actualRef){
            rate += (actualRef-REF);
            if (rate > MAX) {
                rate = MAX;
            }
        }
        else{
            
            uint256 dos = (2 * 10 ** dec);
            uint256 res = (REF*col)/val;
            if (res > dos) {
                rate = MIN;
            }
            else{
                rate = (rate * (dos - res)) / (10**dec);
            }

            if (rate < MIN){
                rate = MIN;
            }
        }

        collateralOnce = true;
    }

    function reduction() private {
        rate = (rate * 7) /8;
    }

    function mul(uint256 amount) external view returns(uint256){
        return amount + ((amount * rate)/100)/(10**dec);

    }


}