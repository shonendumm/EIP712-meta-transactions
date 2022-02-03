// Script for deploying ESTR token and Exchange contracts

const hre = require("hardhat");

async function main() {
    const EsterToken = await hre.ethers.getContractFactory("EsterToken");
    const ester_token = await EsterToken.deploy();

    await ester_token.deployed();

    console.log("EsterToken deployed to:", ester_token.address);

    const TokenExchange = await hre.ethers.getContractFactory("TokenExchange");
    const exchange = await TokenExchange.deploy(ester_token.address);

    await exchange.deployed();

    console.log("TokenExchange deployed to:", exchange.address);


}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });