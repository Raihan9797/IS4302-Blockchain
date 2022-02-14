// declare the contracts to make them exist in our env.
const Dice = artifacts.require("Dice");
const DiceMarket = artifacts.require("DiceMarket");

// then use deployer to deploy dice first
// then deploy DiceMarket by passing Dice's address to DiceMarket's constructor.
module.exports = (deployer, network, accounts) => {
    deployer.deploy(Dice).then(function() {
        return deployer.deploy(DiceMarket, Dice.address);
    });
};