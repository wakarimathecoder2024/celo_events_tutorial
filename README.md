# EVENTS_SMART CONTARCT TUTORIAL
## Table Of Contents


## Table of Contents
- [Introduction](#introduction)
- [What is Celo](#what-is-celo)
- [Prerequisites](#prerequisites)
- [Requirements](#requirements)
- [Developing our Smart Contract](#developing-our-smart-contract)
- [Testing And Deploying the Smart Contract](#testing-and-deploying-the-smart-contract)
- [Conclusion](#conclusion)

## Introduction
Welcome to this in-depth tutorial on creating a smart contract in Solidity on Celo Blockchain. In this guide, we’ll take you step-by-step through the process of building a an event smart contract.First celo is designed with mobile users in mind and emphasizes stability and scalability, making it an ideal platform for decentralized applications.

This tutorial assumes you have a foundational understanding of Ethereum and Solidity. While Celo shares many core concepts with Ethereum, it also introduces unique features tailored for efficient mobile use.

## What is Celo

Celo is a blockchain platform designed specifically for mobile devices and focused on making cryptocurrency accessible to everyone. 
Here are some key features:

##### Mobile-First Design: 
Celo aims to facilitate financial transactions via smartphones, making it easier for users in developing regions to participate in the digital economy.

##### Stablecoins:
Celo supports stablecoins that are pegged to fiat currencies, allowing for more stable transactions and easier integration into everyday use.

#### Scalability and Speed:
Celo employs a unique consensus mechanism (Proof of Stake) that enhances transaction speed and scalability, allowing it to handle a high volume of transactions efficiently.

#### Eco-Friendly: 
Celo’s energy-efficient consensus mechanism makes it a more environmentally friendly alternative to traditional Proof of Work blockchains.

#### Decentralized Applications (dApps): 
Developers can build dApps on Celo, leveraging its mobile-first capabilities and stablecoin features.


Overall, Celo aims to create a more inclusive financial system by leveraging the accessibility of mobile technology and the benefits of blockchain.

## Prerequisites

- Basic Understanding of Blockchain Concepts: Familiarity with how blockchains operate and their key features.
  
- Understanding of Smart Contracts: Know what smart contracts are and how they function within a blockchain environment.
  
- Knowledge of Solidity: A foundational grasp of Solidity and its core concepts. Click here to learn more about Solidity.
  

## Requirements

 - Stable Internet Connection: Since we will be coding online, a reliable internet connection is essential.
   
 - Celo Extension Wallet: Install the Celo Wallet extension for your browser to manage your Celo assets.
   
 - Familiarity with Remix IDE(https://remix.ethereum.org/): We will use Remix IDE for coding and testing our smart contract. Basic navigation skills will be helpful.

## Developing our Smart Contract

In this section, we will explore a Celo smart contract written in Solidity for events .

First, open your browser and go to **Remix IDE**. This online development environment will allow us to write, test, and deploy our smart contract.

Create a new file and name it events.sol and Copy and paste the following code into the file:
```
    // SPDX-License-Identifier: GPL-3.0

     pragma solidity ^0.8.0;
```
**SPDX** stands for Software Package Data Exchange. It’s a standardized way to communicate the licensing of software.
**The GPL-3.0** refers to the GNU General Public License, version 3. This license allows users to freely use, modify, and distribute the software, provided that any distributed modifications are also open-source and under the same license.

**pragma solidity ^0.8.0** This line specifies the version of Solidity that the code is compatible with.
^0.8.0 means that the code is compatible with version 0.8.0 and any later version up to (but not including) 0.9.0. The caret (^) allows for automatic updates to newer minor versions while ensuring backwards compatibility.

```
interface IERC20Token {
function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

}
```
###### Overview
The ERC-20 standard is a widely adopted standard for fungible tokens on the Ethereum blockchain. This interface outlines the essential methods and events that any ERC-20 token contract must implement.

##### Functions
**transfer(address to, uint256 value) external returns (bool);**

Purpose: Transfers value amount of tokens from the caller's account to the to address.
Returns: A boolean indicating whether the transfer was successful.

**approve(address spender, uint256 value) external returns (bool);**

Purpose: Allows the spender to withdraw up to value amount of tokens from the caller's account.
Returns: A boolean indicating whether the approval was successful.

**transferFrom(address from, address to, uint256 value) external returns (bool);**

Purpose: Transfers value amount of tokens from the from address to the to address, using the allowance mechanism. This is typically used when a third party (the spender) is transferring tokens on behalf of the token owner.
Returns: A boolean indicating whether the transfer was successful.

**totalSupply() external view returns (uint256);**

Purpose: Returns the total supply of tokens in existence.
View: This function does not modify the state and can be called without sending a transaction.

**balanceOf(address account) external view returns (uint256);**

Purpose: Returns the token balance of the specified account.
View: Like totalSupply, this function is read-only.

**allowance(address owner, address spender) external view returns (uint256);**

Purpose: Returns the remaining number of tokens that the spender is allowed to spend on behalf of the owner.
View: This function also does not modify the state.

##### Events
**event Transfer(address indexed from, address indexed to, uint256 value);**

Purpose: This event is emitted when tokens are transferred, whether through transfer or transferFrom. The indexed keyword allows for easier filtering of logs by from or to addresses.

**event Approval(address indexed owner, address indexed spender, uint256 value);**

Purpose: This event is emitted when the approve function is called, indicating that the spender has been approved to spend value tokens on behalf of the owner.
##### Summary
The IERC20Token interface defines the core functions and events necessary for any ERC-20 token implementation, ensuring standardization and interoperability within the Ethereum ecosystem. Implementing this interface allows other contracts and applications to interact with the token seamlessly.

