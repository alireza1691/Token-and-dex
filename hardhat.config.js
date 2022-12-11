require("@nomicfoundation/hardhat-toolbox");
require ("dotenv").config()
require ("./tasks/balance")
require("@nomiclabs/hardhat-ethers");


/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
  networks: {
    // goerli: {
    //   url: process.env.INFURA_GOERLI_ENDPOINT,
    //   accounts: [process.env.PRIVATE_KEY],
    //   chainId: 5
    // },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    }
  },
};