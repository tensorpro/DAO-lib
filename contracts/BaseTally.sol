pragma solidity ^0.4.23;


import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Tally.sol";

contract BaseTally is Tally, Ownable{

  bool[] tallyOpen;
  
  function isMember(address)
    private
    view
    returns (bool){
    return true;
  }

  function getClout(address)
    internal
    view
    returns (uint clout){
    clout = 1;
  }

  function startTally()
    public
  {
    tallyOpen.push(true);
  }

  function finalize(uint proposalID)
    public
  {
    tallyOpen[proposalID]=false;
  }
  
  modifier membersOnly {
    require(isMember(msg.sender));
    _;
  }

  modifier whileOpen(uint index){
    require(index < tallyOpen.length);
    require(tallyOpen[index]);
    _;
  }
  
}
