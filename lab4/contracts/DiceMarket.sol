pragma solidity ^0.5.0;
import "./Dice.sol";

contract DiceMarket {

    Dice diceContract;
    uint256 public comissionFee;
    address _owner = msg.sender;
    mapping(uint256 => uint256) listPrice;

    event created_dm(uint256 fee);
    event battlewin(uint256 id1, uint256 id2);
    event battleDraw(uint256 id1, uint256 id2);

     constructor(Dice diceAddress, uint256 fee) public {
        diceContract = diceAddress;
        comissionFee = fee;
        emit created_dm(fee);
    }

    modifier prevOwnerOnly(uint256 id) {
        require(msg.sender == diceContract.getPrevOwner(id), "You are not the previous owner");
        _;
    }

    //list a dice for sale. Price needs to be >= value + fee
    event listed (uint256 id, uint256 price);
    function list(uint256 id, uint256 price) public prevOwnerOnly(id) {
       require(price >= diceContract.getDiceValue(id) + comissionFee, "Price is too low");
       listPrice[id] = price;
       emit listed(id, price);

    }

    event unlisted(uint256 id);
    function unlist(uint256 id) public {
       require(msg.sender == diceContract.getPrevOwner(id));
       listPrice[id] = 0;
       emit unlisted(id);
  }

    // get price of dice
    function checkPrice(uint256 id) public view returns (uint256) {
       return listPrice[id];
 }

    // Buy the dice at the requested price
    event bought(uint256 id);
    function buy(uint256 id) public payable {
       require(listPrice[id] != 0); //is listed
       require(msg.value >= (listPrice[id] + comissionFee)); //offerred price meets minimum ask

       address payable recipient = address(uint160(diceContract.getPrevOwner(id)));
       recipient.transfer(msg.value - comissionFee);    //transfer (price-comissionFee) to real owner
       diceContract.transfer(id, msg.sender);
       emit bought(id);
    }

    function getContractOwner() public view returns(address) {
       return _owner;
    }

    function withDraw() public {
        if(msg.sender == _owner)
            msg.sender.transfer(address(this).balance);
    }
}
