pragma solidity ^0.5.12;

import "../../common/Module.sol";

contract VotesModule is Module {

    function initialize(address sender, address _pool) public initializer {
        Module.initialize(sender, _pool);
    }
}