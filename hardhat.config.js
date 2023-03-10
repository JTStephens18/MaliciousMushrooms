require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-contract-sizer");
// const { REACT_APP_ALCHEMY_API_KEY, REACT_APP_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    },
  },
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.REACT_APP_ALCHEMY_API_KEY,
      accounts: [process.env.REACT_APP_PRIVATE_KEY],
      gas: "auto",
      gasPrice: "auto",
      gasMultiplier: 2,
    },
  },
  paths: {
    artifacts: './src/utils/artifacts',
  },
  // mocha: {
  //   timeout: 100000000
  // }
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
  },
};
