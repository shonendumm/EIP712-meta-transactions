const hre = require("hardhat");

async function main() {
    const EsterToken = await hre.ethers.getContractFactory("EsterToken");
    const ester_token = await EsterToken.deploy();

    await ester_token.deployed();

    console.log("EsterToken deployed to:", ester_token.address);

    const ReceiverExchange = await hre.ethers.getContractFactory("ReceiverExchange");
    const exchange = await ReceiverExchange.deploy(ester_token.address);

    await exchange.deployed();

    console.log("ReceiverExchange deployed to:", exchange.address);


}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });