// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./ITreasury.sol";

interface IMainTreasury is ITreasury {
    event VerifierSet(address verifier);
    event ZKPUpdated(uint64 zkpId, uint256 balanceRoot, uint256 withdrawRoot, uint256 totalBalance, uint256 totalWithdraw);
    event GeneralWithdrawn(address indexed account, address indexed to, uint64 zkpId, uint256 index, uint256 amount);
    event ForceWithdrawn(address indexed account, uint64 zkpId, uint256 index, uint256 amount);

    function verifier() external view returns (address);
    function zkpId() external view returns (uint64);
    // total balance merkle tree root, use for forceWithdraw
    function balanceRoot() external view returns (uint256);
    // total withdraw merkle tree root, use for generalWithdraw
    function withdrawRoot() external view returns (uint256);
    function totalBalance() external view returns (uint256);
    function totalWithdraw() external view returns (uint256);
    function withdrawn() external view returns (uint256);
    function lastUpdateTime() external view returns (uint256);
    function forceTimeWindow() external view returns (uint256);
    function withdrawFinished() external view returns (bool);
    function forceWithdrawOpened() external view returns (bool);

    function setVerifier(address verifier_) external;

    function updateZKP(
        uint64 newZkpId,
        uint256 newBalanceRoot, 
        uint256 newWithdrawRoot, 
        uint256 newTotalBalance, 
        uint256 newTotalWithdraw
    ) external;

    function generalWithdraw(
        uint256[] calldata proof,
        uint256 index,
        uint256 withdrawId,
        uint256 accountId,
        address account,
        address to,
        uint8 withdrawType,
        uint256 amount
    ) external;

    function forceWithdraw(
        uint256[] calldata proof,
        uint256 index,
        uint256 accountId,
        uint256 equity
    ) external;
}