// SPDX-License-Identifier: GPL-3.0

pragma solidity^0.8.15;

contract Verificacio{

    //1. Elements del contracte

    // Primer identifiquem el owner del document
    address public owner;

    // Nom del document
    string public payer;
    string public filename;
    string public hash;
    string public link;

    // validators del document
    address[] public validators;
    // No validators del document
    address[] public denegators;

    // Mapa de comprovació de les validations amb un comentari
    mapping (address=>bool) public validations;
    // Mapa de comprovació de les denegations amb un comentari
    mapping (address=>bool) public denegations;


    //3. VALIDAR
    event Validation(address indexed validador, string asset);

    function validate() public {
        require(owner != tx.origin, "El owner no pot validar el seu asset");
        require(!validations[tx.origin], "Validador repetit");
        require(!denegations[tx.origin], "No pots validar i denegar alhora");
        validators.push(tx.origin);
        validations[tx.origin] = true;

        emit Validation(tx.origin, filename);

    }

    //4. DENEGAR
    event Denegation(address indexed denegador, string asset);

    function denegate() public {
        require(owner != tx.origin, "El owner no pot validar el seu asset");
        require(!denegations[tx.origin], "Denegador repetit");
        require(!validations[tx.origin], "No pots validar i denegar alhora");
        denegators.push(tx.origin);
        denegations[tx.origin] = true;

        emit Denegation(tx.origin, filename);

    }

    function checkValidation() public view returns(bool){
        uint256 den = nDenegations();
        uint256 val = nValidations();

        return (den == 0 && val >= 5) || (den != 0 && val>(den*5));

    }    



    //Getters
    function hasValidated(address _user) public view returns(bool) {
        require(owner != _user);
        return validations[_user];
    }

    function hasDenied(address _user) public view returns(bool) {
        require(owner != _user);
        return denegations[_user];
    }

    function getOwner() external view returns(address){
        return owner;
    }

    function getFilename() external view returns(string memory){
        return filename;
    }

    function nValidations() public view returns(uint256) {
        return validators.length;
    }

    function nDenegations() public view returns(uint256) {
        return denegators.length;
    }

    //SETTERS

    function setOwner(address user) public {
        owner = user;
    }

    function setFilename(string memory name) public {
        filename = name;
    }

    function setPayer(string memory _payer) public {
        payer = _payer;
    }



    function setHashDoc(string memory _hash) public {
        hash = _hash;
    }  

    function setLinkDoc(string memory _link) public {
        link = _link;
    }  


}