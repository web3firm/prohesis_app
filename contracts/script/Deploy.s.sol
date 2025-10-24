// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@forge-std/Script.sol";
import "../src/USDCMock.sol";
import "../src/MarketFactory.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy USDCMock
        USDCMock usdc = new USDCMock();
        console.log("USDCMock deployed at:", address(usdc));

        // Deploy MarketFactory
        MarketFactory factory = new MarketFactory(address(usdc));
        console.log("MarketFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
