pragma solidity ^0.5.0;
import "./Dice.sol";
import "./DiceToken.sol";

// my version
contract DiceMarket {

    // contains dicecontract (which has a mapping of dices)
    Dice diceContract;
    DiceToken diceTokenContract;

    uint256 public comissionFee; // 
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

    constructor(Dice diceAddress, DiceToken diceTokenAddress, uint256 fee_in_dt) public {
        diceContract = diceAddress;
        diceTokenContract = diceTokenAddress;
        comissionFee = fee_in_dt; // now in dt
    }

    modifier prevOwnerOnly(uint256 id) {
        require(msg.sender == diceContract.getPrevOwner(id), "You are not the previous owner.");
        _;
    }

    function convert_eth_to_dt(uint256 eth_amt) public pure returns (uint256) {
        return eth_amt / 10000000000000000;
    }

    // price needs to be >= value + fee
    function list(uint256 id, uint256 price_in_dt) public prevOwnerOnly(id) {
        // first transfer to dice to dice market contracts address
        // get dice val in eth, convert to dt
        uint256 curr_dice_val = diceContract.getDiceValue(id);
        uint256 curr_dice_val_in_dt = convert_eth_to_dt(curr_dice_val);
        
        // check priceindt > curr_diceval in dt + comm fee
        require(price_in_dt >= curr_dice_val_in_dt + comissionFee, "price in dt not high enough");
        listPrices[id] = price_in_dt;
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

    function checkBuyerDt() public view returns (uint256) {
        return diceTokenContract.checkCreditAddress(msg.sender);
    }

    function buy(uint256 id) public payable {
        // check if buyer has enough dt to buy dice
        uint256 buyer_dt = checkBuyerDt();
        uint256 dice_price = checkPrice(id);
        require (buyer_dt > dice_price, "dt balance not sufficient to buy dice.");
        
        uint256 dt_for_seller = dice_price - comissionFee; 
        // lister gets money (price - comm)
        address payable recipient = address(uint160(diceContract.getPrevOwner(id)));
        diceTokenContract.transferDt(recipient, dt_for_seller);
        diceTokenContract.transferDt(_owner, comissionFee);

        // buyer gets dice
        diceContract.transfer(id, msg.sender);
    }

    // set appropriate modifier to check for conditions
    // before allowing certain functions



    
}
