pragma solidity ^0.5.0;

contract Lab2Exercise {
    uint256[] sgd;
    uint256[] qty; // dynamic

    function check_arr (uint256[] memory arr) private pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] < 0) {
                return false;
            }
        }
        return true;
    }

    function add_Price(uint256[] memory prices) public {
        // bool is_valid = check_arr(prices);
        // require (is_valid == true, "Values not valid");
        sgd = prices;
    }

    function add_Qty(uint256[] memory arr) public {
        /*
        memory: dont save it in the blockchain
        to prevent us from paying money for just small things

        it will just be used temporarily and then thrown out
        */
        // bool is_valid = check_arr(arr);
        // require (is_valid == true, "Values not valid");
        qty = arr;
    }

    // solidity will actly recc u to "memory" some arrays!
    function check_length() private view returns (bool) {
        return (sgd.length == qty.length);
    }

    function total_Sales() public view returns (uint256) {
        bool is_same_length = check_length();
        require (is_same_length == true, "Length of variables not matched.");
        uint256 ret = 0;
        // loop through qty arr
        for (uint i=0; i<qty.length; i++) {
            uint256 to_add = qty[i] * sgd[i];
            ret = ret + to_add;
        }

        return ret;
    }

}