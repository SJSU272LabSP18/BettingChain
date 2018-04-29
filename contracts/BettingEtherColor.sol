pragma solidity ^0.4.18;

contract BettingEtherColor {
  // custom types
    struct Bet {
      uint id;
      uint betting_amount;
      string betting_choice_color;
      address better;
  }

    mapping(uint => Bet) public bets;
    Bet[] betArray;
    uint public ticketCounter;
    uint public totalBettingAmountColorGame;
    uint public gameNumber;
    bool public isGameRunning;


    mapping(uint => uint) public colorTotalAmount; //0 =RED | 1=BLACK
    // organiser of the lottery
    address public organiser;

    //events

    event LogInsertColorBet(
      uint indexed_id,
      uint _betting_amount,
      string _betting_choice_color,
      address _better
      );

    event AnyException(string message);

      //constructor
      function BettingEtherColor() public {
        organiser = msg.sender;
        isGameRunning=false;
        gameNumber=0;
      }
    // deactivate the contract
    function kill() public {
        // only allow the contract owner
        require(msg.sender == organiser);
        selfdestruct(organiser);
    }
    function start_game() public {
      isGameRunning=true;
      gameNumber += 1;
    }


  //insert bet for color game
  function insert_bet_color(string _betting_choice_color, uint _betting_amount) payable public {

    require(_betting_amount == msg.value);
    require(isGameRunning == true);
    require(keccak256('RED') == keccak256(_betting_choice_color) || keccak256('BLACK') == keccak256(_betting_choice_color));
    ticketCounter++;
    totalBettingAmountColorGame += _betting_amount;
    uint colorCode;
    if(keccak256('RED') == keccak256(_betting_choice_color))
    {
      colorCode=0;
    }
    else
    {
      colorCode=1;
    }

    colorTotalAmount[colorCode] += _betting_amount;
    bets[ticketCounter] = Bet(
      ticketCounter,
      _betting_amount,
      _betting_choice_color,
      msg.sender
    );

    LogInsertColorBet(ticketCounter,_betting_amount,_betting_choice_color,msg.sender);
  }


  //function to get winning address in red vs black
  function transfer_winnings_color_game(string _choice_color) public returns (address) {
    uint totalBettingAmountForWinningChoice;
    uint colorCode;
    require(keccak256('RED') == keccak256(_choice_color) || keccak256('BLACK') == keccak256(_choice_color));
    if(keccak256('RED') == keccak256(_choice_color))
    {
      colorCode=0;
    }
    else
    {
      colorCode=1;
    }
    totalBettingAmountForWinningChoice=colorTotalAmount[colorCode];
    totalBettingAmountColorGame=totalBettingAmountColorGame*4/5;

    for(uint i = 1; i <= ticketCounter; i++) {

      if(keccak256(_choice_color) == keccak256(bets[i].betting_choice_color)) {

        uint refund = (bets[i].betting_amount*totalBettingAmountColorGame/totalBettingAmountForWinningChoice);
        bets[i].better.transfer(refund);
      }

    }
    clearAllBets();
    isGameRunning=false;
    return(msg.sender);
  }

  //fetch number of bets in the contract
  function getNumberOfBets() public view returns(uint) {
    return ticketCounter;
  }

  //fetch current game number
  function getCurrentGameNumber() public view returns(uint) {
    return gameNumber;
  }

  //fetch pool balance
  function getPoolBalance() public view returns(uint) {
    return totalBettingAmountColorGame;
  }

  //fetch bets
  function getPoolFee() public view returns(uint ) {
    return totalBettingAmountColorGame*1/5;
  }



  //return function with address and bets on current game
    function getBetterDetailsByAddress(address _in_better) public view returns(uint id, address _better, string _choice_color, uint _betting_amount) {
      for(uint i = 1; i <= ticketCounter; i++) {
        if(bets[i].better == _in_better){
          return(
          i,
          bets[i].better,
          bets[i].betting_choice_color,
          bets[i].betting_amount
          );
        }

      }
    }

  //function to clear all bets
  //deals with color game only as of now
  function clearAllBets() private {
    for(uint i = 1; i<= ticketCounter;i++) {
      delete bets[i];
    }
    for(uint j = 0; j<2;j++)
    {
      colorTotalAmount[j]=0;
    }
    ticketCounter=0;
    totalBettingAmountColorGame=0;
  }

}
