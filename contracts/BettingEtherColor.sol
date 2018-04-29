pragma solidity ^0.4.18;

contract BettingEtherColor {
    // custom types
    struct Bet {
        uint id;
        string betting_choice_color;
        uint betting_amount;
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
        bets[ticketCounter] = Bet(ticketCounter, _betting_choice_color, msg.value, msg.sender);
        LogInsertColorBet(ticketCounter,msg.value,_betting_choice_color,msg.sender);
    }

    //function to get winning address in red vs black
    function transfer_winnings_color_game(string _choice_color) public returns (address) {
        uint totalBettingAmountForWinningChoice;
        uint colorCode;
        require(keccak256('RED') == keccak256(_choice_color) || keccak256('BLACK') == keccak256(_choice_color));
        if(keccak256('RED') == keccak256(_choice_color)) {
            colorCode=0;
        } else {
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
    function getBetterDetailsByAddress(address _in_better) public view returns(uint[]) {
        uint numberOfUserBets = 0;
        uint[] memory userBets = new uint[](ticketCounter);
        for(uint i = 1; i <= ticketCounter; i++) {
            if(bets[i].better == _in_better){
                userBets[numberOfUserBets] = i;
                numberOfUserBets++;
            }
        }
        uint[] memory response = new uint[](numberOfUserBets);
        for(uint j = 0; j < numberOfUserBets; j++) {
            response[j] = userBets[j];
        }

        return response;
    }

    //return (i, bets[i].better, bets[i].betting_choice_color, bets[i].betting_amount);
    //function to clear all bets
    //deals with color game only as of now
    function clearAllBets() private {
        for(uint i = 1; i<= ticketCounter;i++) {
            delete bets[i];
        }
        for(uint j = 0; j<2;j++){
            colorTotalAmount[j]=0;
        }
        ticketCounter=0;
        totalBettingAmountColorGame=0;
    }
}
