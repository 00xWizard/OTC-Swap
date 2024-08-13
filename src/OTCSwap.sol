//SPDX-License-Identifier: MIT 

pragma solidity 0.8.23;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract OTCSwap {
    using SafeERC20 for IERC20;

    /// @notice The address of the initiator of the swap
    address public initiator;

    /// @notice The address of the receiver in the swap
    address public receiver;

    /// @notice The address of the first token to be swapped
    address public tokenA;

    /// @notice The address of the second token to be swapped
    address public tokenB;

    /// @notice The amount of `tokenA` to be transferred from the initiator to the receiver
    uint256 public amountA;

    /// @notice The amount of `tokenB` to be transferred from the receiver to the initiator
    uint256 public amountB;
    
    /// @notice The deadline for the swap to be executed
    uint256 public deadline;

    /// @notice A boolean indicating whether the swap has been executed
    bool public isExecuted;

    /// @notice A boolean indicating whether the swap has been canceled
    bool public isCanceled;

    event SwapExecuted(address indexed initiator, address indexed receiver, uint256 amountA, uint256 amountB);
    event SwapCanceled(address indexed initiator);


    /// @notice Constructor to initialize the contract with swap parameters
    /// @param _initiator The address of the initiator of the swap
    /// @param _receiver The address of the receiver in the swap
    /// @param _tokenA The address of the first ERC20 token to be swapped
    /// @param _tokenB The address of the second ERC20 token to be swapped
    /// @param _amountA The amount of `tokenA` to be swapped
    /// @param _amountB The amount of `tokenB` to be swapped
    /// @param _deadline The deadline for executing the swap
    constructor(
        address _initiator,
        address _receiver,
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB,
        uint256 _deadline
    ) {
        initiator = _initiator;
        receiver = _receiver;
        tokenA = _tokenA;
        tokenB = _tokenB;
        amountA = _amountA;
        amountB = _amountB;
        deadline = _deadline;
       
    }

    modifier onlyReceiver(){
        require(msg.sender == receiver, "Only receiver can excute");
        _;
    }


    modifier onlyInitiator(){
        require(msg.sender == initiator, "Only initiator can cancel");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp <=  deadline, "The Deadline has passed");
        _;
    }


    /// @notice Executes the token swap between the initiator and receiver
    function excuteSwap() external onlyReceiver beforeDeadline {
        require(!isExecuted, "Swap already executed");
        require(!isCanceled, "Swap is canceled");

         IERC20(tokenA).safeTransferFrom(initiator, receiver, amountA);

         IERC20(tokenB).safeTransferFrom(receiver, initiator, amountB);


      

        isExecuted = true;
        emit SwapExecuted(initiator, receiver, amountA, amountB);

    }

    /// @notice Cancels the swap, only the initiator can perform this action
    function cancelSwap() external onlyInitiator {
        require(!isExecuted, "Swap already executed");
        require(!isCanceled, "Swap already canceled");

        isCanceled = true;
        emit SwapCanceled(initiator);

    }



}



