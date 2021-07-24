// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./RToken.sol";

contract LiquidityPool {

   /**
    * Contains the address list and the invested amount in Tokens
    */
   mapping(address => uint256 ) private investors;

   mapping(address => uint256) private borrowers;

   RToken private token;

   uint256 private k; // constant product between eth and tokens

   address private owner;


   event LiquidityProvided(address _sender, uint256 _eth, uint256 _tokens, bool _eth_provided);

   constructor(address _tokenAddress) payable {

       require(msg.sender != 0x0000000000000000000000000000000000000000, "Owner cannot be the NULL address");
       require(_tokenAddress != 0x0000000000000000000000000000000000000000, "Token address cannot be NULL");
       
       owner = msg.sender;

       token = RToken(_tokenAddress);

       uint256 tokens = token.totalSupply();

       k = tokens * msg.value;
      
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

   function repay(uint256 amount) external {


   }

   /**
    * Invest the specified token and amount in this pool.
    */
   function invest() payable external {

      
     
   }

   /**
    * Redeems the specified amount of tokens as ETH.
    * This operation is possible if the caller has an account 
    * in this liquidity pool.
    */
   function redeem(uint256 amount) payable external {


       
   }


   function borrow() payable external returns(uint256) {

      uint256 eth_provided = msg.value; // amount of ETH provided

      require(eth_provided > 0, "ETH amount should be greater than zero");

      // current balance
      uint256 eth_balance = address(this).balance;

      uint256 new_token_balance;
      uint256 token_amount;

      (token_amount, new_token_balance) = _computeNewSupply(eth_provided, eth_balance, k );

      token.transferFrom(address(this), msg.sender, token_amount);

      emit LiquidityProvided(msg.sender, eth_provided, token_amount, true);

      return token_amount;

   }

   function enterMarket(uint256 amount) external {

       token.approve(address(this), amount);

   }

   function provideLiquidity(uint256 amount) payable external {
      
       // ...
   }

   /**
    * Calculate new supply given the formula X*Y = C
    * We assume dx is the increment in x supply, 
    * x0 is the current supply and c is the constant
    * value binding x and y supplies (x*y = c)
    * Returns the new supply and the supply increment
    */
   function _computeNewSupply(uint256 dx, uint256 x0, uint256 c) private pure returns(uint256 dy, uint256 y1) {

       // calculate current supply of y0 from relation x*y = c
       uint256 y0 = 0;
       
       unchecked {

         y0 = c/x0;  

       }
       
       // calculate new supply of y given the increment dx

       y1 = 0;
       dy = 0;

       unchecked {

            y1 = c/(dx + x0);

            dy = y0 - y1;
           
       }
       

       return (dy, y1);

   }


}