const createOrderBySigMessage = (exchangeAddress, _amount = 2000000000000000000, _bidPrice = 1000000000000000000, _chainId = 4) => {
    console.log("createOrderBySigMessage called");
    const domain = [{
        name: 'name',
        type: 'string'
    }, {
        name: 'version',
        type: 'string'
    }, {
        name: 'chainId',
        type: 'uint256'
    }, {
        name: 'verifyingContract',
        type: 'address'
    }, ];

    const buy_order = [{
        name: 'amount',
        type: 'uint256'
    }, {
        name: 'bidPrice',
        type: 'uint256'
    }];

    const domainData = {
        name: "Token Exchange",
        version: "1",
        chainId: _chainId,
        // To replace verifyingContract with deployed contract address
        verifyingContract: exchangeAddress
    }

    const message = {
        amount: _amount,
        bidPrice: _bidPrice
    }

    return JSON.stringify({
        types: {
            EIP712Domain: domain,
            BuyOrder: buy_order,
        },
        primaryType: "BuyOrder",
        domain: domainData,
        message: message
    });


}




window.onload = function() {
    let web3;
    const web3Warning = document.getElementById('web3-warning');
    // form elements
    const myAddress = document.getElementById('my-address');
    const formAmount = document.getElementById('form-amount');
    const formBidPrice = document.getElementById('form-bid-price');
    const signButton = document.getElementById("sign-button");
    // confirm submission elements 
    const myAmount = document.getElementById('my-amount');
    const myBidPrice = document.getElementById('my-bid-price');
    const mySignature = document.getElementById('my-signature');
    const chainId = document.getElementById('chainId');
    const submitOrderButton = document.getElementById('submit-order-button');

    console.log("page loaded!")

    main();


    async function main() {

        const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts'
        }); // enable ethereum

        web3 = new Web3(window.ethereum);

        const net = +window.ethereum.chainId;
        // fastest method above.
        // const net = await window.ethereum.networkVersion;
        // const net = await window.ethereum.request({method: 'eth_chainId'});


        // // This app only works with Rinkeby or Local Hardhat or Ganache
        if (net !== 4 && net !== 31337 && net != 1337) {
            alert('Please select the Rinkeby or Hardhat/Ganache network.');
        }

        // add the deployed verifying contract address here. Mainnet || Mainnet-fork 
        if (net === 1 || net === 1337) {
            exchangeAddress = '0xc00e94cb662c3520282e6f5717214004a7f26888';
            console.log("Using mainnet or mainnet fork");
        } else if (net === 4) {
            // verifying contractAddress on Rinkeby
            exchangeAddress = '0xd47C59E5b43269CB9819e153F7c4dedeD6D0580f';
            console.log("Using rinkeby network");
        }


        // deployed Exchange contract ABI that is in the dependencies folder and loaded to page above
        const exchangeAbi = window.exchangeAbi;
        const exchange = new web3.eth.Contract(exchangeAbi, exchangeAddress);

        const myAccount = accounts[0];
        myAddress.innerText = myAccount;

        // // this calls the contract info, a mapping named delegates:
        // let currentDelegatee = await comp.methods.delegates(myAccount).call();

        // Create signature based on information entered, e.g. bid price and amount of ESTR tokens.
        // e.g. Sign Buy Order (off-chain)
        signButton.onclick = async() => {

            console.log("signButton clicked!");
            const _amount = formAmount.value;
            const _bidPrice = formBidPrice.value;
            const _chainId = window.ethereum.chainId.toString();
            console.log("Form amount:", _amount);
            console.log("Form bidPrice:", _bidPrice);
            console.log("ChainId: ", _chainId);


            const msgParams = createOrderBySigMessage(exchangeAddress, _amount, _bidPrice, _chainId);


            window.ethereum.sendAsync({
                method: 'eth_signTypedData_v4',
                params: [myAccount, msgParams],
                from: myAccount
            }, async(err, result) => {
                if (err) {
                    console.error('ERROR', err);
                    alert(err);
                    return;
                } else if (result.error) {
                    console.error('ERROR', result.error.message);
                    alert(result.error.message);
                    return;
                }

                const sig = result.result;
                // display the values on page for confirmation
                // myAmount.value = _amount;
                myAmount.innerText = _amount;
                myBidPrice.innerText = _bidPrice;
                mySignature.innerText = sig;

                console.log('signature', sig);
                console.log('msgParams', JSON.parse(msgParams));

            });
        }
    }




};