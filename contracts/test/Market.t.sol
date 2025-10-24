// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@forge-std/Test.sol";
import "../src/USDCMock.sol";
import "../src/Market.sol";
import "../src/MarketFactory.sol";

contract MarketTest is Test {
    USDCMock public usdc;
    MarketFactory public factory;
    Market public market;

    address public admin = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    function setUp() public {
        usdc = new USDCMock();
        factory = new MarketFactory(address(usdc));

        // Create a market
        vm.prank(factory.owner());
        address marketAddr = factory.createMarket("Will ETH reach $5000 by EOY?", block.timestamp + 30 days);
        market = Market(marketAddr);

        // Fund users
        usdc.mint(user1, 10000 * 10 ** 6);
        usdc.mint(user2, 10000 * 10 ** 6);
    }

    function testBuyShares() public {
        uint256 amount = 100 * 10 ** 6; // 100 USDC

        vm.startPrank(user1);
        usdc.approve(address(market), amount);
        market.buy(0, amount); // Buy outcome 0
        vm.stopPrank();

        assertEq(market.getShares(user1, 0), amount);
        assertEq(market.totalShares(0), amount);
    }

    function testResolveAndRedeem() public {
        uint256 amount1 = 100 * 10 ** 6;
        uint256 amount2 = 200 * 10 ** 6;

        // User1 buys outcome 0
        vm.startPrank(user1);
        usdc.approve(address(market), amount1);
        market.buy(0, amount1);
        vm.stopPrank();

        // User2 buys outcome 1
        vm.startPrank(user2);
        usdc.approve(address(market), amount2);
        market.buy(1, amount2);
        vm.stopPrank();

        // Fast forward past end time
        vm.warp(block.timestamp + 31 days);

        // Admin resolves to outcome 0
        vm.prank(factory.owner());
        market.resolve(0);

        assertTrue(market.resolved());
        assertEq(market.winningOutcome(), 0);

        // User1 redeems (winner)
        uint256 balanceBefore = usdc.balanceOf(user1);
        vm.prank(user1);
        market.redeem();
        uint256 balanceAfter = usdc.balanceOf(user1);

        assertEq(balanceAfter - balanceBefore, amount1);
        assertEq(market.getShares(user1, 0), 0);
    }

    function testCannotBuyAfterEnd() public {
        vm.warp(block.timestamp + 31 days);

        vm.startPrank(user1);
        usdc.approve(address(market), 100 * 10 ** 6);
        vm.expectRevert(Market.MarketEnded.selector);
        market.buy(0, 100 * 10 ** 6);
        vm.stopPrank();
    }

    function testCannotResolveBeforeEnd() public {
        vm.prank(factory.owner());
        vm.expectRevert(Market.MarketNotEnded.selector);
        market.resolve(0);
    }

    function testUnauthorizedCannotResolve() public {
        vm.warp(block.timestamp + 31 days);

        vm.prank(user1);
        vm.expectRevert(Market.Unauthorized.selector);
        market.resolve(0);
    }

    function testFactoryCreatesMarkets() public {
        assertEq(factory.getMarketCount(), 1);
        assertEq(factory.getMarket(0), address(market));
    }
}
