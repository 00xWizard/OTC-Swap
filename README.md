# OTCSwap

**OTCSwap** is a Solidity-based smart contract that enables atomic swaps between two tokens on the Ethereum blockchain. This project is designed to enable swapping assets between two parties with a predefined amounts and authorized execution.

## Features

- **Atomic Swap:** Ensures that both token transfers are successful.
- **Authorized Execution:** Only a specified Ethereum `address` can execute the swap.
- **Predefined Amounts:** Swap amounts are defined by the `initiator` of the swap.
- **Deadline:** The swap must be executed before a specified `deadline`.

## Smart Contract Overview

The `OTCSwap` contract allows users to create and execute atomic swaps with the following features:

- **Token A Address:** Address of the first ERC-20 token.
- **Token B Address:** Address of the second ERC-20 token.
- **Receiver:** The only address authorized to execute the swap.
- **Amount A:** Amount of Token A to be swapped.
- **Amount B:** Amount of Token B to be swapped.
- **Initiator:** Address that creates the swap and defines the amounts.
- **Deadline:** The timestamp by which the swap must be executed.

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

After deploying the contract, you can use a library like ethers.js to interact with the contract's functionalities like `executeSwap` or `cancelSwap`

## Testing
The project includes basic foundry testing for the main functions of the contract.