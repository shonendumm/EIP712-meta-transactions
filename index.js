const express = require('express');
const app = express();
require('dotenv').config()

const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");


const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`listening at port ${port}`));

app.use(express.static('public'));
app.use(express.json({ limit: '1mb' }));



let BUY_ORDERS_ARRAY = [];

app.post('/send-buy-order', (request, response) => {
    const data = request.body;
    console.log("From user", data);
    response.json({ message: "received order!" });

    BUY_ORDERS_ARRAY.push({
        account,
        amount,
        bidPrice,
        v,
        r,
        s
    });


})



const private_key = process.env.SERVER_PRIVATE_KEY;
const serverWallet = web3.eth.accounts.wallet.add(private_key);



// 30 seconds
const timer = 30 * 1000;
setInterval(async() => {
    try {
        console.log("Auto Batch Send called by timer")
        if (BUY_ORDERS_ARRAY.length > 0) {
            console.log("Auto Batch Send called: sent transactions")

            const tx = await exchangeContract.methods.handleBatchOrders(BUY_ORDERS_ARRAY).send({
                from: serverWallet.address,
                gasLimit: web3.utils.toHex(6000000), // set gas limit and gas price here
                gasPrice: web3.utils.toHex(20000000000),
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