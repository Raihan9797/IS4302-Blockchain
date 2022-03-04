const Dice = artifacts.require("Dice");
const DiceMarket = artifacts.require("DiceMarket");
const web3 = require('web3'); // NEED THIS

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Dice).then(function() {
      return deployer.deploy(DiceMarket, Dice.address, web3.utils.toBN(1e18));
  });
};