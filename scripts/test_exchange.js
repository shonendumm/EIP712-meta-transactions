const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const EsterToken = await hre.ethers.getContractFactory("EsterToken");
    const ester_token = await EsterToken.deploy();

    await ester_token.deployed();

    console.log("EsterToken deployed to:", ester_token.address);

    const ReceiverExchange = await hre.ethers.getContractFactory("ReceiverExchange");
    const exchange = await ReceiverExchange.deploy(ester_token.address);

    await exchange.deployed();

    console.log("ReceiverExchange deployed to:", exchange.address);

    // Sending ETH to the Ester Token contract
    // await addr1.sendTransaction({
    //     to: ester_token.address,
    //     value: ethers.utils.parseEther("2")
    // })

    // const transfer_eth_for_ester = await ester_token.balanceOf(addr1.address);
    // console.log("Owner's ester tokens is", transfer_eth_for_ester);


    // Testing batch order handling in Exchange/Pool contract
    // await ester_token.transfer(exchange.address, 1000);

    // await ester_token.balanceOf(exchange.address);

    // await exchange.testBatchOrders();

    // await ester_token.balanceOf("0xe815c78c28652D9a03e187183E74A3E462057788");

    // await ester_token.balanceOf(exchange.address);





    
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });