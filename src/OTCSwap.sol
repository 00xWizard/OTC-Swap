// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract OTCSwap {
    using SafeERC20 for IERC20;

    struct Swap {
        address initiator;
        address receiver;
        address tokenA;
        address tokenB;
        uint256 amountA;
        uint256 amountB;
        uint256 deadline;
        bool isExecuted;
        bool isCanceled;
    }

    mapping(uint256 => Swap) public swaps;
    uint256 public swapCounter;

     modifier onlyReceiver(uint256 _swapId) {
        require(msg.sender == swaps[_swapId].receiver, "Only receiver can execute");
        _;
    }

    modifier onlyInitiator(uint256 _swapId) {
        require(msg.sender == swaps[_swapId].initiator, "Only initiator can cancel");
        _;
    }

    modifier beforeDeadline(uint256 _swapId) {
        require(block.timestamp <= swaps[_swapId].deadline, "Deadline has passed");
        _;
    }

    event SwapCreated(uint256 indexed swapId, address indexed initiator, address indexed receiver);
    event SwapExecuted(uint256 indexed swapId);
    event SwapCanceled(uint256 indexed swapId);


    /// @notice Create a new OTC swap between `msg.sender` and `_receiver`
    /// @param _receiver The address of the receiver participating in the swap
    /// @param _tokenA The address of the token being offered by the initiator
    /// @param _tokenB The address of the token being offered by the receiver
    /// @param _amountA The amount of token A being exchanged by the initiator
    /// @param _amountB The amount of token B being exchanged by the receiver
    /// @param _deadline The deadline timestamp by which the swap must be executed
    /// @return swapId The unique identifier of the created swap
    function createSwap(
        address _receiver,
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB,
        uint256 _deadline
    ) external returns (uint256 swapId) {
        swapId = swapCounter++;
        swaps[swapId] = Swap({
            initiator: msg.sender,
            receiver: _receiver,
            tokenA: _tokenA,
            tokenB: _tokenB,
            amountA: _amountA,
            amountB: _amountB,
            deadline: _deadline,
            isExecuted: false,
            isCanceled: false
        });

        emit SwapCreated(swapId, msg.sender, _receiver);
        return swapId;

    }

   
    /// @notice Execute the swap identified by `_swapId`
    /// @dev Transfers token A from the initiator to the receiver and token B from the receiver to the initiator
    /// @param _swapId The unique identifier of the swap to be executed
    function executeSwap(uint256 _swapId) external onlyReceiver(_swapId) beforeDeadline(_swapId) {
        Swap storage swap = swaps[_swapId];
        require(!swap.isExecuted, "Swap already executed");
        require(!swap.isCanceled, "Swap is canceled");

        IERC20(swap.tokenA).safeTransferFrom(swap.initiator, swap.receiver, swap.amountA);
        IERC20(swap.tokenB).safeTransferFrom(swap.receiver, swap.initiator, swap.amountB);

        swap.isExecuted = true;

        emit SwapExecuted(_swapId);
    }


    /// @notice Cancel the swap identified by `_swapId`
    /// @dev Only the initiator can cancel a swap before it is executed
    /// @param _swapId The unique identifier of the swap to be canceled
    function cancelSwap(uint256 _swapId) external onlyInitiator(_swapId) {
        Swap storage swap = swaps[_swapId];
        require(!swap.isExecuted, "Swap already executed");
        require(!swap.isCanceled, "Swap already canceled");

        swap.isCanceled = true;

        emit SwapCanceled(_swapId);
    }
}