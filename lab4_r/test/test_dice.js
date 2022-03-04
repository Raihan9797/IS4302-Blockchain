const _deploy_contracts = require('../migrations/2_deploy_contracts');
const truffleAssert = require('truffle-assertions');
var assert = require('assert');

var Dice = artifacts.require("../contracts/Dice.sol");
var DiceMarket = artifacts.require("../contracts/DiceMarket.sol");

contract('DiceBattle', function(accounts) {

    before(async() =>{
        diceInstance = await Dice.deployed();
        diceMarketInstance = await DiceMarket.deployed();

    });
    console.log("Testing Trade Contract");

    it('get dice', async () => {
        let makeD1 = await diceInstance.add(1, 1, {from: accounts[1], value: 1e17})
        let makeD2 = await diceInstance.add(30, 1, {from: accounts[2], value: 1e18})

        assert.notStrictEqual(
            makeD1,
            undefined,
            'Failed to make dice'
        );
        assert.notStrictEqual(
            makeD2,
            undefined,
            'Failed to make dice'
        );
    })

    it('Transfer ownership of dice', async () =>{
        let t1 = await diceInstance.transfer(0, diceMarketInstance.address, {from: accounts[1]});
        let t2 = await diceInstance.transfer(1, diceMarketInstance.address, {from: accounts[2]});

        truffleAssert.eventEmitted(t1, 'transferred');
        truffleAssert.eventEmitted(t2, 'transferred');
    })

    it('Wrong owner transfer', async () =>{
            truffleAssert.reverts(
                diceInstance.transfer(0, diceMarketInstance.address, {from: accounts[1]}),
            );
    })

});