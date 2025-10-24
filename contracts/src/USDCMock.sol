// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title USDCMock
 * @notice Mock USDC token for testing (6 decimals)
 */
contract USDCMock is ERC20 {
    constructor() ERC20("USD Coin (Mock)", "USDC") {}

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /**
     * @notice Faucet function for testing - mints 1000 USDC
     */
    function faucet() external {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    /**
     * @notice Mint function for admin/testing
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
