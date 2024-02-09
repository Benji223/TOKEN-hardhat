const hre = require('hardhat')


/** Set contract and collection name **/
const CONTRACT_NAME = 'Token'
const TOKEN_NAME = 'Test1A'
const TOKEN_SYMBOL = 'T1A'
const ADMIN_ADDRESS = ''

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
  // Print our newly deployed contract address
  console.log("Contract deployed at ", await contract.getAddress())
}
/** Run Main function - Do not change **/
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})


































