// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./TransferControl.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
 contract RToken is IERC20 {

    string private name;

    string private symbol;

    uint256 private total_supply;

    address private issuer;

    mapping(address => uint256) private balances;

    mapping(address => mapping( address => uint256)) private allowances;

    TransferControl transfer_ctrl;

    event AddressAuthorized(address _address);

    modifier onlyIssuer() {

        require(msg.sender == issuer, "Only the token issuer can call this function");
        _;
    }

     constructor(string memory _name, string memory _smybol, uint256 _total_supply) {

         name = _name;
         symbol = _smybol;
         issuer = msg.sender;
         total_supply = _total_supply;
         balances[msg.sender] = total_supply; // the whole supply goes to the issuer at the very beginning
     }

     function getName() external view returns(string memory) {
         return name;
     }

     function getSymbol() external view returns(string memory) {
         return symbol;
     }

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view override returns (uint256) {
        
        return total_supply;
    }

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view override returns (uint256) {

        return balances[account];
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external override returns (bool) {

        // Here I will check if the recipient is in the list of the allowed recipients 
        _preTransfer(msg.sender, recipient);

        uint256 avail_amount = balances[msg.sender];

        require( amount <= avail_amount, "The amount requested exceeds the available balance");

        

        unchecked {

            balances[msg.sender] = avail_amount - amount;
            
        }
        
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;

    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view override returns (uint256) {


        return allowances[owner][spender];

    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external override returns (bool) {

        uint256 caller_amount = balances[msg.sender];

        require(caller_amount >= amount, "Cannot approve more tokens than those owned");

        allowances[msg.sender][spender] = amount; // the amount is SET, not increased.

        return true;

    }

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {

        _preTransfer(sender, recipient);

        uint256 allowed_amount = allowances[sender][recipient];

        require(amount <= allowed_amount, "Requesting an amount greater than the allowed one");

        uint256 sender_amount = balances[sender];

        require(amount <= sender_amount, "The sender does not have enough tokens");

        unchecked {

            balances[sender] = sender_amount - amount;
    
        }

        balances[recipient] += amount;

        unchecked {
            
            allowances[sender][recipient] = allowed_amount - amount;
        }
        
        emit Transfer(sender, recipient, amount);

        return true;

    }


    function mint(uint256 _amount) external onlyIssuer() {

        unchecked {
            total_supply = _amount + total_supply;
        }

        balances[issuer] += _amount; // add the new minted tokens to the issuer balances

    }

    function burn(uint256 _amount) external onlyIssuer() {


        uint256 issuer_amount = balances[issuer];

        require(_amount <= issuer_amount, "Cannot decrease supply beyond issuer owned amount");

        unchecked {
            total_supply = total_supply - _amount;
        }

        balances[issuer] = issuer_amount - _amount;

    }


    function isAuthorized(address _address) external view returns (bool) {
        
        // check if a transfer control policy has been set
        return transfer_ctrl.isTransferAllowed(msg.sender, _address);
    }

    function _preTransfer(address sender, address receiver) view internal {
        
        if( address( transfer_ctrl ) ==  0x0000000000000000000000000000000000000000  ){
            // no policy set
            return;
        }

        // check if the receiver is authorized to receive the money
        require( transfer_ctrl.isTransferAllowed(sender, receiver) == true, "The receiver address is not authorized to receive tokens from this sender");

    }

    function setIssuer(address _issuer) external onlyIssuer() {
        
        require( issuer != _issuer, "The new issuer is the same as the old one");
        
        issuer = _issuer;
    }

    function getIssuer() external view returns(address) {

        return issuer;

    }

    function setTransferControlPolicy(address _address) external onlyIssuer() {

        transfer_ctrl = TransferControl(_address); // Set to 0x0 address in order to unset it
    }

}