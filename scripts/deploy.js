const { task } = require("hardhat/config");
const { getAccount } = require("./helpers");
const Web3 = require('web3');
const web3 = new Web3();

task("check-balance", "Checks the balance of an account")
.setAction(async function(taskArguments, hre) {
    const account = getAccount();
    console.log(`Account balance for ${account.address}: ${account.getBalance()}`)
})

task("deploy", "deploys a contract to the Ethereum Network")
.setAction(async function(taskArguments, hre) {
    const cFactory = await hre.ethers.getContractFactory("SoulboundToken", getAccount());
    const deployedContract = await cFactory.deploy(web3.utils.toWei("19", "Ether"));
    console.log(`Contract deployed to: ${deployedContract.address}`);
})