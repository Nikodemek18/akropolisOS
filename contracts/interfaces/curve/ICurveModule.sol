pragma solidity ^0.5.12;

/**
 * @title Bonding Curve Interface
 * @dev A bonding curve is a method for continous token minting / burning.
 */
interface ICurveModule {
    /**
     * @notice Calculates amount of pTokens to mint
     * @param liquidAssets Liquid assets in Pool
     * @param debtCommitments Debt commitments
     * @param lAmount Amount of liquidTokens to deposit
     * @return Amount of pTokens to mint/unlock
     */
    function calculateEnter(uint256 liquidAssets, uint256 debtCommitments, uint256 lAmount) external view returns (uint256);

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param liquidAssets Liquid assets in Pool
     * @param lAmount Amount of liquid tokens to withdraw (full: sum of withdrawU and withdrawP)
     * @return Amount of pTokens to burn/lock
     */
    function calculateExit(uint256 liquidAssets, uint256 lAmount) external view returns (uint256);

    /**
     * @notice Calculates amount of liquid tokens one can withdraw from the pool when pTokens are burned/locked
     * @param liquidAssets Liquid assets in Pool
     * @param pAmount Amount of pTokens to withdraw
     * @return Amount of liquid tokens to withdraw: total, for user, for pool
     */
    function calculateExitInverse(uint256 liquidAssets, uint256 pAmount) external view returns (uint256 withdraw, uint256 withdrawU, uint256 withdrawP);

}