require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
// const { REACT_APP_ALCHEMY_API_KEY, REACT_APP_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.REACT_APP_ALCHEMY_API_KEY,
      accounts: [process.env.REACT_APP_PRIVATE_KEY],
    },
  }
};
