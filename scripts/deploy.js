// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const owner = await hre.ethers.getSigners();

  const M2Factory = await hre.ethers.getContractFactory("Metadata2");
  const M2 = await M2Factory.deploy(owner[0].address);
  await M2.deployed();
  console.log("M2 address: ", M2.address);

  const M1Factory = await hre.ethers.getContractFactory("Metadata1");
  const M1 = await M1Factory.deploy(owner[0].address, M2.address);
  await M1.deployed();
  console.log("M1 address: ", M1.address);

  const TokenURIFactory = await hre.ethers.getContractFactory("TokenURI");
  const tokenURI = await TokenURIFactory.deploy(owner[0].address, M1.address);
  await tokenURI.deployed();
  console.log("TokenURI address: ", tokenURI.address);

  const MintingMushroomFactory = await hre.ethers.getContractFactory("MintingMushroom");
  const mintingMushroom = await MintingMushroomFactory.deploy(owner[0].address, M1.address, tokenURI.address);
  await mintingMushroom.deployed();
  console.log("Minting Mushroom address: ", mintingMushroom.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
