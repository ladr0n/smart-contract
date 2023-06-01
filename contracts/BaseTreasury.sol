// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./interfaces/IERC20.sol";
import "./interfaces/ITreasury.sol";
import "./libraries/TransferHelper.sol";
import "./Ownable.sol";

abstract contract BaseTreasury is ITreasury, Ownable {
    address public token;
    mapping(address => bool) public isOperator;

    modifier onlyOperator() {
        require(isOperator[msg.sender], "only operator");
        _;
    }

    function addOperator(address operator) external override onlyOwner {
        require(!isOperator[operator], "already added");
        isOperator[operator] = true;
        emit OperatorAdded(operator);
    }

    function removeOperator(address operator) external override onlyOwner {
        require(isOperator[operator], "operator not found");
        isOperator[operator] = false;
        emit OperatorRemoved(operator);
    }

    function deposit(uint256 amount) external override {
        require(amount > 0, "deposit amount is zero");
        TransferHelper.safeTransferFrom(token, msg.sender, address(this), amount);
        emit Deposited(msg.sender, amount);
    }

    function withdraw(address recipient, uint256 amount, string memory requestId) external override onlyOperator {
        _withdraw(recipient, amount, requestId);
    }

    function batchWithdraw(
        address[] memory recipients,
        uint256[] memory amounts,
        string[] memory requestIds
    ) external override onlyOperator {
        require(recipients.length == amounts.length && recipients.length == requestIds.length, "length not the same");
        for (uint256 i = 0; i < recipients.length; i++) {
            _withdraw(recipients[i], amounts[i], requestIds[i]);
        }
    }

    function _withdraw(address recipient, uint256 amount, string memory requestId) internal {
        require(recipient != address(0), "recipient is zero address");
        require(amount > 0, "zero amount");
        require(IERC20(token).balanceOf(address(this)) >= amount, "balance not enough");
        TransferHelper.safeTransfer(token, recipient, amount);
        emit Withdrawn(msg.sender, recipient, amount, requestId);
    }
}