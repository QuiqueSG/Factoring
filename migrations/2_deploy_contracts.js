//This is for deploying into the Ganache local blockchain, to deploy into a testnet or mainnet:
// https://trufflesuite.com/blog/an-easier-way-to-deploy-your-smart-contracts/
//  https://www.npmjs.com/package/@truffle/hdwallet-provider


var Factoring = artifacts.require("./Factoring.sol");

module.exports = function(deployer, accounts){
    deployer.deploy(Factoring);
}

