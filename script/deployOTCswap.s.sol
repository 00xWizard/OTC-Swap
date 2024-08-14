// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {OTCSwap} from "../src/OTCSwap.sol";

contract DeployOTCSwap is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the OTCSwap contract
        OTCSwap otcswap = new OTCSwap();

        console.log("OTCSwap deployed at:", address(otcswap));

        vm.stopBroadcast();
    }
}
