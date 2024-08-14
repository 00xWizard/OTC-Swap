# OTCSwap

**OTCSwap** is a Solidity-based smart contract that enables atomic swaps between two tokens on the Ethereum blockchain. This project is designed to facilitate swapping assets between two parties with predefined amounts and authorized execution. It includes a deadline feature to ensure timely execution.

## Features

- **Atomic Swap:** Ensures that both token transfers occur simultaneously, preventing partial execution.
- **Authorized Execution:** Only the specified `receiver` can execute the swap.
- **Predefined Amounts:** The swap amounts are defined by the `initiator` when creating the swap.
- **Deadline:** The swap must be executed before a specified `deadline`, or it can be canceled by the initiator.

## Smart Contract Overview

The `OTCSwap` contract allows users to create and execute atomic swaps with the following features:

- **Token A Address:** The ERC-20 token offered by the initiator.
- **Token B Address:** The ERC-20 token offered by the receiver.
- **Receiver:** The only address authorized to execute the swap.
- **Amount A:** Amount of Token A that the initiator will transfer to the receiver.
- **Amount B:** Amount of Token B that the receiver will transfer to the initiator.
- **Initiator:** The address that creates the swap and defines the swap parameters.
- **Deadline:** The timestamp by which the swap must be executed. If the deadline passes, the swap can no longer be executed.


## Getting Started


### Prerequisites

- **Foundry:** You need Foundry installed for compiling, testing, and deploying the smart contracts. You can install Foundry by following the instructions [here](https://book.getfoundry.sh/getting-started/installation.html).

### Installation

1. **Clone the repository:**

```
git clone https://github.com/your-username/OTCSwap.git

cd OTCSwap
```


2. **Install dependencies:**

 ```
forge install
```


3. **Compile the contracts:**
```
forge build
```

4. **Run Tests:**
```
forge test
```
5. **Deploy the contract Locally:**

pass your anvil addresses to the constructor for local deployment

```
forge script script/deployOTCSwap.s.sol --rpc-url <anvil_rpc_url> --broadcast
```

## Usage

After deploying the contract, you can use a library like ethers.js to interact with the contract's functionalities such as `createSwap`, `executeSwap`, and `cancelSwap`. Example usage includes:

Creating a Swap: Call `createSwap` with the receiver address, token addresses, token amounts, and deadline.

Executing a Swap: The `receiver` can call executeSwap to complete the token transfer.

Canceling a Swap: The `initiator` can cancel the swap before it's executed.

## Testing
The project includes basic foundry testing for the main functions of the contract.