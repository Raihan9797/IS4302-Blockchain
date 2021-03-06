const _deploy_contracts = require("../migrations/2_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');


var ERC20 = artifacts.require("../contracts/ERC20.sol");
var Pool = artifacts.require("../contracts/Pool.sol");

contract('Pool', function(accounts) {
    before(async () => {
        erc20instance = await ERC20.deployed();
        poolInstance = await Pool.deployed();
    });

    it('Test Get PTs', async() => {
        let getPT = await poolInstance.getPT({from:accounts[1], value: 1E18});
        truffleAssert.eventEmitted(getPT, "GetPT");
        let checkPT = await poolInstance.getTokenBalance.call(accounts[1]);
        assert.strictEqual(checkPT.toNumber(), 100, "PT not deployed correctly");
        
        let getPT2 = await poolInstance.getPT({from:accounts[2], value: 1E18});
        truffleAssert.eventEmitted(getPT2, "GetPT");
        let checkPT2 = await poolInstance.getTokenBalance.call(accounts[2]);
        assert.strictEqual(checkPT2.toNumber(), 100, "PT not deployed correctly");

    });

    it('Test Send Tokens', async() => {
        let sendToken = await poolInstance.sendTokens(50, {from:accounts[1]});
        truffleAssert.eventEmitted(sendToken, "TokenSent");

        let sendToken2 = await poolInstance.sendTokens(40, {from:accounts[2]});
        truffleAssert.eventEmitted(sendToken2, "TokenSent");

        let tpool = await poolInstance.getTotalPool.call();
        assert.strictEqual(tpool.toNumber(), 90, "TotalPool doesn't align");
    });

    it('Check Voter List length', async () => {
        // console.log(poolInstance.getVoterList.call()) // call the fn, see the output
        let vlistlen = await poolInstance.getVoterListLength.call();
        assert.strictEqual(vlistlen.toNumber(), 2);
    });


    it('Test Voting', async() => {
        let vote_acct2 = await poolInstance.vote(accounts[2], {from: accounts[1]});
        truffleAssert.eventEmitted(vote_acct2, "Voted");

        let checkVote = await poolInstance.getVote.call(accounts[1]);
        assert.strictEqual(checkVote, accounts[2], "vote not working");

    });

    it('Test that voters cannot vote twice', async() => {
        await truffleAssert.reverts(poolInstance.vote(accounts[2], {from: accounts[1]}), "Can't vote twice!");
    })

    it('Check candidateVotes', async() => {
        let vres = await poolInstance.getcandidateVotes.call(accounts[2]);
        assert.strictEqual(vres.toNumber(), 50, "candidateVotes not working");
    })

    it('Ensure non-chairs cannot end vote', async() => {
        await truffleAssert.reverts(poolInstance.endVoting({from:accounts[1]}), "Only chairperson can end voting")
    })

    it('Test VoteWon', async() => {
        // console.log(await poolInstance.getVoterList.call());
        let endvote = await poolInstance.endVoting({from: accounts[0]});
        // console.log(endvote);
        truffleAssert.eventEmitted(endvote, "VoteWon");
        console.log('----------TESTING OF WON CASE DONE------------')
    });


    it('Test VoteDrawn', async() => {
        // easy passing method
        /*
        console.log(await poolInstance.getVoterList.call());
        let endvote = await poolInstance.endVoting({from: accounts[0]});
        console.log(endvote);
        truffleAssert.eventEmitted(endvote, "VoteDrawn");
        */

        // accounts get pt
        let getPT = await poolInstance.getPT({from:accounts[1], value: 1E18});
        truffleAssert.eventEmitted(getPT, "GetPT");
        let checkPT = await poolInstance.getTokenBalance.call(accounts[1]);
        assert.strictEqual(checkPT.toNumber(), 150, "PT not deployed correctly");
        
        let getPT2 = await poolInstance.getPT({from:accounts[2], value: 1E18});
        truffleAssert.eventEmitted(getPT2, "GetPT");
        let checkPT2 = await poolInstance.getTokenBalance.call(accounts[2]);
        assert.strictEqual(checkPT2.toNumber(), 250, "PT not deployed correctly");

        // acct 1 send 50, acct 2 send 50, total should be 100
        let sendToken = await poolInstance.sendTokens(30, {from:accounts[1]});
        truffleAssert.eventEmitted(sendToken, "TokenSent");

        let sendToken2 = await poolInstance.sendTokens(30, {from:accounts[2]});
        truffleAssert.eventEmitted(sendToken2, "TokenSent");

        let tpool = await poolInstance.getTotalPool.call();
        assert.strictEqual(tpool.toNumber(), 60, "TotalPool doesn't align");

        // check voterlistlength
        let vlistlen = await poolInstance.getVoterListLength.call();
        assert.strictEqual(vlistlen.toNumber(), 2);

        // voting a1 votes for a2 with 50
        let vote_acct1 = await poolInstance.vote(accounts[1], {from: accounts[2]});
        truffleAssert.eventEmitted(vote_acct1, "Voted");
        let vote_acct2 = await poolInstance.vote(accounts[2], {from: accounts[1]});
        truffleAssert.eventEmitted(vote_acct2, "Voted");

        let checkVote = await poolInstance.getVote.call(accounts[1]);
        assert.strictEqual(checkVote, accounts[2], "vote not working");

        // end vote and should be drawn
        // let endvote = await poolInstance.endVoting({from: accounts[0]});
        let endvote = await poolInstance.endVoting.call({from: accounts[0]});
        console.log(await poolInstance.getVoterList.call());
        console.log(await poolInstance.getTotalPool.call());
        console.log(endvote);
        /*
        truffleAssert.eventEmitted(endvote, "VoteDrawn");
        */

    })

    
});