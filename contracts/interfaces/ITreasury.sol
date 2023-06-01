// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

interface ITreasury {
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed operator, address recipient, uint256 amount, string requestId);

    function isOperator(address) external view returns (bool);

    function token() external view returns (address);

    function addOperator(address operator) external;

    function removeOperator(address operator) external;

    function deposit(uint256 amount) external;

    function withdraw(address recipient, uint256 amount, string memory requestId) external;

    function batchWithdraw(address[] memory recipients, uint256[] memory amounts, string[] memory requestIds) external;
}