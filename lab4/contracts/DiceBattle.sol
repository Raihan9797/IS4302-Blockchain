pragma solidity ^0.5.0;
import "./Dice.sol";

contract DiceBattle {
    Dice diceContract;
    mapping(address => address) battle_pair;

    constructor(Dice diceAddress) public {
        diceContract = diceAddress;
    }
    event add_enemy(address enemy);
    event battlewin(uint256 id1, uint256 id2);
    event battleDraw(uint256 id1, uint256 id2);

    function setBattlePair(address enemy) public {
        battle_pair[msg.sender] = enemy;
        emit add_enemy(enemy);
    }

    function battle(uint256 myDice, uint256 enemyDice) public {
        // Require that battle_pairs align, ie each player has accepted a battle with the other
        address mine = diceContract.getPrevOwner(myDice);
        address enemy = diceContract.getPrevOwner(enemyDice);

        require(battle_pair[mine] == enemy, "Not valid pair!");
        require(battle_pair[enemy] == mine, "Not valid pair!");

        diceContract.roll(myDice);
        diceContract.stopRoll(myDice);
        diceContract.roll(enemyDice);
        diceContract.stopRoll(enemyDice);

        if ( diceContract.getDiceNumber(myDice) > diceContract.getDiceNumber(enemyDice) ) {
            diceContract.transfer(myDice, diceContract.getPrevOwner(enemyDice)); //last owner before sending to DiceBattle
            diceContract.transfer(enemyDice, diceContract.getPrevOwner(enemyDice));
            emit battlewin(myDice,enemyDice);
        }
        if ( diceContract.getDiceNumber(myDice) < diceContract.getDiceNumber(enemyDice) ) {
            //ownership[enemyDice] = ownership[myDice];
            //unlist(enemyDice);
            diceContract.transfer(enemyDice,diceContract.getPrevOwner(myDice)); //last owner before sending to DiceBattle
            diceContract.transfer(myDice,diceContract.getPrevOwner(myDice));
            emit battlewin(enemyDice,myDice);
        }
        if ( diceContract.getDiceNumber(myDice) == diceContract.getDiceNumber(enemyDice) ) {
            emit battleDraw(myDice,enemyDice);
        }

    }

}