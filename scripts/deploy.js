// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {ethers, run, network} = require("hardhat")

async function main() {
 const Token = await hre.ethers.getContractFactory("MyToken")
 const token = await Token.deploy("Invesweet","IST");
 await token.deployed()

//  await mintContract.functions.mint(id, amount, {gasLimit: 40000000});

 console.log("Congratulations!! Your token deployed, Here's token address:", token.address);

 const Dex = await hre.ethers.getContractFactory("StableDex")
 const myDex = await Dex.deploy(token.address, 37, "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e")
 await myDex.deployed()

 console.log("Here's your dex contract address:", myDex.address);

 console.log(network.config);

 const Faucet = await hre.ethers.getContractFactory("Faucet")
 const faucet = await Faucet.deploy(token.address)
 await faucet.deployed()

 console.log("Faucet contract address:", faucet.address);



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
