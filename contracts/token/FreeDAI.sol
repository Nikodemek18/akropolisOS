pragma solidity ^0.5.12;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "../common/Base.sol";

/**
 * @notice PToken contract mock
 */
contract FreeDAI is Base, ERC20Detailed, ERC20Burnable {

    function initialize(address sender) public initializer {
        Base.initialize(sender);
        ERC20Detailed.initialize("Free DAI for tests", "fDAI", 18);
    }

    /**
    * @notice Allows mintinf of this token
    * @param amount Amount to  mint
    */
    function mint(uint256 amount) public returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }

    /**
    * @notice Allows mintinf of this token
    * @param account Receiver ot minted tokens
    * @param amount Amount to  mint
    */
    function mint(address account, uint256 amount) public returns (bool) {
        _mint(account, amount);
        return true;
    }

}

