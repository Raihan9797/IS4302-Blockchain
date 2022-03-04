# Lab 4: Unit Testing using Truffle, Ganache
* The assignment (the .docx file) guides us using Dice.sol and DiceBattle.sol. However, there are some issues that are unresolved especially (point 3: making the dice battle)
* Nevertheless, it's a good template to start with for testing DiceMarket.sol

## 1. Installation notes
1. Install node.js
2. Install truffle: `npm install -g truffle@5.4.29`
    - You can try installing without specifying a version number, but I had a lot of issues
3. Install Ganache
    - For windows 10 users who go to the site to download, you will get an `.appx` file. Copy the location of the `.appx` file
    - Open powershell and move to the file location.
    - run `Add-AppxPackage -Path .\Ganache-2.5.4-win-x64.appx` eg.
    ```
    PS C:\Users\Raihan\Downloads> Add-AppxPackage -Path .\Ganache-2.5.4-win-x64.appx
    ```
4. Install Web3: `npm install web3`
    - There will be issues when using large int values in javascript. Using web3 allows you to convert them into bignumbers eg:
    ```javascript
    // 4.	Test that a Die cannot be listed if the price is less than value + commission
    it('Dice cannot be listed if price < val + commission', async () => {
        await truffleAssert.fails(
            diceMarketInstance.list(
                0, 
                web3.utils.toBN(1e18 + 1e9), // Big Number conversion
                {from: accounts[1]}
            ),
            truffleAssert.ErrorType.REVERT,
            "Price is too low"
        );
    ```

# 2. Basic compiling and common errors
When you copy the sample 3 lab files, you can try and compile to check that your code is ok
1. Changing truffle-config.js
* Uncomment and change port number to 7545
```js
  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },

```

* change compiler to 0.5.16
You will get this error:
```
,Warning: Source file does not specify required compiler version! Consider adding "pragma solidity ^0.8.11;"
--> project:/contracts/DiceMarket.sol
```
This is because from our tut, we have been using a different compiler esp in remix and even our sol files have a pragma.... So change it to whatever works. In our case:
```js
  // Configure your compilers
  compilers: {
    solc: {
        // CHANGE THE VERSION!
      version: "0.5.16",    // Fetch exact version from solc-bin (default: truffle's version) 
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion

```

# 3. Other errors: Understanding the migrations
Basically, just like how in Remix, we created the Dice AND THEN Dicemarket (since it needs Dice), We need to tell the computer to do the same thing. This is where migration files comes in. If you get this error:
```
Error:  *** Deployment Failed ***

"DiceMarket" -- Invalid number of parameters for "undefined". Got 1 expected 2!.
```
It most likely means you dont understand files that you are using. For this example, it's because you didnt follow the correct number of params (dicemarket needs dice address and fee)

* bignumber errors:
```
Deploying 'DiceMarket'
   ----------------------

Error:  *** Deployment Failed ***

"DiceMarket" -- overflow (fault="overflow", operation="BigNumber.from", value=1000000000000000000, code=NUMERIC_FAULT, version=bignumber/5.0.8).
```
This is because in the deployent file, I was trying to use a big value `1e18`. To resolve that i need to use web3 bignumber:
```js
// in migrations/2_deploy_contracts.js
const Dice = artifacts.require("Dice");
const DiceMarket = artifacts.require("DiceMarket");
const web3 = require('web3'); // NEED THIS

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Dice).then(function() {
      return deployer.deploy(DiceMarket, Dice.address, web3.utils.toBN(1e18));
  });
};

```

# 4. scientific notation for wei.
* 1 eth = 1e18 wei. You can use 1e18 for wei. Make sure web3 is installed!

