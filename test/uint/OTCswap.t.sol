//SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import "forge-std/Test.sol";
import {OTCSwap} from  "../../src/OTCSwap.sol";
import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "../mocks/MockERC20.sol";

contract OTCSwapTest is Test {
    OTCSwap public otcswap;
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public alice;
    address public bob;
    uint256 public deadline;

    function setUp() public {
        tokenA = IERC20(address(new MockERC20("TokenA", "TKA", 18)));
        tokenB = IERC20(address(new MockERC20("TokenB", "TKB", 18)));
        alice = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        bob = address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);

        MockERC20(address(tokenA)).mint(alice, 1000 * 10 ** 18);
        MockERC20(address(tokenB)).mint(bob, 1000 * 10 ** 18);

        vm.prank(alice);
        tokenA.approve(address(otcswap), 1000 * 10 ** 18);

        vm.prank(bob);
        tokenB.approve(address(otcswap), 1000 * 10 ** 18);

        deadline = block.timestamp + 30 minutes;
    }

    function testSuccessfulSwap() public {
        uint256 amountA = 1000 * 10 ** 18;
        uint256 amountB = 1 * 10 ** 18;

        otcswap = new OTCSwap(
            alice,
            bob,
            address(tokenA),
            address(tokenB),
            amountA,
            amountB,
            deadline
        );

        vm.prank(alice);
        tokenA.approve(address(otcswap), amountA);

        vm.prank(bob);
        tokenB.approve(address(otcswap), amountB);

        vm.prank(bob);
        otcswap.excuteSwap();

        assertEq(tokenA.balanceOf(bob), amountA);
        assertEq(tokenB.balanceOf(alice), amountB);
    }

    function testSwapFailIfNoEnoughBalance() public {
        uint256 amountA = 1000 * 10 ** 18;
        uint256 amountB = 2000 * 10 ** 18;

        otcswap = new OTCSwap(
            alice,
            bob,
            address(tokenA),
            address(tokenB),
            amountA,
            amountB,
            deadline
        );

        vm.prank(alice);
        tokenA.approve(address(otcswap), amountA);

        vm.prank(bob);
        tokenB.approve(address(otcswap), amountB);

        vm.prank(bob);
        vm.expectRevert();
        otcswap.excuteSwap();
    }

    function testUnauthorizedExecution() public {
        uint256 amountA = 1000 * 10 ** 18;
        uint256 amountB = 1 * 10 ** 18;

        otcswap = new OTCSwap(
            alice,
            bob,
            address(tokenA),
            address(tokenB),
            amountA,
            amountB,
            deadline
        );

        address unauthorizedAddress = address(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
        vm.prank(unauthorizedAddress);
        vm.expectRevert("Only receiver can excute");
        otcswap.excuteSwap();
    }

    function testCancelSwap() public {
        uint256 amountA = 1000 * 10 ** 18;
        uint256 amountB = 1 * 10 ** 18;

        otcswap = new OTCSwap(
            alice,
            bob,
            address(tokenA),
            address(tokenB),
            amountA,
            amountB,
            deadline
        );

        vm.prank(alice);
        otcswap.cancelSwap();

        vm.prank(bob);
        vm.expectRevert("Swap is canceled");
        otcswap.excuteSwap();
    }
}