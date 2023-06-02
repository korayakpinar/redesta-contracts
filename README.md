# Redesta

Redesta is a decentralized funding platform built on the Ethereum blockchain. It aims to provide a transparent and incentive-driven system for project funding, where funders can support projects and receive rewards while ensuring accountability and project success.

## Contracts

The project consists of the following Solidity contracts:

- `Redesta.sol`: The main contract that manages the Redesta funding platform. It includes functionality for creating and supporting projects, managing project details and status, handling comments and votes, and facilitating the transfer of funds and rewards.
- `RedestaToken.sol`: A token contract representing the native token of the Redesta platform. It provides functionality for token transfers and approvals.
- `RedestaNFT.sol`: A non-fungible token (NFT) contract used to mint unique tokens representing ownership of projects on the Redesta platform.

## Features

The Redesta funding platform offers the following features:

- Project Creation: Users can create projects by providing project details such as title, description, images, and milestones.
- Project Support: Users can donate funds to support projects and receive project tokens (NFTs) based on predefined thresholds and maximum supply.
- Commenting: Users can comment on projects, providing feedback and engaging in discussions.
- Voting: Users can vote for projects using their project tokens (NFTs). The voting system incentivizes participation and rewards supporters.
- Request Management: Project owners can create requests for additional funding, and other users can vote on these requests.
- Withdrawal: Project owners can withdraw funds from approved requests, ensuring transparency and accountability.
- Rewards: Users who have supported projects and participated in voting can claim rewards based on their level of participation.

## Usage

To use the Redesta funding platform, users need to interact with the deployed contracts on the Ethereum network. They can create projects, donate funds, comment on projects, vote using project tokens (NFTs), and participate in funding requests.

- Creating a Project: Users can create a project by providing all the necessary details and milestones.
- Supporting a Project: Users can donate funds to support projects and receive project tokens (NFTs) based on predefined thresholds and maximum supply.
- Commenting and Voting: Users can engage in discussions by commenting on projects and voting using their project tokens (NFTs).
- Request Management: Project owners can create requests for additional funding, and other users can vote on these requests.
- Withdrawing Funds: Project owners can withdraw funds from approved requests, ensuring transparency and accountability.
- Claiming Rewards: Users who have supported projects and participated in voting can claim rewards based on their level of participation.

Please refer to the contract's source code and documentation for more details on the available functions and their usage.

## Disclaimer

This is a sample funding platform implementation and should be used for educational purposes only. It may not include all the necessary security features or follow best practices. It is recommended to review and audit the code before deploying it to a production environment.

**Note:** The Redesta project and its contracts were developed during a hackathon organized by Akbank and ReFi Turkey within a 48-hour timeframe.
