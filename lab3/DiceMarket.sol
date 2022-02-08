pragma solidity ^0.5.0;
import "./Dice.sol";

// my version
contract DiceMarket {

    // contains dicecontract (which has a mapping of dices)
    Dice diceContract;
    uint256 public comissionFee;
    address _owner = msg.sender;
    mapping (uint256 => uint256) public listPrices;
    // mapping (uint256 => Dice) public unlisted;
    // list dice for sale
    // price >= value + comission
    // first transfer to dicemarket contract address
    // then list

    // create the contract
    // assign the contract to a dice address?
    // set comission fee
    // why does this make sense? it means
    // owner creates a dice market to sell his own dice
    // and loses the commission fee?

    constructor(Dice diceAddress, uint256 fee) public {
        diceContract = diceAddress;
        comissionFee = fee;
    }

    modifier prevOwnerOnly(uint256 id) {
        require(msg.sender == diceContract.getPrevOwner(id), "You are not the previous owner.");
        _;
    }

    // price needs to be >= value + fee
    function list(uint256 id, uint256 price_in_wei) public prevOwnerOnly(id) {
        // first transfer to dice to dice market contracts address
        // diceContract.transfer(id, address(this));
        uint256 curr_dice_val = diceContract.getDiceValue(id);
        require(price_in_wei >= curr_dice_val + comissionFee, "price not high enough");
        listPrices[id] = price_in_wei;
        
        
    }

    // // unlist dice from market
    // // once unlist: DONT transfer back to owner
    // // just delist, no one can buy
    function unlist(uint256 id) public prevOwnerOnly(id) {
        delete listPrices[id];

    }

    function checkPrice(uint256 id) public view returns (uint256) {
        // get price of dice
        return listPrices[id];
    }

    function buy(uint256 id) public payable {
        uint256 dice_price = checkPrice(id);
        require (msg.value > dice_price, "Value supplied not sufficient to buy the dice.");
        
        uint256 change = msg.value - dice_price;
        msg.sender.transfer(change);
        address payable recipient = address(uint160(diceContract.getPrevOwner(id)));
        recipient.transfer(dice_price - comissionFee);
        diceContract.transfer(id, msg.sender);
        // buy dice at the requested price
        // airtight solution: return any xtra $ to sender

        // return amount to seller
    }

    // set appropriate modifier to check for conditions
    // before allowing certain functions



    
}
