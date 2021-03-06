pragma solidity ^0.5.12;


import "./Base.sol";

/*
    Base contract for all modules
*/
contract Module is Base {
    address public pool;

    function initialize(address sender, address _pool) public initializer {
        Base.initialize(sender);
        setPool(_pool);
    }

    function setPool(address _pool) public onlyOwner {
        pool = _pool;        
    }

    function getModuleAddress(string memory module) public view returns(address){
        require(pool != ZERO_ADDRESS, "Base: no pool");
        (bool success, bytes memory result) = pool.staticcall(abi.encodeWithSignature("get(string)", module));
        
        //Forward error from Pool contract
        if (!success) assembly {
            revert(add(result, 32), result)
        }

        address moduleAddress = abi.decode(result, (address));
        require(moduleAddress != ZERO_ADDRESS, "Base: requested module not found");
        return moduleAddress;
    }

}
