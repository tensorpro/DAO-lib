pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/math/SafeMath.sol";


import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./Tally.sol";
/**
 * @title ShareholderDAO
 * @dev Based on Solidity's split payment.
 * Modified to use a token to determine the number of shares
 */
contract ShareholderDAO {
  using SafeMath for uint256;


  ERC20 token;
  Tally[] public tallies;
  struct stakeHolder{
    bool isHolder;
    uint balance;
    uint index;
  }
  mapping(address => stakeHolder) public stakeholders;
  address[] public stakeholderList;
  uint public numStakeholders;
  /**
   * @dev payable fallback
   */
  function () public payable {}

  /**
   * @dev Claim stake some Tokens, giving you a certain amount of clout.
   */

  function stakeTokens (uint numTokens)
    public{
    bool didTransfer = token.transferFrom(msg.sender, address(this), numTokens);
    require(didTransfer);
    stakeHolder storage hldr = stakeholders[msg.sender];
    hldr.balance = hldr.balance.add(numTokens);
  }

  function canWithdraw(address addr)
    public view returns (bool){
    return (stakeholders[addr].isHolder &&
	    stakeholders[addr].balance > 0);
  }

  function withdrawTokens(){
    require(canWithdraw(msg.sender));
    stakeHolder storage hldr = stakeholders[msg.sender];
    token.transfer(msg.sender, hldr.balance);
    stakeholderList[hldr.index]=stakeholderList[numStakeholders-1];
    hldr.balance=0;
    hldr.isHolder = false;
    numStakeholders = numStakeholders.sub(1);
  }
  
}
