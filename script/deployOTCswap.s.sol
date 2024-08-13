// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/OTCSwap.sol";  // Update the path if necessary

contract DeployOTCSwap is Script {
    
    function run() external {

        uint256 deployerPrivateKey = vm.envUint("private_KEY");

        vm.startBroadcast(deployerPrivateKey);

        OTCSwap otcswap = new OTCSwap(
            0xa0Ee7A142d267C1f36714E4a8F75612F20a79720,   
            0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f,    
            0x14dC79964da2C08b23698B3D3cc7Ca32193d9955,    
            0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,                   
            1000,                    
            1000,     
            block.timestamp + 30 minutes 
        );

        vm.stopBroadcast();

        console.log("OTCSwap has been deployed at:", address(otcswap));
    }
}
