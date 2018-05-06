pragma solidity ^0.4.23;


import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
/* import "./Tally.sol"; */
import "./BaseTally.sol";
contract RunningTally is BaseTally{
  using SafeMath for uint;
  enum VoteStatus {Absent, Favoring, Opposing}
  
  struct Tally{
    /* bool open; */
    uint yeaVotes;
    uint nayVotes;
    mapping(address=>VoteStatus) votes;
  }

  Tally[] public tallies;

  function withdrawVote (uint proposalID)
    membersOnly
    whileOpen(proposalID)
    public{
    Tally storage proposal = tallies[proposalID];
    _withdrawVote(proposal);
  }

  function _withdrawVote (Tally storage tally)
    private{
    VoteStatus status = tally.votes[msg.sender];
    require(tally.votes[msg.sender]!=VoteStatus.Absent);
    uint clout = getClout(msg.sender);
    if(status==VoteStatus.Favoring){
      tally.yeaVotes-= clout;
    }
    else if(status==VoteStatus.Opposing){
      tally.nayVotes-= clout;
    }
    tally.votes[msg.sender]=VoteStatus.Absent;
  }
  
  function vote(uint proposalID, bool inFavor)
    public
    membersOnly
    whileOpen(proposalID){
    Tally storage tally = tallies[proposalID];
    _withdrawVote(tally); //withdraws any vote the user previously made
    VoteStatus status = tally.votes[msg.sender];
    require(status==VoteStatus.Absent);
    uint clout = getClout(msg.sender);
    if(inFavor){
      tally.yeaVotes+= clout;
      tally.votes[msg.sender] = VoteStatus.Favoring;
    }
    else {
      tally.nayVotes+= clout;
      tally.votes[msg.sender] = VoteStatus.Opposing;
    }
  }

  function currentTally
    (uint index)
    public
    view
    returns (uint yeaVotes,
	     uint nayVotes){
    yeaVotes = tallies[index].yeaVotes;
    nayVotes = tallies[index].nayVotes;
  }

  function startTally()
    public
    onlyOwner{
    Tally memory tally = Tally(0,0);
    tallies.push(tally);
  }

}
