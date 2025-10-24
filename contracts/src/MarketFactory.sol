// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Market.sol";

/**
 * @title MarketFactory
 * @notice Factory for creating prediction markets
 */
contract MarketFactory {
    address public immutable token;
    address public owner;

    Market[] public markets;

    event MarketCreated(address indexed market, string question, uint256 endTime);

    error Unauthorized();

    constructor(address _token) {
        token = _token;
        owner = msg.sender;
    }

    /**
     * @notice Create a new prediction market
     */
    function createMarket(string memory question, uint256 endTime) external returns (address) {
        if (msg.sender != owner) revert Unauthorized();

        Market market = new Market(token, owner, question, endTime);
        markets.push(market);

        emit MarketCreated(address(market), question, endTime);
        return address(market);
    }

    /**
     * @notice Get total number of markets
     */
    function getMarketCount() external view returns (uint256) {
        return markets.length;
    }

    /**
     * @notice Get market address by index
     */
    function getMarket(uint256 index) external view returns (address) {
        return address(markets[index]);
    }

    /**
     * @notice Transfer ownership
     */
    function transferOwnership(address newOwner) external {
        if (msg.sender != owner) revert Unauthorized();
        owner = newOwner;
    }
}
