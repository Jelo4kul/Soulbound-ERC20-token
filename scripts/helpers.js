const { ethers } = require("ethers");

function getEnvVariable(Key, defaultValue) {
    if(process.env[Key]){
        return process.env[Key];
    }
    if(!defaultValue){
        throw "Key is invalid and default value was not provided"
    }
    return defaultValue;
}

function getProvider() {
    return ethers.getDefaultProvider(getEnvVariable("NETWORK", "rinkeby"), {
        alchemy:getEnvVariable('ALCHEMY_KEY')
    })
}

function getAccount() {
    return new ethers.Wallet(getEnvVariable("PRIVATE_KEY"), getProvider());
}

module.exports = {
    getEnvVariable,
    getProvider,
    getAccount
}