const {task} = require ("hardhat/config")

task("contract-balance", "show the current contract balance").setAction(
    async(taskArgs, hre) => {
        const currentBalance = await hre.ethers.provider.getBalance()
        console.log("current balance of contract:", currentBalance);
    }
)
module.exports = {}