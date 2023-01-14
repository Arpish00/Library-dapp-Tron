// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Library {

    //struct 
    struct Book {
        string name;
        string description;
        bool isavailible;
        uint256 price;
        address owner;
    }

    //to make it easy to find book
    uint256 public bookId;

    mapping(uint256 => Book) public books;

    //to make track
    struct TrackBook {
        uint256 bookId;
        address borrower;
        uint256 startDate;
        uint256 endDate;
    }

    //keep track of track list 
    uint256 public trackingCount;

    mapping(uint256 => TrackBook) public trackings;

    //events
    event newBook(uint256 bookId);
    event bookBorrowed(uint256 bookId, uint256 trackingCount);
    event DeletBook(uint256 bookId);

    function _sendTRX(address payTo, uint256 price) internal{
        payable(address(uint160(payTo))).transfer(price);
    }

    function addBook (string memory name, string memory description, uint256 price) public returns (bool) {

        //adding book
        Book memory bookToAdd = Book (name, description, true, price, msg.sender);

        books[bookId] = bookToAdd;

        bookId++;
        emit newBook(bookId);
        return true;
    }

    //function to borrow book
    function borrowBook (uint256 _bookId, uint256 startDate, uint256 endDate) public payable returns (bool) {
        Book storage bookToBorrow = books[_bookId];

        //require if book is availible
        require(bookToBorrow.isavailible = true, "Book isn't availible right now!");
        //check ammount payed
        require(msg.value == bookToBorrow.price * (endDate - startDate), "please enter valid ammout");


        //please remind that the send function is empty
        _sendTRX(bookToBorrow.owner, msg.value);
        
        TrackBook(_bookId, msg.sender, startDate, endDate);

        //updating values
        trackingCount++;
        bookToBorrow.isavailible = false;

        emit bookBorrowed(_bookId, trackingCount);
        return true;
    }

    function removeBook (uint256 _bookId) public returns (bool) {

        //check owner
        
        require(books[_bookId].owner == msg.sender, "you are not authorised to delet this book !");
        delete books[_bookId];

        emit DeletBook(_bookId);
        return true;
    }


    

}