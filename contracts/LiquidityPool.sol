// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./RToken.sol";

contract LiquidityPool {

   /**
    * Contains the address list and the invested amount in Tokens
    */
   mapping(address => uint256 ) private investors;

   RToken private token;

   uint256 private k;

   address private owner;


   event AmountInvested(address _investor, uint256 _amount, uint256 _tokens);

   constructor(address _tokenAddress) {

       require(msg.sender != 0x0000000000000000000000000000000000000000, "Owner cannot be the NULL address");
       
       owner = msg.sender;

       token = RToken(_tokenAddress);

       k = 10; // 10 tokens for 1 ETH

      
   }

   modifier onlyOwner() {
       require(msg.sender == owner, "Only the owner can call this function");
       _;
   }

   function setTokenAddress(address _tokenAddress) external onlyOwner() {
       token = RToken(_tokenAddress);
   }


   function borrow(uint256 amount) external {

   }

   /**
    * Invest the specified token and amount in this pool.
    */
   function invest() payable external {

      uint256 amount = msg.value;

      require( amount > 0 , "Amount invested is zero");

      unchecked {

          investors[msg.sender] += amount;
          
      }

      // Amount of tokens
      uint256 tokens_amount = amount * k;

      uint256 current_balance = token.balanceOf(address(0));

      require( current_balance >= tokens_amount, "Insufficient balance of tokens.");

      token.transfer(msg.sender, tokens_amount);

      emit AmountInvested(msg.sender, amount, tokens_amount);
      
     
   }

   /**
    * Redeems the specified amount of tokens as ETH.
    * This operation is possible if the caller has an account 
    * in this liquidity pool.
    */
   function redeem(uint256 amount) payable external {

       uint256 eth_invested = investors[msg.sender];

       require(amount > 0, "The amount to be redeemed must be positive");

       require( eth_invested > 0, "This address did not invest any ETH with this LP");

       uint256 eth_redeemed = k * amount;

       payable(msg.sender).transfer(eth_redeemed);


       
   }


}