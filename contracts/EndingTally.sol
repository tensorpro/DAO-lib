pragma solidity ^0.4.23;


import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BaseTally.sol";

contract EndingTally is BaseTally{
  using SafeMath for uint;
  enum VoteStatus {Absent, Voted}
  
  
  struct Vote{
    VoteStatus status;
    bool inFavor;
    uint voteNum;
  }

  struct Tally{
    bool open;
    uint numVotes;
    address[] voters;
    mapping(address=>Vote) votes;
  }

  Tally[] public tallies;

  function withdrawVote (uint proposalNum)
    membersOnly
    public{
    Tally proposal = tallies[proposalNum];
    _withdrawVote(proposal);
  }

  function _withdrawVote (Tally storage tally)
    private{
    Vote storage removing = tally.votes[msg.sender];
    address a2 = tally.voters[tally.numVotes];
    Vote storage swapping = tally.votes[a2];
    tally.voters[removing.voteNum]=a2;
    swapping.voteNum = removing.voteNum;
    tally.numVotes = tally.numVotes.sub(1);
  }


  function vote(uint proposalID, bool inFavor)
    public
    membersOnly{
    mapping(address => Vote) votes = tallies[proposalID].votes;
    Vote storage vote_ = votes[msg.sender];
    require(vote_.status==VoteStatus.Absent);
    tallies[proposalID].numVotes=tallies[proposalID].numVotes.add(1);
    vote_.status=VoteStatus.Voted;
    vote_.inFavor = inFavor;
    vote_.voteNum = tallies[proposalID].numVotes;
    tallies[proposalID].voters.push(msg.sender);
  }

  function currentTally
    (uint index)
    public
    view
    returns (uint yeaVotes, uint nayVotes){
    yeaVotes = 0;
    nayVotes = 0;
    address[] storage voters = tallies[index].voters;
    mapping(address => Vote) votes = tallies[index].votes;
    // Starting at index 1, index 0 has a dummy value
    for(uint i=1; i<=tallies[index].numVotes;i++){
      uint clout = getClout(voters[i]);
      address addr = voters[i];
      if(votes[addr].inFavor) {
	yeaVotes+=clout;
      }
      else{
	nayVotes+=clout;
      }
    }
  }

  function startTally()
    public
    onlyOwner{
    super.startTally();
    Tally memory tally = Tally(false, 0, new address[](1));
    tallies.push(tally);
  }

}
