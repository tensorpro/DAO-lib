pragma solidity ^0.4.23;
import "./Tally.sol";

contract ExecutableTally is Tally{
  bool[] executed;

  function canExecute(uint index) returns (bool){
    return ((index < executed.length) &&
	    (!executed[index]));
  }
  function executeBody(uint index) returns (bool);

  function executePostHook(uint index){
    executed[index]=true;
  }
  function execute(uint index){
    require(canExecute(index));
    require(executeBody(index));
    executePostHook(indexe;)
  }
}
