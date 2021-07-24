// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @dev Transfer Control mechanism to control and restrict which address can
 * send to whom and which amount.
 *
 */


 contract TransferControl {
    
    // Sender to list or allowed receivers for that sender
    // first mapping is the sender, second mapping is receiver and bool
    mapping( address => mapping( address => bool)) private sender_to_receivers;


    mapping (address => bool ) private global_receivers;


    address private owner;

    constructor() {

       owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    function allowTransfer(address _sender, address _receiver) external onlyOwner() returns(bool)  {
        
        require(_sender != 0x0000000000000000000000000000000000000000, "Sender cannot be the NULL address");
        require(_receiver != 0x0000000000000000000000000000000000000000, "Receiver cannot be the NULL address");

        sender_to_receivers[_receiver][_sender] = true;


        return true;

    }

    function allowGlobalReceiver(address _receiver) onlyOwner() external returns (bool) {

        require(_receiver != 0x0000000000000000000000000000000000000000, "Receiver cannot be the NULL address");

        global_receivers[_receiver] = true;

        return true;

    }

    function isTransferAllowed(address _sender, address _receiver) external view returns (bool) {

        if( global_receivers[_receiver] == true ){
            return true;
        }

        return sender_to_receivers[_receiver][_sender];
    }

    function isTransferAllowed(address _receiver) external view returns (bool) {

        if( global_receivers[_receiver] == true ){
            return true;
        }

        return sender_to_receivers[_receiver][msg.sender];
    }


    function setOwner(address _newOwner) external onlyOwner() {

        require(owner != _newOwner, "The new owner of this contract cannot be the same owner");
        require(_newOwner != 0x0000000000000000000000000000000000000000, "New Owner cannot be the NULL address");

        owner = _newOwner;
    }




 }