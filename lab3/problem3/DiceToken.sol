pragma solidity ^0.5.0;
import "./ERC20.sol";

contract DiceToken {
    /*
    Issue a ERC-20 token, DT (DiceToken), such that
    • It complies with ERC-20 Interface
    • The total supply is 10,000 tokens, issued to the owner during the creating of DT
    • Anyone can top up DT, with the price of 0.01 Eth per DT
    • When the supply is not enough (e.g., someone wants to top up 200DT, but there is 
    only 100DT left in the owner’s account), return with error message “DT supply is not 
    enough”.
    • Hint: We’ll be using the ERC20 contract accessible in the appendix
    */
    ERC20 erc20Contract;
    uint256 supplyLimit;
    uint256 currentSupply;
    address owner;

    constructor() public {
        erc20Contract = new ERC20();
        supplyLimit = 10000;
        // currentSupply = 0;
        owner = msg.sender;
    }

    // modifier enoughSupply(uint256 amt) public view returns bool {
    //     require(amt + currentSupply <= supplyLimit, "not enough DTs");
    //     _;
    // }
    // take eth and return dt based on 0.01 eth exchange rate
    function getCredit() public payable {
        uint256 dt_amt = msg.value / 10000000000000000;
        require(dt_amt + currentSupply <= supplyLimit, "not enough dts");
        currentSupply += dt_amt;
        erc20Contract.mint(msg.sender, dt_amt);

    }

    function checkCredit() public view returns (uint256) {
        return erc20Contract.balanceOf(msg.sender);
    }

    function checkCurrentSupply() public view returns (uint256) {
        return currentSupply;
    }

}