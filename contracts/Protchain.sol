pragma solidity ^0.4.11;

contract Protchain {
  // Custom types
    struct Insurance {
        uint id;
        address insurer;
        string name;
        string lastname;
        string make;
        string model;
        uint256 term;
        uint256 devicePrice;
        uint256 insurancePrice;
        bool claimed;
        bool paid_back;
  }

  // State variables
    mapping(uint => Insurance) public insurances;
    uint insuranceCounter;

  // Events
    event buyInsuranceEvent (
        uint indexed _id,
        address indexed _insurer,
        string _name,
        string _lastname,
        uint256 _insurancePrice
    );
    event claimInsuranceEvent (
        uint indexed _id,
        address indexed _insurer,
        string _name,
        string _lastname,
        uint256 _insurancePrice
    );

  // buy Insurance
    function buyInsurance(string _name, string _lastname, string _make, string _model, uint256 _term, uint256 _devicePrice, uint256 _insurancePrice) payable public {

        require(_insurancePrice == msg.value);
        // a new insurance
        insuranceCounter++;

        // store this article
        insurances[insuranceCounter] = Insurance(insuranceCounter, msg.sender, _name, _lastname, _make, _model, _term, _devicePrice, _insurancePrice, false, false);

    // trigger the event
        buyInsuranceEvent(insuranceCounter, msg.sender, _name, _lastname, _insurancePrice);
  }

  // fetch the number of articles in the contract
    function getNumberOfInsurances() public constant returns (uint) {
        return insuranceCounter;
    }

    function claim(address _address) public {
        for (uint i = 1; i <= insuranceCounter; i++) {
            if (insurances[i].insurer == msg.sender) {
                Insurance storage  insurance = insurances[i];
                insurance.claimed = true;
                insurance.paid_back = true;
                insurance.insurer.transfer(insurance.insurancePrice);
            }
        }
    }

    function getInsuranceByAddress(address _insurer) public constant returns (
        string name,
        string lastname,
        string make,
        string model,
        uint256 term,
        uint256 devicePrice,
        uint256 insurancePrice,
        bool claimed,
        bool paid_back,
        uint id)
    {
        for (uint i = 1; i <= insuranceCounter; i++) {
            if (insurances[i].insurer == _insurer) {
                return (
                insurances[i].name,
                insurances[i].lastname,
                insurances[i].make,
                insurances[i].model,
                insurances[i].term,
                insurances[i].devicePrice,
                insurances[i].insurancePrice,
                insurances[i].claimed,
                insurances[i].paid_back,
                insurances[i].id);
            }
        }

        return("", "", "", "", 0, 0, 0, false, false, 0);
    }
}
