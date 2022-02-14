// require contracts to be deployed
// require assertion frameworks to be correctly initialized
const _deploy_contracts = require("../migrations/21_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');
const { isTypedArray } = require("util/types");
const web3 = require('web3');


// create vars to represent these contracts
var Dice = artifacts.require("../contracts/Dice.sol");
var DiceMarket = artifacts.require("../contracts/DiceMarket.sol")

// establish testing

// 1.	Test the creation of the dice
// 2.	Test that if ether is not supplied to the Dice contract’s add function, an error is returned
// 3.	Test that the Dice can be transferred to the DiceMarket contract
// 4.	Test that a Die cannot be listed if the price is less than value + commission
// 5.	Test that a Dice can be listed 
// 5.1	Non previous owners cannot list a dice 
// 6.	Test that the owner can unlist a die
// 7.	Test that another party can buy the die

contract('DiceMarket', function(accounts) {

    // wait for both contracts to be deployed before starting any testing
    before(async () => {
        diceInstance = await Dice.deployed();
        diceMarketInstance = await DiceMarket.deployed();
    });
    console.log("Testing Dice Market Contract");

// 1.	Test the creation of the dice
    it('Create Dice', async () => {
        let makeD1 = await diceInstance.add(1, 1, {from: accounts[1], value: 1e18})
        let makeD2 = await diceInstance.add(30, 1, {from: accounts[2], value: 1e18})

        assert.notStrictEqual(
            makeD1,
            undefined,
            "Failed to make dice 1"
        );

        assert.notStrictEqual(
            makeD2,
            undefined,
            "Failed to make dice 2"
        );
    })

// 2.	Test that if ether is not supplied to the Dice contract’s add function, an error is returned
    it('Supply not enough ether', async() => {

        truffleAssert.fails(
            diceInstance.add(1, 1, {from: accounts[1], value: 1e10}),
            truffleAssert.ErrorType.REVERT,
            "at least 0.01 ETH is needed to spawn a new dice"
        );
    })

// 3.	Test that the Dice can be transferred to the DiceMarket contract
    it('Transfer Dice to DiceMarket', async () => {
        let t1 = await diceInstance.transfer(0, diceMarketInstance.address, {from: accounts[1]});
        truffleAssert.eventEmitted(t1, "transferred");

        let t2 = await diceInstance.transfer(1, diceMarketInstance.address, {from: accounts[2]});
        truffleAssert.eventEmitted(t2, "transferred");
    })

// 3.1	Only owners can transfer dice
    it('Only owners can transfer dice', async () => {
        await truffleAssert.fails(
            diceInstance.transfer(0, diceMarketInstance.address, {from: accounts[1]}),
            truffleAssert.ErrorType.REVERT,
            "You are not the owner"
        )
    })

// 4.	Test that a Die cannot be listed if the price is less than value + commission
    it('Dice cannot be listed if price < val + commission', async () => {
        await truffleAssert.fails(
            diceMarketInstance.list(
                0, 
                web3.utils.toBN(1e18 + 1e9),
                {from: accounts[1]}
            ),
            truffleAssert.ErrorType.REVERT,
            "Price is too low"
        );

    })

// 5.	Test that a Dice can be listed 
    it('Dice can be listed', async () => {
        let listing1 = await diceMarketInstance.list(
            0, 
            web3.utils.toBN(1e18 + 1e10),
            {from: accounts[1]}
        );
        truffleAssert.eventEmitted(listing1, "listed");

        let listing2 = await diceMarketInstance.list(
            1, 
            web3.utils.toBN(1e18 + 1e10),
            {from: accounts[2]}
        );
        truffleAssert.eventEmitted(listing2, "listed");
    })

// 5+.	Non owners cannot list dice
    it('Non previous owners cannot list dice', async () => {
        // try and let owner1 list dice2
        await truffleAssert.fails(
            diceMarketInstance.list(
                1, 
                web3.utils.toBN(1e18 + 1e10),
                {from: accounts[1]}
            ),
            truffleAssert.ErrorType.REVERT,
            "You are not the previous owner"
        )

        // let owner2 list dice2
        let listing2 = await diceMarketInstance.list(
            1, 
            web3.utils.toBN(1e18 + 1e10),
            {from: accounts[2]}
        );
        truffleAssert.eventEmitted(listing2, "listed");
    })

// 6.	Test that the owner can unlist a die
    it('Owner can unlist a dice', async () => {
        let unlisting1 = await diceMarketInstance.unlist(
            0, 
            {from: accounts[1]}
        );
        truffleAssert.eventEmitted(unlisting1, "unlisted");

        let unlisting2 = await diceMarketInstance.unlist(
            1, 
            {from: accounts[2]}
        );
        truffleAssert.eventEmitted(unlisting2, "unlisted");
    })

// 7.	Test that another party can buy the die
    it('Another user can buy dice', async () => {
        let listing2 = await diceMarketInstance.list(
            1, 
            web3.utils.toBN(1e18 + 1e10),
            {from: accounts[2]}
        );
        truffleAssert.eventEmitted(listing2, "listed");

        let acct1_buys_d1 = await diceMarketInstance.buy(
            1, 
            {from: accounts[1], value: 1e18 + 1e11}
        );
        truffleAssert.eventEmitted(acct1_buys_d1, "bought");

    })
});

