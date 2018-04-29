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
    uint public totalBettingAmount; //for combination of color and digit game
    uint public totalBettingAmountColorGame;
    uint public totalBettingAmountDigitGame;
    uint public gameNumber;
    bool public isGameRunning;


    mapping(uint => uint) public colorDigitTotalAmount; // 0 = RED | 10 = BLACK
    mapping(uint => uint) public colorTotalAmount; //0 =RED | 1=BLACK
    mapping(uint => uint) public digitTotalAmount;
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
    event LogInsertColorBet(
      uint indexed_id,
      uint _betting_amount,
      string _betting_choice_color,
      address _better
      );
    event LogInsertDigitBet(
      uint indexed_id,
      uint _betting_amount,
      uint _betting_choice_digit,
      address _better
      );
    event AnyException(string message);

      //constructor
      function BettingEther() public {
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
    //insert each bet combination of color and digit
    function insert_bet(string _betting_choice_color, uint _betting_choice_digit, uint _betting_amount) payable public {

      require(_betting_amount == msg.value);
      require(keccak256('RED') == keccak256(_betting_choice_color) || keccak256('BLACK') == keccak256(_betting_choice_color));
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

  //insert bet for color game
  function insert_bet_color(string _betting_choice_color) payable public {
      require(isGameRunning == true);
      require(keccak256('RED') == keccak256(_betting_choice_color) || keccak256('BLACK') == keccak256(_betting_choice_color));
      ticketCounter++;
      totalBettingAmountColorGame += msg.value;
      uint colorCode;
      if(keccak256('RED') == keccak256(_betting_choice_color)) {
          colorCode=0;
      } else {
          colorCode=1;
      }
      colorTotalAmount[colorCode] += msg.value;
      bets[ticketCounter] = Bet(ticketCounter, msg.value, _betting_choice_color, 0, msg.sender);
      LogInsertColorBet(ticketCounter,msg.value,_betting_choice_color,msg.sender);
  }
  //insert bet for digit game
  function insert_bet_digit(uint _betting_choice_digit, uint _betting_amount) payable public {

    require(_betting_amount == msg.value);
    require(_betting_choice_digit>=0 && _betting_choice_digit <=9);
    ticketCounter++;
    totalBettingAmountDigitGame += _betting_amount;

    digitTotalAmount[_betting_choice_digit] += _betting_amount;
    bets[ticketCounter] = Bet(
      ticketCounter,
      _betting_amount,
      "",
      _betting_choice_digit,
      msg.sender
    );

    LogInsertDigitBet(ticketCounter,_betting_amount,_betting_choice_digit,msg.sender);
  }


    //fetch number of bets in the contract
    function getNumberOfBets() public view returns(uint) {
      return ticketCounter;
    }

    //function to get winning address in red vs black  and digit game combined
    function transfer_winnings(string _choice_color, uint _choice_digit) public returns (address) {
      uint totalBettingAmountForWinningChoice;
      uint colorCode;
      require(keccak256('RED') == keccak256(_choice_color) || keccak256('BLACK') == keccak256(_choice_color));
      require(_choice_digit>=0 && _choice_digit <=9);
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
      isGameRunning=false;
      return(msg.sender);
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

  //Add transfer winnings for digit game
  function transfer_winnings_digit_game(uint _choice_digit) public returns (address) {
    uint totalBettingAmountForWinningChoice;
    require(_choice_digit>=0 && _choice_digit <=9);

    totalBettingAmountForWinningChoice = digitTotalAmount[_choice_digit];
    totalBettingAmountDigitGame=totalBettingAmountDigitGame*4/5;

    for(uint i = 1; i <= ticketCounter; i++) {

      if(_choice_digit==bets[i].betting_choice_digit) {

        uint refund = (bets[i].betting_amount*totalBettingAmountDigitGame/totalBettingAmountForWinningChoice);
        bets[i].better.transfer(refund);
      }

    }
    clearAllBets();
    isGameRunning=false;
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
