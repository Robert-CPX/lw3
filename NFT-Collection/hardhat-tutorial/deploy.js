const hre = require("hardhat");
require("dotenv").config({path:".env"});
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
    const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
    const metadataURL = METADATA_URL;

    const cryptoDevsContract = await hre.ethers.deployContract("CryptoDevs", [
        metadataURL,
        whitelistContract
    ]);

    await cryptoDevsContract.waitForDeployment();

    console.log("Crypto Devs Contract Address:", cryptoDevsContract.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });