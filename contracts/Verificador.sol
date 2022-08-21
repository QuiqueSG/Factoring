// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Verificacio{

    //1. Contract attributes

    // First, the owner of the document
    address public owner;

    // Document information
    string public payer;
    string public filename;

    // Trust attributes
    string public hash;
    string public link;

    // Validators
    address[] public validators;
    // Deniers
    address[] public denegators;

    // Map with users that validated the document
    mapping (address=>bool) public validations;
    // Map with users that don't trust the document
    mapping (address=>bool) public denegations;


    //3. VALIDATE
    event Validation(address indexed validador, string asset);

    function validate() external {
        require(owner != tx.origin, "Owner cannot validate his own document");
        require(!validations[tx.origin], "Repeated validator");
        require(!denegations[tx.origin], "You cannot validate and deny at the same time");
        validators.push(tx.origin);
        validations[tx.origin] = true;

        emit Validation(tx.origin, filename);

    }

    //4. DENY
    event Denegation(address indexed denegador, string asset);

    function denegate() external {
        require(owner != tx.origin, "Owner cannot deny his own document");
        require(!denegations[tx.origin], "Repeated denegator");
        require(!validations[tx.origin], "You cannot validate and deny at the same time");
        denegators.push(tx.origin);
        denegations[tx.origin] = true;

        emit Denegation(tx.origin, filename);

    }

    function checkValidation() external view returns(bool){
        uint256 den = denegators.length;
        uint256 val = validators.length;

        return (den == 0 && val >= 5) || (den != 0 && val>(den*5));

    }    



    //Getters
    function hasValidated(address _user) external view returns(bool) {
        require(owner != _user);
        return validations[_user];
    }

    function hasDenied(address _user) external view returns(bool) {
        require(owner != _user);
        return denegations[_user];
    }

    function nValidations() external view returns(uint256) {
        return validators.length;
    }

    function nDenegations() external view returns(uint256) {
        return denegators.length;
    }

    //SETTERS

    function setOwner(address user) external {
        owner = user;
    }

    function setFilename(string memory name) external {
        filename = name;
    }

    function setPayer(string memory _payer) external {
        payer = _payer;
    }

    function setHashDoc(string memory _hash) external {
        hash = _hash;
    }  

    function setLinkDoc(string memory _link) external {
        link = _link;
    }  


}