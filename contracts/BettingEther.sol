pragma solidity ^0.4.18;

contract BettingEther {
  // custom types
    struct Bet {
      uint id;
      uint betting_amount;
      string betting_choice;
      address better;
  }

    mapping(uint => Bet) public bets;
    uint ticketCounter;

    mapping(uint => uint) public bets_lengths;

    // organiser of the lottery
    address public organiser;

    //events
    event LogInsertBet(
      uint indexed_id,
      uint _betting_amount,
      string _betting_choice,
      address _better
      );

      //constructor
      function BettingEther() public {
        organiser = msg.sender;
      }
    // deactivate the contract
    function kill() public {
        // only allow the contract owner
        require(msg.sender == organiser);

        selfdestruct(organiser);
    }
    //insert each bet
    function insert_bet(string _betting_choice, uint _betting_amount) public {
      ticketCounter++;
      bets[ticketCounter] = Bet(
        ticketCounter,
        _betting_amount,
        _betting_choice,
        msg.sender
      );

      LogInsertBet(ticketCounter,_betting_amount,_betting_choice,msg.sender);
    }
    //fetch number of bets in the contract
    function getNumberOfBets() public view returns(uint) {
      return ticketCounter;
    }

    //function to get winning address in red vs black game
    function display_winning_address(string _choice) public view {
        for(uint i = 1; i <= ticketCounter; i++) {
            if(keccak256(_choice) == keccak256(bets[i].betting_choice)) {
                display_all_bets(i);
            }

        }
    }

    //return function with all address and bets on current game
    function display_all_bets(uint _id) public view returns(uint id, address _better, string _choice, uint _betting_amount) {
      for(uint i = 1; i <= ticketCounter; i++) {
        if(i == _id){
          return(
          i,
          bets[i].better,
          bets[i].betting_choice,
          bets[i].betting_amount
          );
        }

      }
    }

}
