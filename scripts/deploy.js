// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const owner = await hre.ethers.getSigners();

  const MetadataFactory = await hre.ethers.getContractFactory("Metadata");
  const metadata = await MetadataFactory.deploy(owner[0].address);
  await metadata.deployed();
  console.log("Metadata address: ", metadata.address);

  const MintingMushroomFactory = await hre.ethers.getContractFactory("MintingMushroom");
  const mintingMushroom = await MintingMushroomFactory.deploy(owner[0].address, metadata.address);
  await mintingMushroom.deployed();
  console.log("Minting Mushroom address: ", mintingMushroom.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
