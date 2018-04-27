pragma solidity ^0.4.18;

contract BettingEther {
  // custom types
    struct Bet {
      uint id;
      uint betting_amount;
      string betting_choice_color;
      uint betting_choice_digit;
      address better;
  }

    mapping(uint => Bet) public bets;
    uint public ticketCounter;
    uint public totalBettingAmount;


    mapping(uint => uint) public colorDigitTotalAmount; // 0 = RED | 10 = BLACK

    // organiser of the lottery
    address public organiser;

    //events
    event LogInsertBet(
      uint indexed_id,
      uint _betting_amount,
      string _betting_choice_color,
      uint _betting_choice_digit,
      address _better
      );
    event AnyException(string message);

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
    function insert_bet(string _betting_choice_color, uint _betting_choice_digit, uint _betting_amount) payable public {

      require(_betting_amount == msg.value);
      require(_betting_choice_color == 'RED' || _betting_choice_color=='BLACK');
      require(_betting_choice_digit>=0 && _betting_choice_digit <=9);
      ticketCounter++;
      totalBettingAmount += _betting_amount;
      uint colorCode;
      if(keccak256('RED') == keccak256(_betting_choice_color))
      {
        colorCode=0;
      }
      else
      {
        colorCode=10;
      }

      colorDigitTotalAmount[colorCode+_betting_choice_digit] += _betting_amount;
      bets[ticketCounter] = Bet(
        ticketCounter,
        _betting_amount,
        _betting_choice_color,
        _betting_choice_digit,
        msg.sender
      );

      LogInsertBet(ticketCounter,_betting_amount,_betting_choice_color,_betting_choice_digit,msg.sender);
    }


    //fetch number of bets in the contract
    function getNumberOfBets() public view returns(uint) {
      return ticketCounter;
    }

    //function to get winning address in red vs black game
    //change bytes to string

    function display_winning_address(string _choice_color, uint _choice_digit) public returns (address) {
      uint totalBettingAmountForWinningChoice;
      uint colorCode;
      require(_betting_choice_color == 'RED' || _betting_choice_color=='BLACK');
      require(_betting_choice_digit>=0 && _betting_choice_digit <=9);
      if(keccak256('RED') == keccak256(_choice_color))
      {
        colorCode=0;
      }
      else
      {
        colorCode=10;
      }
      totalBettingAmountForWinningChoice=colorDigitTotalAmount[colorCode+_choice_digit];
      totalBettingAmount=totalBettingAmount*4/5;

      for(uint i = 1; i <= ticketCounter; i++) {

          if(keccak256(_choice_color) == keccak256(bets[i].betting_choice_color)
                    && _choice_digit==bets[i].betting_choice_digit) {

                uint refund = (bets[i].betting_amount*totalBettingAmount/totalBettingAmountForWinningChoice);
                bets[i].better.transfer(refund);
            }

        }
      clearAllBets();

      return(msg.sender);
    }

  //return function with address and bets on current game
    function getBetterDetailsByAddress(address _in_better) public view returns(uint id, address _better, string _choice_color, uint _choice_digit, uint _betting_amount) {
      for(uint i = 1; i <= ticketCounter; i++) {
        if(bets[i].better == _in_better){
          return(
          i,
          bets[i].better,
          bets[i].betting_choice_color,
          bets[i].betting_choice_digit,
          bets[i].betting_amount
          );
        }

      }
    }

  //function to clear all bets
  function clearAllBets() private {
    for(uint i = 1; i<= ticketCounter;i++) {
      delete bets[i];
    }
    for(uint j = 0; j<20;j++)
    {
      colorDigitTotalAmount[j]=0;
    }
    ticketCounter=0;
    totalBettingAmount=0;
    totalRedBettingAmount=0;
    totalBlackBettingAmount=0;
  }

}
