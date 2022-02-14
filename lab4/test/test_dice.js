// require contracts to be deployed
// require assertion frameworks to be correctly initialized
const _deploy_contracts = require("../migrations/2_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');
const { isTypedArray } = require("util/types");


// create vars to represent these contracts
var Dice = artifacts.require("../contracts/Dice.sol");
var DiceBattle = artifacts.require("../contracts/DiceBattle.sol")

// establish testing

contract('DiceBattle', function(accounts) {

    // wait for both contracts to be deployed before starting any testing
    before(async () => {
        diceInstance = await Dice.deployed();
        diceBattleInstance = await DiceBattle.deployed();
    });
    console.log("Testing Trade Contract");

    // Test 1: test ability to get dice
    it('Get Dice', async () => {
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

    // Test 2: test transfer ownership
    it('transfer ownership of dice', async() => {
        let t1 = await diceInstance.transfer(0, diceBattleInstance.address, {from: accounts[1]});
        let t2 = await diceInstance.transfer(1, diceBattleInstance.address, {from: accounts[2]});

        let enemy_adj1 = await diceBattleInstance.setBattlePair(accounts[2], {from: accounts[1]})
        let enemy_adj2 = await diceBattleInstance.setBattlePair(accounts[1], {from: accounts[2]})

        truffleAssert.eventEmitted(enemy_adj1, 'add_enemy');
        truffleAssert.eventEmitted(enemy_adj2, 'add_enemy');
    })

    // Test 3: Test dice battle working properly
    it('DiceBattle working properly', async () => {
        let doBattle = await diceBattleInstance.battle(0, 1, {from: accounts[1]});
        console.log(doBattle);
        truffleAssert.eventEmitted(doBattle, 'battlewin');
    })

});

