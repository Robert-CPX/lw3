const hre = require("hardhat");

async function main() {
  const HelloWorld = await hre.ethers.deployContract("HelloWorld");

  await HelloWorld.waitForDeployment();

  console.log(`HelloWorld contract deployed to ${HelloWorld.target}`);

  await sleep(45000);

  await hre.run("verfiy:verify", {
    address: HellowWorld.target,
    constructorArguments: [],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
