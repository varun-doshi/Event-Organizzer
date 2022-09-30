pragma solidity ^0.8;
contract eventOrganizer{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date>block.timestamp,"You may only create event for a future date");
        require(ticketCount>0,"You must have atleast 1 ticket");
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable {
        require(events[id].date!=0,"Event does not exist");
        require(block.timestamp<events[id].date,"Event over");
        require(quantity<events[id].ticketRemain,"tickets sold out");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Not enough ether");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(block.timestamp<events[id].date,"Event over");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
        }
    function viewTicket(uint id) view external returns(uint){
        return tickets[msg.sender][id];

    }
}