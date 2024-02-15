# SimpleToken Contract

## Overview

`SimpleToken` is an ERC20 token contract designed with additional features and administrative capabilities. It extends the OpenZeppelin `ERC20` contract, ensuring compliance with the ERC20 standard and benefiting from the security audits performed by OpenZeppelin.

## Key Features

- **Minting**: Authorized addresses can create new tokens up to predefined limits.
- **Burning**: Token holders can destroy their tokens, decreasing the total supply.
- **Buying and Selling**: Transactions involving ETH are supported, with configurable fees applied.
- **Ownership and Access Control**: The contract enforces strict access controls for critical operations.

## Deployment

The contract can be deployed using the `deploy.js` script included in the project. The deployment script sets the token name, symbol, and initial admin address during deployment.

## Administration

- **Ownership Transfer**: The ownership of the contract can be transferred to another address using the `renounceOwnership` function.
- **Admin Management**: Admins can be added or removed using the `setAdmin` and `removeAdmin` functions. There is a limit of  10 admins.

## Usage

- **Transferring Tokens**: Users can transfer tokens to other addresses using the `transfer` function.
- **Approving Spenders**: Users can approve spenders to spend tokens on their behalf using the `approve` function.
- **Transferring From**: Users can transfer tokens from approved spenders using the `transferFrom` function.
- **Minting Tokens**: Authorized users can mint new tokens using the `mint` function.
- **Burning Tokens**: Users can burn their own tokens using the `burn` function.

## Verification

After deployment, the contract's source code is automatically verified on the block explorer and Sourcify for transparency and trust.

## Compilation and Testing

The contract is compiled using Solidity version `0.8.20`, and the Hardhat development environment is used for testing and deployment.

## Network Support

The contract supports deployment on multiple networks, including Sepolia, Arbitrum, and Binance Smart Chain testnet, with configurations specified in the `hardhat.config.js` file.
