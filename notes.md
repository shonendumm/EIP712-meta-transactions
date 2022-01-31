Up to:

Learning till where:



https://youtu.be/M576WGiDBdQ?t=23783
randomness

https://youtu.be/M576WGiDBdQ?t=23668
compiling lottery

https://youtu.be/M576WGiDBdQ?t=20567
About interacting with deployed contracts, writing a new py file called fund and withdraw.

https://youtu.be/M576WGiDBdQ?t=20524
About deploying on local ganache chain and getting the info for respective network... verify= true or false, price feed address and get the ganache-cli created account (wallet) for the ganache network, or get our metamask wallet for rinkeby network (stored in "from_key" gotten from .env)

# Errors:

FundMe using brownie. note the contract and file name to be the same.

// If running local ganache chain, and error wallet/address says no money, it's because the get_account function is not getting the accounts[0] wallet.

// If error is verify error, it's because

- if deploying to testnet, it could be various reasons to do with verification of the contract. (See video)
- if deploying to local ganache, it should be false (because we don't need to verify)

// Another verify contract error:
fund_me = FundMe.deploy(MockV3Aggregator[-1].address, {"from": account}, publish_source=config["networks"][network.show_active()].get("verify"))
KeyError: 'ganache-local'

Solution: Verify=False, can add this to brownie config

### ConnectionError: HTTPConnectionPool(host='0.0.0.0', port=8545): Max retries exceeded with url: / (Caused by NewConnectionError('<urllib3.connection.HTTPConnection object at 0x10889dbb0>: Failed to establish a new connection: [Errno 61] Connection refused'))

Solution: Start ganache app first

# Unable to get some value from config or brownie-config

It's because I defined two "development" under networks


# if error: Transaction's maxFeePerGas (2000000000) is less than the block's baseFeePerGas (135095877057) (vm hf=london -> block -> tx) , add the below:
# https://eth-brownie.readthedocs.io/en/stable/core-gas.html#dynamic-fee-transactions
>from brownie.network import priority_fee
>priority_fee("2 gwei")

Brownie uses (base_fee * 2 + priority_fee) as max_fee if you only specify the priority fee.
The recommended priority fee can be read from `chain.priority_fee`. Remember to `brownie import chain`


----------------------------------------------------------------------------------------


# brownie-config.yaml , dependencies:

https://youtu.be/M576WGiDBdQ?t=18515

because we're using import in the sol. These are from NPM
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/ownable.sol";

we need to tell brownie where to download them from github:

# - organization/repo@version

dependencies:

- smartcontractkit/chainlink-brownie-contracts@1.1.1
- OpenZeppelin/openzeppelin-contracts@4.4.1

compiler:
solc:
remappings: - '@chainlink=smartcontractkit/chainlink-brownie-contracts@1.1.1' - '@openzeppelin=openzeppelin/openzeppelin-contracts@4.4.1'

# brownie init

to start a new brownie project

# copy the .sol contract to contracts folder, then run

brownie compile

# Brownie accounts (local chain)

// at top of the deploy.py script
from brownie import accounts

// then ganache-cli will locally create an accounts array
// we can get the first account's address using
accounts[0]

// this works only for local ganache chain

## Create a brownie account

brownie accounts new nameOfAccount

// it will ask for your private key and some password, and encrypt your account in it

## Delete account

brownie accounts delete nameOfAccount

## List accounts stored in Brownie

brownie accounts list

# Using .env and environment configs with Brownie

// create a .env file and export PRIVATE_KEY=
// create a brownie-config.yaml file, and import os

    account = accounts.add(os.getenv("PRIVATE_KEY"))

// to get variable from brownie-config.yaml, import config
account = accounts.add(config["wallets"]["from_key"])

# Brownie to compile sol contract and deploy to ganache-cli network

brownie run scripts/deploy.py

# deploy to testnet, with infura that connects to the rinkeby network

brownie run scripts/deploy.py --network rinkeby

# brownie console

// opens a python shell with loaded contracts where we can deploy them

account = accounts[0]
simple_storage = SimpleStorage.deploy({"from": account})

# Brownie testing scripts in .py

## run tests, cli

brownie test

## run a single test, cli

brownie test -k test_updating_storage

## run a console debugging test when something goes wrong

brownie test --pdb

## prints the specific tests out, more verbose

brownie test -s

# skip certain tests

brownie test -k test_function_to_skip --network development

// to skip in code:
pytest.skip("only for local environments")

# to test for raise exceptions

// in code:
from brownie import exceptions

with pytest.raises(exceptions.VirtualMachineError):
fundme.withdraw({"from": bad_actor})

# Look at the py test documentation, the test tools are about the same

# Brownie networks prepackaged to run with

brownie networks list

Development networks are temporary, anything sent there are torn down after. Eth networks are persistent.

# to add a new network to brownie

// start ganache app locally first, then leave it running
// else the network will be deleted when app is closed.
brownie networks add Ethereum ganache-local host=http://0.0.0.0:8545 chainid=1337

# We can add a local network to brownie networks list (persistent networks) with:

brownie networks add Ethereum ganache-local host=http://127.0.0.1:8545 chainid=1337

# to add arbitrum-rinkeby network, get node address from free moralis account 
brownie networks add Arbitrum arbitrum-rinkeby host=https://speedy-nodes-nyc.moralis.io/00cc961537e0576f6274e556/arbitrum/testnet chainid=421611

To use Ethereum L2 arbitrum, need to convert ETH to arbitrum ETH using Arbitrum Token Bridge website https://bridge.arbitrum.io/ (connect via metamask and exchange manually)

# for forking mainnet, but infura is problematic

brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork='https://mainnet.infura.io/v3/$WEB3_INFURA_PROJECT_ID' accounts=10 mnemonic=brownie port=8545


# use alchemy to fork mainnet

brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork=https://eth-mainnet.alchemyapi.io/v2/KmSQSFEyi3eURLTHwECObHU89P2AAzst accounts=10 mnemonic=brownie port=8545

// for Lottery? Doesn't seem to need it when I ran brownie test --network rinkeby

brownie networks add development mainnet-fork cmd=ganache-cli host=http://127.0.0.1 fork=https://eth-mainnet.alchemyapi.io/v2/cYyfeDnZEsBdL4PhlGxJBCaVAQvk04ds accounts=10 mnemonic=brownie port=8545

## Math gymnastics in order to convert ETHUSD in terms of WEI.

function getPrice() public view returns (uint256){
AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
// ( uint80 roundID,
// int answer,
// uint startedAt,
// uint timeStamp,
// uint80 answeredInRound ) = priceFeed.latestRoundData();

            ( ,
            int answer,
            ,
            ,
            ) = priceFeed.latestRoundData();
        //   return uint256(answer);    // typecast the answer
        // If just answer is 391202492790 , 12 digit number with 8 decimal places = 3912.02492790 price of 1 Eth

        return uint256(answer * (10**10));
        // The above returns 391202492790,0000000000 , adds 10 zeros to make it a 22 digit number with 18 decimal places.
        // i.e. 3912.02492790,0000000000

    }


    function getConversionRate(uint256 weiAmount) public view returns(uint256) {
        // Get price of 1 eth that is 391202492790,0000000000 (22 digit number with 18 decimals to deduct from it)
        uint256 ethPrice = getPrice();
        // divide the 22 digit number by 18 decimal places to get the 1 Eth price
        uint256 ethAmountInUSD = (ethPrice * weiAmount) / (10**18);
        return ethAmountInUSD;

        // But we cannot enter 0.000000001 for 1 Gwei price since solidity cannot do decimals.
        // So we just treat as 1 WEI, indivisible unit. And since 1 Wei = 18 decimal places.
        // the answer must divide by 10**18 decimals.

        // Example 1:
        // Entering 1 wei returns 3870 => 0.000000000000003870 USD for 1 Wei

        // Example 2:
        // Entering 1000000000 wei (10**9 = 1 gwei) returns 3843623127810
        // Take the answer 3843623127810 divide by 10**18 = 0.000003843623127810
        // Above, 1 gwei = 0.000003843623127810 USD

        // Example 3:
        // Entering 1000000000000000000 wei (10**18 = 1 eth) returns 3834520600260000000000
        // 1 eth unit = 3834.520600260000000000 (divide by 18 decimal places)

    }

# For mocking the pricefeed contract, if not using rinkeby network, i.e. using locally

We can get the MockV3Aggregator.sol code from chainlink mix
https://github.com/smartcontractkit/chainlink-mix/blob/master/contracts/test/MockV3Aggregator.sol

It mocks the pricefeed of eth-usd



# helpful scripts / get_account() and deploy_mocks()

Whether deploying on local ganache chain or rinkeby testnet, we will get the info for respective network...

1. get the ganache-cli created account (wallet) for the ganache network, or get our metamask wallet for rinkeby network (stored in "from_key" gotten from .env)

2. price feed address

3. verify= true or false

# if we close the ganache app, we will lose the locally deployed chains, cannot interact with them again

// If that happens, we can delete build>deployments>1337
// and delete entries 1337 from the map.json in deployments
// or, delete the whole build folder.

Then redeploy again to ganache-local.

I deleted FundMe.json and the contents of folder 1337

then run:
brownie run scripts/fund_and_withdraw.py --network ganache-local  
 error: list index out of range, fund_me = FundMe[-1]

// This is because I have not deployed the FundMe contract to the chain. I need to run the deploy.py first on the ganache-local before running fund_and_withdraw.py

## Do not commit this 123

hello

## Questions about cryptopunks

Currently, it looks like the metadata is stored at IPFS then passed as a link (string) at brownie when minting.

Perhaps the tokenURI can be passed as JSON.
Can check the Ether Orcs contract https://rinkeby.etherscan.io/token/0x5e98f294a01b68e654e91a9925686065c2f42536#readContract

Their tokenURI returns 
string :  data:application/json;base64

Use https://www.base64decode.org/ to decode base64

1. How do I store NFT metadata on the blockchain?
2. How to encode the svg code into base64? via website or terminal command
2.2. What is the command?

https://www.reddit.com/r/ethdev/comments/ni1roj/help_me_understand_cryptopunks_source_code/
https://etherscan.io/token/0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb#readContract
https://github.com/larvalabs/cryptopunks 


## how to run a IPFS node
use this terminal command:
ipfs daemon


Account 1:
0x20A5C66B2f591c15BF3dF02618390683648C8C35
Account 2:
0xAFFfbFd63bE181D9B80d78De09Bb3DaEF1e478D7
Account 3:
0xe815c78c28652D9a03e187183E74A3E462057788

Hardhat verify contract (if it includes imports) where 1000 is the args entered when deploying

hh verify --contract contracts/SooToken.sol:SooToken --network rinkeby 0xeEe9695578e446f499bC75Ee0A9Fa77abc4d8DE1 1000

hh verify 0xA87FaA844D42d55d08477A9d76FCf55bD61FEE72 --network rinkeby 1000

hh verify 0xF2cc66110767DE4Ad01D345EDb66ad0E7aF0717F --network rinkeby 1000

hh verify 0xA3F94E7769965651894f463a452Ef3E430ED82B2 --network rinkeby

hh verify --contract contracts/SooToken.sol:SooToken 0x2ff63b86682Ba3Da99A4cDfEa01aB96284413f97 --network rinkeby "1000000000000000000000"