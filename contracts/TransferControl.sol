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

    // Max amount a receiver can receive from that sender
    mapping( address => uint256 ) private receiver_to_amount;
    // Allowed list of receivers
    mapping( address => bool ) private receiver_allowed_list;


    function isReceiverAllowed(address _receiver) external view returns(bool) {
        return receiver_allowed_list[_receiver];
    }

    function isReceiverAllowedForSender(address _receiver) external view returns(bool) {
        
        require(receiver_allowed_list[_receiver] == true, "Receiver address is globally not allowed");

        require(msg.sender != 0x0000000000000000000000000000000000000000, "Sender cannot be the NULL address");

        return sender_to_receivers[_receiver][msg.sender];
        
    }

    function allowReceiver(address _receiver) external returns(bool) {
        
        require(msg.sender != 0x0000000000000000000000000000000000000000, "Sender cannot be the NULL address");
        require(_receiver != 0x0000000000000000000000000000000000000000, "Receiver cannot be the NULL address");

        sender_to_receivers[_receiver][msg.sender] = true;

        return true;

    }


 }