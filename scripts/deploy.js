// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
 const Token = await hre.ethers.getContractFactory("MyToken")
 const token = await Token.deploy();
 await token.deployed()

//  await mintContract.functions.mint(id, amount, {gasLimit: 40000000});

 console.log("Congratulations!! Your token deployed, Here's token address:", token.address);

 const Dex = await hre.ethers.getContractFactory("Dex2")
 const myDex = await Dex.deploy(token.address)
 await token.deployed()

 console.log("Here's your dex contract address:", myDex.address);



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
