// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Market
 * @notice Simplified binary prediction market
 * @dev This is an MVP implementation. Production requires AMM pricing, oracles, etc.
 */
contract Market {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    address public immutable admin;
    string public question;
    uint256 public endTime;
    bool public resolved;
    uint8 public winningOutcome; // 0 or 1

    mapping(address => mapping(uint8 => uint256)) public positions; // user => outcome => amount
    mapping(uint8 => uint256) public totalShares; // outcome => total shares

    event Bought(address indexed user, uint8 outcome, uint256 amount, uint256 shares);
    event Resolved(uint8 winningOutcome);
    event Redeemed(address indexed user, uint256 amount);

    error MarketEnded();
    error MarketNotEnded();
    error MarketAlreadyResolved();
    error MarketNotResolved();
    error InvalidOutcome();
    error Unauthorized();
    error NoShares();

    constructor(address _token, address _admin, string memory _question, uint256 _endTime) {
        token = IERC20(_token);
        admin = _admin;
        question = _question;
        endTime = _endTime;
    }

    /**
     * @notice Buy shares for an outcome (simplified 1:1 pricing)
     */
    function buy(uint8 outcome, uint256 amount) external {
        if (block.timestamp >= endTime) revert MarketEnded();
        if (resolved) revert MarketAlreadyResolved();
        if (outcome > 1) revert InvalidOutcome();
        if (amount == 0) revert InvalidOutcome();

        token.safeTransferFrom(msg.sender, address(this), amount);
        
        uint256 shares = amount; // Simplified 1:1 pricing for MVP
        positions[msg.sender][outcome] += shares;
        totalShares[outcome] += shares;

        emit Bought(msg.sender, outcome, amount, shares);
    }

    /**
     * @notice Admin resolves the market
     */
    function resolve(uint8 _winningOutcome) external {
        if (msg.sender != admin) revert Unauthorized();
        if (block.timestamp < endTime) revert MarketNotEnded();
        if (resolved) revert MarketAlreadyResolved();
        if (_winningOutcome > 1) revert InvalidOutcome();

        resolved = true;
        winningOutcome = _winningOutcome;

        emit Resolved(_winningOutcome);
    }

    /**
     * @notice Redeem winning shares
     */
    function redeem() external {
        if (!resolved) revert MarketNotResolved();

        uint256 shares = positions[msg.sender][winningOutcome];
        if (shares == 0) revert NoShares();

        positions[msg.sender][winningOutcome] = 0;

        // Simplified: 1 winning share = 1 USDC (assuming 1:1 initial pricing)
        uint256 payout = shares;
        token.safeTransfer(msg.sender, payout);

        emit Redeemed(msg.sender, payout);
    }

    /**
     * @notice Get user's shares for an outcome
     */
    function getShares(address user, uint8 outcome) external view returns (uint256) {
        return positions[user][outcome];
    }
}
