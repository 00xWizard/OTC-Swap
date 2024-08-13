//SPDX-License-Identifier: MIT 

    pragma solidity 0.8.23;

    import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

    contract MockERC20 is IERC20 {

        string public name;
        string public symbol;
        uint8 public decimals;
        uint256 public totalSupply;

        mapping(address => uint256) public balanceOf;
        mapping(address => mapping(address => uint256)) public allowance;


        constructor(string memory _name, string memory _symbol, uint8 _decimals){
            name = _name;
            symbol = _symbol;
            decimals = _decimals;
        }
        function mint(address to, uint256 amount) public {
            balanceOf[to] += amount;
            totalSupply += amount;
        }
        
        function transfer(address to, uint256 amount) public returns (bool) {
            require(balanceOf[msg.sender] >= amount, "Insuficient balance");
            balanceOf[msg.sender] -= amount;
            emit Transfer(msg.sender, to, amount);
            return true;
        }

        function approve(address spender, uint256 amount) public returns (bool){
            allowance[msg.sender][spender] = amount;
            emit Approval(msg.sender, spender, amount);
            return true;
        }

        function transferFrom(address from, address to, uint256 amount) public returns (bool) {
            require(balanceOf[from] >= amount, "Insufficient balance");
            require(allowance[from][msg.sender] >= amount, "Allowance is exceeded");
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
            allowance[from][msg.sender] -= amount;
            emit Transfer(from, to, amount);
            return true;
        }

    














}
