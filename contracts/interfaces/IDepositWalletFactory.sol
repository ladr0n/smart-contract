// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

interface IDepositWalletFactory {
    event WalletCreated(bytes32 indexed salt, address indexed account, address indexed wallet);
    event BatchWalletsCreated(bytes32[] salts, address[] accounts, address[] wallets);

    function treasury() external returns (address);

    function getWallet(bytes32 salt) external returns (address);

    function createWallet(bytes32 salt, address account) external returns (address wallet);

    function batchCreateWallets(bytes32[] memory salts, address[] memory accounts) external returns (address[] memory wallets);

    function batchCollectTokens(address[] memory wallets, address[] memory tokens, string[] memory requestIds) external;

    function batchCollectETH(address[] memory wallets, string[] memory requestIds) external;
}