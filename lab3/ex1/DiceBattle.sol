pragma solidity ^0.5.0;
import "./Dice.sol";

/*
1. First create dice using the Dice contract
2. Transfer both die to this contract using the contract's address
3. Use setBattlePair from each player's account to decide enemy
4. Use the battle function to roll, stop rolling and then compare the numbers
5. The player with the higher number gets BOTH dice
6. If there is a tie, return the dice to their previous owner
*/


contract DiceBattle {
    Dice diceContract;
    mapping(address => address) public battle_pair;
    mapping(address => uint256) public person_dice_pair;

    constructor(Dice diceAddress) public {
        diceContract = diceAddress;
    }
    modifier prevOwnerOnly(uint256 id) {
        require(msg.sender == diceContract.getPrevOwner(id), "You are not the previous owner.");
        _;
    }

    function setDice(uint256 id) public prevOwnerOnly(id) {
        person_dice_pair[msg.sender] = id;
    }

    function setBattlePair(address enemy) public {
        // Require that only prev owner can allow an enemy
        // Each player can only select one enemy
        require(msg.sender == diceContract.getPrevOwner(person_dice_pair[msg.sender]), "You are not the previous owner, CANT SET");
        // require(battle_pair[msg.sender] == 0);
        battle_pair[msg.sender] = enemy;
    }

    function battle(uint256 myDice, uint256 enemyDice) public {
        address myDiceOwner = diceContract.getPrevOwner(myDice);
        address enemyDiceOwner = diceContract.getPrevOwner(enemyDice);
        // Require that battle_pairs align, ie each player has accepted a battle with the other
        require(battle_pair[myDiceOwner] == enemyDiceOwner, "A not paired to B");
        require(battle_pair[enemyDiceOwner] == myDiceOwner, "B not paired to A");
        // Run battle
        diceContract.roll(myDice);
        diceContract.stopRoll(myDice);
        uint8 myDiceVal = diceContract.getDiceNumber(myDice);

        diceContract.roll(enemyDice);
        diceContract.stopRoll(enemyDice);
        uint8 enemyDiceVal = diceContract.getDiceNumber(enemyDice);

        // check who won
        if (myDiceVal > enemyDiceVal) {
            diceContract.transfer(myDice, myDiceOwner);
            diceContract.transfer(enemyDice, myDiceOwner);
        } else if (enemyDiceVal > myDiceVal) {
            diceContract.transfer(myDice, enemyDiceOwner);
            diceContract.transfer(enemyDice, enemyDiceOwner);         
        } else {
            diceContract.transfer(myDice, myDiceOwner);
            diceContract.transfer(enemyDice, enemyDiceOwner);        
        }
    }

    //Add relevant getters and setters
}