pragma solidity ^0.4.18;

contract BettingEtherColor {
    // custom types
    struct Bet {
        uint id;
        string betting_choice_color;
        uint betting_amount;
        address better;
        uint gameId;
        uint winValue;
    }
    struct GameStatistics {
        uint gameID;
        uint gamePool;
        uint blackPool;
        uint redPool;
        uint numberOfBets;
        string winningColor;
    }

    mapping(uint => Bet) public bets;
    mapping(uint => GameStatistics) public statistics;
    mapping(uint => Bet) public oldBets;
    uint public oldBetsCounter;
    Bet[] betArray;
    uint public ticketCounter;
    uint public totalBettingAmountColorGame;
    uint public gameNumber;
    bool public isGameRunning;
    uint public poolFee;
    string winColor;


    mapping(uint => uint) public colorTotalAmount; //0 =RED | 1=BLACK
    // organiser of the lottery
    address public organiser;

    //events

    event LogInsertColorBet(
        uint indexed_id,
        uint _betting_amount,
        string _betting_choice_color,
        address _better,
        uint timestamp
    );

    event LogGameClosed(
        uint gameId,
        string winningColor
    );

    event LogGameStarted(
        uint gameId
    );

    event AnyException(string message);

    //constructor
    function BettingEtherColor() public {
        organiser = msg.sender;
        isGameRunning = false;
        gameNumber = 0;
        poolFee = 1;
    }

    // deactivate the contract
    function kill() public {
        // only allow the contract owner
        require(msg.sender == organiser);
        selfdestruct(organiser);
    }
    function start_game() public {
        isGameRunning = true;
        gameNumber += 1;
        LogGameStarted(gameNumber);
    }

    function getGameId() public view returns(uint) {
        if(isGameRunning){
            return gameNumber;
        }

        return 0;
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
        bets[ticketCounter] = Bet(ticketCounter, _betting_choice_color, msg.value, msg.sender, gameNumber, 0);
        LogInsertColorBet(ticketCounter, msg.value, _betting_choice_color, msg.sender, block.timestamp);
    }

    //function to get winning address in red vs black
    function transfer_winnings_color_game(string winningColor) public returns (address) {
        require(organiser == msg.sender);
        winColor = winningColor;
        uint winningColorPool;
        if(keccak256('RED') == keccak256(winningColor)) {
            winningColorPool = colorTotalAmount[0];
        } else {
            winningColorPool = colorTotalAmount[1];
        }
        for(uint i = 1; i <= ticketCounter; i++) {
            if(keccak256(bets[i].betting_choice_color) == keccak256(winningColor)){
                bets[i].winValue = (bets[i].betting_amount * totalBettingAmountColorGame) / winningColorPool;
                bets[i].better.transfer(bets[i].winValue - bets[i].winValue / 100 * poolFee);
                organiser.transfer(bets[i].winValue / 100 * poolFee);
            } else {
                bets[i].winValue = 0;
            }
            oldBetsCounter++;
            oldBets[oldBetsCounter] = bets[i];
        }
        clearAllBets();
        isGameRunning = false;

        LogGameClosed(gameNumber, winningColor);
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
    //generate statistics
    function clearAllBets() private {
    
    statistics[gameNumber]= GameStatistics(gameNumber,
            totalBettingAmountColorGame,
            colorTotalAmount[1],
            colorTotalAmount[0],
            ticketCounter,
            winColor);
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
