# lab 2 notes

## Basic Data types
1. bool
2. enum <name> {<member names> ...}
    - eg. enum direction {left, right, up, down}
3. int, uint, int8, uint8, int16, uint16, ... uint256
    - signed and unsigned integers (with size, defaults to 256)
    - eg. int == int256
    - unsigned: NO NEGATIVE VALUES
    - int8 => 1 byte signed integer
4. address - holds a 20 byte address
5. contract
6. Bytes1... Bytes32 - fixed size byte array
7. String

* we can specify the sizes of different ints because anything stored on the blockchain very ex.
* so best to declare fixed size array when possible 

## complex data types
* by default these are defined as storage ie will be written onto the blockchain.
1. bytes - dynamic array of bytes
1. hashmap: O(1) lookup
2. struct: like an object


## functions: very verbose
- prevent ambiguity because the creators are scared of side effects, lost coins etc..
- some functions actually cant be seen by others even if everything can be "seen" in the blockchain
- eg. some guy hides his multiply fn to prevent, other ppl from using his fn.
- sgRediscover voucher is a token, sgd is a currency, we have a public transfer fn, but we have internal fns like those needing to check

### Function modifiers
* solidity will actly recc u to "memory" some arrays!
    - `memory` basically tells the compiler this is a temp arr, not something that will need to be logged on the blockchain

* use `view` when we are NOT changing anything in the contract!
    - does not change state variables
    - computation done ON LOCAL MACHINE
    - we loop through the eles, but we never change anyth
    - view = no change or commits to blockchain => no gas fees!
    - compiler will tell you if you need to use view

* `pure`: variables in this functions do not come from the Contract
    - does not access state variables at all.
    - eg. for the add_Price(uint256 price), we can first check if the value is valid eg. must be > 10 before assigning it to the contract.
    - as of right now, this `price` variable is not related to the contract yet and thus the compiler will recommend you use the `pure` keyword.

* `payable`: able ot receive ether

## Compile then deploy


## Extra questions and pointers after the lab
1. what happens when ppl spam view? As of rn, t

* contracts can own other contracts
* smart contracts are used when you dont want users to be involved

eg. Of smart contract use: nft auction house
1. customers want to see all of the available nfts
2. instead of searching through the auction house address and see the blockchain
3. we can just use contracts to automate this process
* basically a program in the blockchain
