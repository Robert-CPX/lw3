const hre = require("hardhat");
require("dotenv").config({ path: ".env" });
const { CRYPTO_DEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  // Address of the Crypto Devs NFT contract that you deployed in the previous module
  const cryptoDevsNFTContract = CRYPTO_DEVS_NFT_CONTRACT_ADDRESS;

  /*
    DeployContract in ethers.js is an abstraction used to deploy new smart contracts,
    so cryptoDevsTokenContract here is a factory for instances of our CryptoDevToken contract.
    */
 // here we deploy the contract
const cryptoDevsTokenContract = await hre.ethers.deployContract(
  "CryptoDevToken",
  [cryptoDevsNFTContract]
);

// wait for the contract to deploy
await cryptoDevsTokenContract.waitForDeployment();

// print the address of the deployed contract
console.log(
  "Crypto Devs Token Contract Address:",
  cryptoDevsTokenContract.target
);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });