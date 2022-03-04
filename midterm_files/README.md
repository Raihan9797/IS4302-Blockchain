# Midterm
Was doable but need to understand the requirements. 
* I assigned candidate votes to be 0 instead of the intial value as I was afraid more users could add again afterwards which would change the weights as weights = amt/totalPool. so i set it to 0 resulting in no event emitted in the checkcandidatevotes test as 0 basically means its undefined
* Overall 6/9 cases passed. The initial code thinks i passed the last 2 but thats because theres nothing inside so by default i passed.

## Important tip: console.log in test_pool.js
1. To be able to see whole outputs, you can use console.log() to see elements especially arrays. This allows you to see the output during the tests!
    - make sure to use `await` otherwise you will get a promise.
```js
    it('Check Voter List length', async () => {
        console.log(await poolInstance.getVoterList.call()) // await the fn call, see the output
        let vlistlen = await poolInstance.getVoterListLength.call();
        assert.strictEqual(vlistlen.toNumber(), 2);
    });
```
2. You cant print out mapping()! They arent really stored like an array.

## After midterm attempt: fixing the small issues and creating the last 2 test cases.
1. For the last 2 test cases. By looking at the initial test you can see that there are 2 people (acct1 and acct 2). Acct1 votes for 2 with 50 tokens so after endvoting, 2 should win and a VoteWon event should be emitted.
    - More importantly, the weights are all cleared! This means there are no votes which means all votes are equal. This results in voteDrawn! Thats the easy way of solving the 2nd test case.

2. Of course we can do it more realistically.
- Trying to but there are a lot of issues, we basically have to change quite a few functions and keep in mind a few variables that we did not really focus on during the exam (due to time constraints). 
- Current issue is that i am getting BN {..} basically a big number and i dont know if my values are correct unless i convert the big number properly. Going to stop here for now.