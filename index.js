const express = require('express');
const app = express();
// const Datastore = require('nedb');
require('dotenv').config()

// use web3
const Web3 = require('web3');

// to enter an infura endpoint URL
const web3 = new Web3(Web3.givenProvider || process.env.RINKEBY_RPC_URL);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`listening at port ${port}`));
app.use(express.static('public'));
app.use(express.json({ limit: '1mb' }));


let BUY_ORDERS_ARRAY = [];
// const database = new Datastore('database.db');
// database.loadDatabase();

app.post('/send-buy-order', (request, response) => {
    const data = request.body;

    console.log("From user", data);
    response.json({ message: "received order!" });

    // database.insert(data);
    BUY_ORDERS_ARRAY.push(data);


})


const private_key = process.env.PRIVATE_KEY;
const serverWallet = web3.eth.accounts.wallet.add(private_key);

const exchangeAbiFile = require('./public/exchange-abi.js');
const exchangeAbi = exchangeAbiFile.exchangeAbi;

const exchangeAddress = '0xadd39d12aD9b8FFe3DCB48ac3822b94DD1308d2E';
const exchangeContract = new web3.eth.Contract(exchangeAbi, exchangeAddress);
// exchangeContract.defaultChain = 'rinkeby';
// console.log("contract chain is at", exchangeContract.defaultChain);


// 30 seconds
const timer = 30 * 1000;
setInterval(async() => {
    try {
        console.log("Auto Batch called by timer")
        if (BUY_ORDERS_ARRAY.length > 0) {
            console.log("Auto Batch: sent transactions")
            const tx = await exchangeContract.methods.handleBatchOrders(BUY_ORDERS_ARRAY).send({
                from: serverWallet.address,
                gasLimit: web3.utils.toHex(20000000), // set gas limit and gas price here
                gasPrice: web3.utils.toHex(2000000000), // 29970648 1480000000
            });
            // reset the orders array
            BUY_ORDERS_ARRAY = [];
            console.log('tx', tx);
            return true;
        } else {
            return false;
        }

    } catch (e) {
        console.log("caught: " + e.message);
    }
}, timer)