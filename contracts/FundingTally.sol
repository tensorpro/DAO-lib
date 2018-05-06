pragma solidity ^0.4.23;
import "./ExecutableTally.sol";

contract FundingTally is ExecutableTally{
  struct payment{
    address to;
    uint amount;
  }
  payment[] payments;
  function executeBody(uint index){
    sendPayment(payments[index].to, payments[index].amount);
  }

  function sendPayment(address to, uint amount);

  function startFundingTally(address to, uint amount){
    payments.push(payment(to, amount));
  }
}
