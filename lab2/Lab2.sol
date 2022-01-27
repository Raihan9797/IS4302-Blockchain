pragma solidity ^0.5.0;

contract Lab2 {
    uint256 sgd;
    uint256[] qty; // dynamic

    function add_Price(uint256 price) public {
        // require (price > 0, "invalid Price!");
        sgd = price;
    }
    function add_Qty(uint256[] memory arr) public {
        /*
        memory: dont save it in the blockchain
        to prevent us from paying money for just small things

        it will just be used temporarily and then thrown out
        */
        qty = arr;

    }

    function total_Sales() public view returns (uint256) {
        uint256 ret = 0;

        // loop through qty arr
        for (uint i=0; i<qty.length; i++) {
            uint256 to_add = qty[i] * sgd;
            ret = ret + to_add;
        }

        return ret;
    }


}