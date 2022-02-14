// declare the contracts to make them exist in our env.
const Dice = artifacts.require("Dice");
const DiceBattle = artifacts.require("DiceBattle");

// then use deployer to deploy dice first
// then deploy DiceBattle by passing Dice's address to DiceBattle's constructor.
module.exports = (deployer, network, accounts) => {
    deployer.deploy(Dice).then(function() {
        return deployer.deploy(DiceBattle, Dice.address);
    });
};