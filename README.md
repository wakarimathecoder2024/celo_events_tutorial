# EVENTS_SMART CONTARCT TUTORIAL

### Improvements for the Tutorial

````markdown
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

Welcome to this in-depth tutorial on creating a smart contract in Solidity on Celo Blockchain. In this guide, we’ll take you step-by-step through the process of building an event smart contract. Celo is designed with mobile users in mind and emphasizes stability and scalability, making it an ideal platform for decentralized applications.

This tutorial assumes you have a foundational understanding of Ethereum and Solidity. While Celo shares many core concepts with Ethereum, it also introduces unique features tailored for efficient mobile use.

## What is Celo

Celo is a blockchain platform designed specifically for mobile devices and focused on making cryptocurrency accessible to everyone.
Here are some key features:

##### Mobile-First Design:

Celo aims to facilitate financial transactions via smartphones, making it easier for users in developing regions to participate in the digital economy.

##### Stablecoins:

Celo supports stablecoins that are pegged to fiat currencies, allowing for more stable transactions and easier integration into everyday use.

##### Scalability and Speed:

Celo employs a unique consensus mechanism (Proof of Stake) that enhances transaction speed and scalability, allowing it to handle a high volume of transactions efficiently.

##### Eco-Friendly:

Celo’s energy-efficient consensus mechanism makes it a more environmentally friendly alternative to traditional Proof of Work blockchains.

##### Decentralized Applications (dApps):

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

In this section, we will explore a Celo smart contract written in Solidity for events.

First, open your browser and go to **Remix IDE**. This online development environment will allow us to write, test, and deploy our smart contract.

Create a new file and name it `events.sol` and copy and paste the following code into the file:

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Events {
    uint256 private eventscount = 0;
    mapping(uint256 => Event) private _events;
    mapping(address => Booking[]) private _bookings;

    event NewEventCreated(uint256 indexed eventId, string eventName, string description, uint256 startDate, uint256 endDate);
    event UpdateEvent(string eventName, uint256 startDate, uint256 endDate);
    event DeleteEvent(string eventName, uint256 eventId);
    event BookingMade(address indexed user, uint256 indexed eventId, string eventName);

    struct Event {
        string name;
        uint256 startDate;
        uint256 endDate;
        uint256 price;
        bool isActive;
        address owner;
        string description;
        uint256 eventId;
        uint256 totalTickets;
        bool isRefundable;
        address payable celoAddress;
    }

    struct Booking {
        address user;
        uint256 eventId;
        uint256 price;
    }

    function createEvent(
        string memory _name,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _price,
        string memory _description,
        uint256 _totalTickets,
        bool _isRefundable,
        address _celoAddress
    ) external {
        require(_startDate > block.timestamp, "Start date must be in the future");
        require(_endDate > _startDate, "End date must be after start date");
        require(_price > 0, "Price must be greater than zero");
        require(_totalTickets > 0, "Total tickets must be greater than zero");

        uint256 eventId = uint256(keccak256(abi.encodePacked(block.timestamp, _name))) % 1000000;
        _events[eventId] = Event({
            name: _name,
            startDate: _startDate,
            endDate: _endDate,
            price: _price,
            isActive: true,
            owner: msg.sender,
            description: _description,
            eventId: eventId,
            totalTickets: _totalTickets,
            isRefundable: _isRefundable,
            celoAddress: payable(_celoAddress)
        });
        eventscount++;
        emit NewEventCreated(eventId, _name, _description, _startDate, _endDate);
    }

    function updateEvent(
        uint256 _eventId,
        uint256 _newStartDate,
        uint256 _newEndDate,
        uint256 _newPrice,
        bool _isRefundable,
        bool _isActive,
        string memory _description
    ) external {
        require(_events[_eventId].isActive, "Event is not active");
        require(_newStartDate > block.timestamp, "Start date must be in the future");
        require(_newEndDate > _newStartDate, "End date must be after start date");
        require(_events[_eventId].owner == msg.sender, "Only owner can update the event");

        _events[_eventId].startDate = _newStartDate;
        _events[_eventId].endDate = _newEndDate;
        _events[_eventId].description = _description;
        _events[_eventId].price = _newPrice;
        _events[_eventId].isActive = _isActive;
        _events[_eventId].isRefundable = _isRefundable;

        emit UpdateEvent(_events[_eventId].name, _newStartDate, _newEndDate);
    }

    function deleteEvent(uint256 _eventId) public {
        require(msg.sender == _events[_eventId].owner, "Only owner can delete the event");
        require(_events[_eventId].isActive, "Event is not active");

        emit DeleteEvent(_events[_eventId].name, _eventId);
        delete _events[_eventId];
        eventscount--;
    }

    function getAllEvents() public view returns (Event[] memory) {
        uint256 eventCount = eventscount;
        Event[] memory allEvents = new Event[](eventCount);

        uint256 index = 0;
        for (uint256 i = 0; i < eventCount; i++) {
            if (_events[i].isActive) {
                allEvents[index] = _events[i];
                index++;
            }
        }

        return allEvents;
    }

    function getEventDetails(uint256 eventId) public view returns (Event memory) {
        return _events[eventId];
    }

    function buyTickets(uint256 _eventId) external {
        require(_events[_eventId].totalTickets > 0, "Event tickets are sold out");
        require(_events[_eventId].isActive, "Event is not active");
        require(IERC20Token(_events[_eventId].celoAddress).transferFrom(msg.sender, _events[_eventId].owner, _events[_eventId].price), "Transfer failed");

        Booking memory newBooking = Booking({
            user: msg.sender,
            eventId: _eventId,
            price: _events[_eventId].price
        });
        _events[_eventId].totalTickets--;
        _bookings[msg.sender].push(newBooking);

        emit BookingMade(msg.sender, _eventId, _events[_eventId].name);
    }

    function checkAvailability(uint256 _eventId) external view returns (uint256 availableTickets) {
        require(_events[_eventId].isActive, "Event is not active");
        availableTickets = _events[_eventId].totalTickets;
    }
}
```
````

## Testing And Deploying the Smart Contract

To test the smart contract, visit [Remix](https://docs.celo.org/developer/deploy/remix). Install the Celo extension wallet from the Chrome Store for Chrome users. To create a contract, go to Remix IDE and create a new file for your Solidity smart contract. Name it `events.sol` and paste the code above.

![Alt Text](./images/m1.png)

Go to your Celo wallet that is on the Alfajores Test Network, copy the address, and paste it on [faucet](https://faucet.celo.org/alfajores) to claim free test tokens.
![Alt Text](./images/m3.png)

### To Compile Contract:

Click on the "Solidity Compiler" tab in the sidebar and select the appropriate compiler version for your contract. Click "Compile" to compile your contract code.

![Alt Text](./images/m6.png)

Go to your Celo wallet that is on the Alfajores Test Network and copy the address.
![Alt Text](./images/m5.png)

After copying the Celo wallet address, paste it into the space next to the deploy button.
![Alt Text](./images/m6.png)

If your smart contract has deployed successfully, you will see this:
![Alt Text](./images/m4.png)

### Conclusion

In this tutorial, we've explored the process of building an events smart contract on the Celo blockchain using Solidity. We’ve learned about various components of the contract, including:

**Structs**: Used to represent complex data types such as events and bookings, allowing us to encapsulate related information in a single unit.

**Mappings**: Employed for efficiently storing and retrieving data, such as event details and user bookings, by associating unique identifiers with specific values.

**Events**: Used for logging significant occurrences within the contract, providing transparency and enabling external applications to react to important changes (e.g., ticket bookings and event updates).

**Functions**: Implemented to handle various functionalities, including creating events, booking tickets, checking availability, and deleting events. Each function includes necessary validations to maintain the integrity of the contract.

By understanding these components and their interactions, you can effectively manage events and ticket sales on the Celo blockchain, leveraging its capabilities for decentralized applications. This foundation can be expanded upon to incorporate additional features or integrate with front-end interfaces for a complete user experience.

```

```
