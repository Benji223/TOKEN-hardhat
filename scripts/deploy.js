const hre = require('hardhat')


/** Set contract and collection name **/
const CONTRACT_NAME = 'SimpleToken'
const TOKEN_NAME = 'Test2A'
const TOKEN_SYMBOL = 'T2A'
const ADMIN_ADDRESS = '0xFa2a4b0358B132B261E796fa07D941842f3871D6'

/** Main deploy function **/
async function main() {
  const contractFactory = await hre.ethers.getContractFactory(CONTRACT_NAME)

  console.log(`Deploying ${CONTRACT_NAME}...`)

  const contract = await contractFactory.deploy(
    TOKEN_NAME,
    TOKEN_SYMBOL,
    ADMIN_ADDRESS,
  )

  await contract.waitForDeployment()

  const contractAdress = await contract.getAddress()

  console.log("Contract deployed at ", contractAdress)

await hre.run("verify:verify", { address: contractAdress,
  constructorArguments: [TOKEN_NAME, TOKEN_SYMBOL, ADMIN_ADDRESS], })
}
/** Run Main function - Do not change **/
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
