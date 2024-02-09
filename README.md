# Token Contract

This README provides an overview of the `Token` smart contract, detailing its features, administrative capabilities, and development tools.

## Overview

The `Token` contract is an ERC20 token with additional features and administrative capabilities. It extends the OpenZeppelin `ERC20` contract, ensuring compliance with the ERC20 standard and benefiting from the security audits performed by OpenZeppelin.

## Key Features

- **Minting**: Authorized addresses can create new tokens up to predefined limits.
- **Burning**: Token holders can destroy their tokens, decreasing the total supply.
- **Buying and Selling**: Transactions involving ETH are supported, with configurable fees applied.
- **Fee Management**: Administrators can adjust transaction fees as needed.
- **Ownership and Access Control**: The contract enforces strict access controls for critical operations.

## Administrative Functionality

- **Admin Management**: The contract owner can appoint or dismiss administrators with elevated permissions.
- **Fee Settings**: Administrators can modify the buy and sell fees dynamically.
- **Ownership Transfer**: The contract owner can reassign ownership to another address.

## Development Tools

The project utilizes Hardhat, a robust Ethereum development environment, and ethers.js, a versatile library for Ethereum and smart contract interactions.

## Security

The contract employs best practices for smart contract security, leveraging OpenZeppelin's secure and audited components.

## License

This project is licensed under the MIT License.
