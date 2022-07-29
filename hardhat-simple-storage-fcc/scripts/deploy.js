//imports
const { getContractAddress } = require("ethers/lib/utils")
const { ether, run, network } = require("hardhat")
// run allows us to run verify task, network allows us to get network config. information
async function main() {
    const SimpleStorageFactory = await ethers.getContractFactory(
        "SimpleStorage"
    )
    console.log("Deploying contract...")
    const simpleStorage = await SimpleStorageFactory.deploy()
    await simpleStorage.deployed()
    //what's the private key?
    //what's the rpc url?
    console.log(`Deployed contract to: ${simpleStorage.address}`)
    // What happens when we deploy on the hardhat network?
    // hardhat network is a local network, we only want to verify a contract on a testnet or mainnet
    console.log(network.config)
    // if chainId is 4 (were on rinkeby) and etherscan api key is defined
    if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
        await simpleStorage.deployTransaction.wait(6) // wait 6 blocks after we deploy
        await verify(simpleStorage.address, [])
    }

    const currentValue = await simpleStorage.retrieve()
    console.log(`Current Value is: ${currentValue}`)

    // Update the current value
    const transactionResponse = await simpleStorage.store(7)
    await transactionResponse.wait(1)
    const updatedValue = await simpleStorage.retrieve()
    console.log(`Updated value is: ${updatedValue}`)
}

async function verify(getContractAddress, args) {
    console.log("Verifying contract...")
    try {
        await run("verify:verify", {
            address: getContractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already verified!")
        } else {
            console.log(e)
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
