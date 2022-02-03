# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```


# What is this app about?

Ester Token is an ERC-20 token, denominated to 18 decimals, similar to ETH. 
It has a 1:1 ratio with ETH. You can send the contract ETH to get ESTR tokens. Just like WETH.

Token Exchange is an blockchain contract that accepts off-chain signed bids from users to buy Ester tokens.




# How to deploy and test

Compile the contracts: 
`npx hardhat compile`

Copy the compiled token exchange contract's abi to "dependencies/exchange-abi.js"


Deploy both contracts (Ester Token and Token Exchange) to rinkeby network:
`npx hardhat run scripts/deploy_token_exchange.js --network rinkeby`

Copy the deployed EsterToken contract address and paste it in the address here to verify the contract. 
`npx hardhat verify 0xE0427767282C793feb3896d048395ff543DBcAB2 --network rinkeby`

If you encounter a ENOENT error while verifying, run: `npx hardhat clean` and then run the above verification command again.

Optional: If you like, you can also verify the exchange contract, passing it the EsterToken contract address as an argument, e.g.:
`npx hardhat verify 0xadd39d12aD9b8FFe3DCB48ac3822b94DD1308d2E --network rinkeby 0xE0427767282C793feb3896d048395ff543DBcAB2`

After verification, go to rinkeby etherscan for the ESTR contract and transfer ESTER tokens to the Token Exchange contracy.
Use Write Contract to transfer 500000000000000000000 (500 tokens) to the Exchange contract.

This is to give the Exchange some ESTR tokens in its pool, so that it can carry out user bid transactions.

Copy the token exchange contract address and paste to "index.html" (line 151). This is so that our index.html webpage can sign and send to the Token Exchange contract. Remember to save.

Then, run the page server:
`http-server`

Open your chrome browser (with metamask set to Rinkeby) http://127.0.0.1:8080

Enter your amounts or just use the default amounts. The default amounts will pass. 
The minimum bid price is 10, yes just 10. You can change this in the Token Exchange contract (but run all the above steps again).
There is no minimum amount to buy. The default is 1000000000000000000, which is 1 ESTER fter applying decimals on it.

Click "Sign bid", then remember to "Confirm and save bid".

Then click "Send batch orders manually".

This will prompt metamask to ask you to pay the gas fees to send the batched transactions. Because your account is connected to metamask as the sender.

Then you can go to rinkeby.etherscan to see the Token Exchange contract, under Events, it will indicate that your user has bought Ester tokens.


