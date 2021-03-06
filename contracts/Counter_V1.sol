pragma solidity 0.5.12;

import "@openzeppelin/upgrades/contracts/Initializable.sol";

contract Counter_V1 is Initializable {
    //it keeps a count to demonstrate stage changes
    uint private count;
    address private _owner;

    function initialize(uint num) public initializer {
        _owner = msg.sender;
        count = num;
    }

       //and it can add to a count
    function increaseCounter(uint256 amount) public {
        count = count + amount;
    }

    //We'll upgrade the contract with this function after deploying it
    //Function to decrease the counter
    function decreaseCounter(uint256 amount) public returns (bool) {
        require(count > amount, "Cannot be lower than 0");
        count = count - amount;
        return true;
    }
    
    function increaseCounter2(uint256 amount) public {
        count = count + amount+2;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    // getter
    function getCounter() public view returns (uint) {
        return count;
    }
}