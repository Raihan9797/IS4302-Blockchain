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
