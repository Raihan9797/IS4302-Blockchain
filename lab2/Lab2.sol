pragma solidity ^0.5.0;

contract Lab2 {
    uint256 sgd;
    uint256[] qty; // dynamic

    function add_Price(uint256 price) public {
        require (price > 0, "invalid Price!");
        sgd = price;
    }
    // some functions actually
    // cant be seen by others even if everything
    // can be "seen" in the blockchain
    // eg. some guy hides his multiply fn to prevent
    // other ppl from using his fn.

    // sgdrediscover voucher is a token
    // sgd is a currency
    // we have a public transfer fn
    // but we have internal fns like those needing to check

    function add_Qty(uint256[] memory arr) public {
        /*
        memory: dont save it in the blockchain
        to prevent us from paying money for just small things

        it will just be used temporarily and then thrown out
        */
        qty = arr;

    }

    // solidity will actly recc u to "memory" some arrays!

    function total_Sales() public view returns (uint256) {
        uint256 ret = 0;

        // loop through qty arr
        for (uint i=0; i<qty.length; i++) {
            uint256 to_add = qty[i] * sgd;
            ret = ret + to_add;
        }

        return ret;
    }

    // we view because we are NOT changing anything!
    // we loop through the eles, but we never change anyth
    // view = no change or commits to blockchain => no gas fees!


    // pure: doesnt even look at the contract
    // payable: able ot receive ether
    // compiler will tell u if u need to view!


}

// compile then deploy

// what happens when ppl spam view: vibhu will check

// contracts can own other contracts
// smart contracts are used when you dont want users to be involved
/* eg. nft auction house
customers want to see all of the available nfts
instead of searching through the auction house address and see the blockchain
we can just use contracts to automate this process

basically a program in the blockchain
*/