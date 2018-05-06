pragma solidity ^0.4.23;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Tally{
  function vote(uint proposalID, bool inFavor) public;
  function withdrawVote(uint proposalID) public;
  /* function getClout(address) internal view returns (uint clout); */
  function currentTally(uint proposalID) public view returns
    (uint inFavor, uint inOpposition);
  function finalize(uint proposalID) public;
  function startTally() public;
}
