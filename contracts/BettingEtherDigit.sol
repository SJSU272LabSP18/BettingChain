pragma solidity ^0.4.18;

contract BettingEtherDigit {
    // custom types
    struct Bet {
        uint id;
        uint betting_amount;
        uint betting_choice_digit;
        address better;
    }

    mapping(uint => Bet) public bets;
    uint public ticketCounter;
    uint public totalBettingAmountDigitGame;
    uint public gameNumber;
    bool public isGameRunning;


    mapping(uint => uint) public digitTotalAmount;
    // organiser of the lottery
    address public organiser;

    //events

    event LogInsertDigitBet(
        uint indexed_id,
        uint _betting_amount,
        uint _betting_choice_digit,
        address _better
    );
    event AnyException(string message);

    //constructor
    function BettingEtherDigit() public {
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



    //insert bet for digit game
    function insert_bet_digit(uint _betting_choice_digit) payable public {

        require(_betting_choice_digit>=0 && _betting_choice_digit <=9);
        ticketCounter++;
        totalBettingAmountDigitGame += msg.value;

        digitTotalAmount[_betting_choice_digit] += msg.value;
        bets[ticketCounter] = Bet(
            ticketCounter,
            msg.value,
            _betting_choice_digit,
            msg.sender
        );

        LogInsertDigitBet(ticketCounter,msg.value,_betting_choice_digit,msg.sender);
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
        return totalBettingAmountDigitGame;
    }

    //fetch bets
    function getPoolFee() public view returns(uint ) {
        return totalBettingAmountDigitGame*1/5;
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
    function getBetterDetailsByAddress(address _in_better) public view returns(uint id, address _better, uint _choice_digit, uint _betting_amount) {
        for(uint i = 1; i <= ticketCounter; i++) {
            if(bets[i].better == _in_better){
                return(
                i,
                bets[i].better,
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
        for(uint j = 0; j<2;j++)
        {
            digitTotalAmount[j]=0;
        }
        ticketCounter=0;
        totalBettingAmountDigitGame=0;
    }

}
