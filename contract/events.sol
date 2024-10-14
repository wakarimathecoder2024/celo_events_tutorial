// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

contract Events {
    uint256 private eventscount = 0;
    // Mapping of events
    mapping(uint256 => Event) private _events;

    // Mapping of bookings
    mapping(address => Booking[]) private _bookings;

    // Event emitted when a new event is created
    event NewEventCreated(
        uint256 indexed eventId,
        string eventName,
        string description,
        uint256 startDate,
        uint256 endDate
    );

    //update event
    event updateevent(string eventName, uint256 startDate, uint256 endDate);

    //dlet event
    event deleteevent(string eventname, uint256 eventid);

    // Event emitted when a booking is made
    event BookingMade(
        address indexed user,
        uint256 indexed eventId,
        string nameofevent
    );

    // Event emitted when a booking is canceled

    struct Event {
        string name;
        uint256 startDate;
        uint256 endDate;
        uint256 price;
        bool isActive;
        address owner;
        string description;
        uint256 event_id;
        uint256 total_tickets;
        bool isrefundable;
        address payable celoaddress;
    }

    struct Booking {
        address user;
        uint256 eventId;
        uint256 price;
    }

    // Function to create a new event
    function createEvent(
        string memory _nameofevent,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _price,
        string memory _description,
        uint256 _total_tickets,
        bool _isrefundable,
        address _celo
    ) external {
        require(
            _startDate > block.timestamp,
            "Start date must be in the future"
        );
        require(_endDate > _startDate, "End date must be after start date");
        require(_price > 1, "price must be not below zero");
        require(
            _total_tickets > 10,
            "number of tickets should be more than 10"
        );
        uint256 eventId = uint256(
            keccak256(abi.encodePacked(block.timestamp, _nameofevent))
        ) % 1000000;
        _events[eventId] = Event({
            name: _nameofevent,
            startDate: _startDate,
            endDate: _endDate,
            price: _price,
            isActive: true,
            owner: msg.sender,
            description: _description,
            event_id: eventId,
            total_tickets: _total_tickets,
            isrefundable: _isrefundable,
            celoaddress: payable(_celo)
        });
        eventscount++;
        emit NewEventCreated(
            eventId,
            _nameofevent,
            _description,
            _startDate,
            _endDate
        );
    }

    // Function to update an existing event
    function updateEvent(
        uint256 _eventId,
        uint256 _newStartDate,
        uint256 _newEndDate,
        uint256 _newPrices,
        bool _isrefundable,
        bool _isactive,
        string memory _description
    ) external {
        require(_events[_eventId].isActive, "Event is not active");
        require(
            _newStartDate > block.timestamp,
            "Start date must be in the future"
        );
        require(
            _newEndDate > _newStartDate,
            "End date must be after start date"
        );
        require(
            _events[_eventId].owner == msg.sender,
            "only owner is parmitted to this action"
        );
        _events[_eventId].startDate = _newStartDate;
        _events[_eventId].endDate = _newEndDate;
        _events[_eventId].description = _description;
        _events[_eventId].price = _newPrices;
        _events[_eventId].isActive = _isactive;
        _events[_eventId].isrefundable = _isrefundable;

        emit updateevent(_events[_eventId].name, _newStartDate, _newEndDate);
    }

    // Function to delete an event
    function deleteEvent(uint256 _eventId) public {
        require(
            msg.sender == _events[_eventId].owner,
            "only owner is permitted to perform this action"
        );
        require(_events[_eventId].isActive, "Event is not active");
        emit deleteevent(_events[_eventId].name, _eventId);
        delete _events[_eventId];
        eventscount--;
    }

    //function to getallevents
    function getAllEvents() public view returns (Event[] memory) {
        uint256 eventCount = eventscount;
        Event[] memory allEvents = new Event[](eventCount);

        for (uint256 i = 0; i < eventCount; i++) {
            allEvents[i] = _events[i];
        }

        return allEvents;
    }

    //search for a single event
    function getdetailsofAnEvent(uint256 event_id)
        public
        view
        returns (Event memory)
    {
        return _events[event_id];
    }

    // Function to book tickets
    function buytickets(uint256 _eventId) external {
        require(
            _events[_eventId].total_tickets > 1,
            "events tickets already sold"
        );
        require(_events[_eventId].isActive, "Event is not active");
        require(
            IERC20Token(_events[_eventId].celoaddress).transferFrom(
                msg.sender,
                _events[_eventId].owner,
                _events[_eventId].price
            ),
            "Transfer failed."
        );
        Booking memory newBooking = Booking({
            user: msg.sender,
            eventId: _eventId,
            price: _events[_eventId].price
        });
        _events[_eventId].total_tickets = _events[_eventId].total_tickets - 1;
        _bookings[msg.sender].push(newBooking);

        emit BookingMade(msg.sender, _eventId, _events[_eventId].name);
    }

    // Function to check availability of tickets
    function checkAvailability(uint256 _eventId)
        external
        view
        returns (uint256 availableTickets)
    {
        require(_events[_eventId].isActive, "Event is not active");

        availableTickets = _events[_eventId].total_tickets;
    }
}
