// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Synthara {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    uint256 public constant COLLATERAL_RATIO = 150; // 150% collateralization

    event Minted(address indexed user, uint256 amount);
    event Burned(address indexed user, uint256 amount);

    // Core Function 1: Mint synthetic tokens by providing collateral (in wei)
    function mint() external payable {
        require(msg.value > 0, "Collateral required");
        uint256 synthAmount = (msg.value * 100) / COLLATERAL_RATIO;
        _balances[msg.sender] += synthAmount;
        _totalSupply += synthAmount;
        emit Minted(msg.sender, synthAmount);
    }

    // Core Function 2: Burn synthetic tokens and reclaim collateral
    function burn(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        uint256 collateralToReturn = (amount * COLLATERAL_RATIO) / 100;
        payable(msg.sender).transfer(collateralToReturn);
        emit Burned(msg.sender, amount);
    }

    // Core Function 3: Get balance of synthetic tokens for an address
    function getBalance(address account) external view returns (uint256) {
        return _balances[account];
    }
}
