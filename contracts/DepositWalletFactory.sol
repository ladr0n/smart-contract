// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./interfaces/IDepositWalletFactory.sol";
import "./DepositWallet.sol";

contract DepositWalletFactory is IDepositWalletFactory {
    address public treasury;
    mapping(bytes32 => address) public getWallet;

    constructor(address treasury_) {
        treasury = treasury_;
    }

    function predicteWallet(bytes32 salt) external view returns (address wallet) {
        wallet = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(type(DepositWallet).creationCode)
        )))));
    }

    // salt like 0x68656c6c6f000000000000000000000000000000000000000000000000000000
    function createWallet(bytes32 salt, address account) external override returns (address wallet) {
        require(getWallet[salt] == address(0), "used salt");
        wallet = address(new DepositWallet{salt: salt}());
        DepositWallet(payable(wallet)).initialize(account, treasury);
        getWallet[salt] = wallet;
        emit WalletCreated(salt, account, wallet);
    }

    function batchCreateWallets(bytes32[] memory salts, address[] memory accounts) external override returns (address[] memory wallets) {
        require(salts.length == accounts.length, "length not the same");
        wallets = new address[](salts.length);
        for (uint256 i = 0; i < salts.length; i++) {
            require(getWallet[salts[i]] == address(0), "used salt");
            wallets[i] = address(new DepositWallet{salt: salts[i]}());
            DepositWallet(payable(wallets[i])).initialize(accounts[i], treasury);
            getWallet[salts[i]] = wallets[i];
        }
        emit BatchWalletsCreated(salts, accounts, wallets);
    }

    function batchCollectTokens(address[] memory wallets, address[] memory tokens, string[] memory requestIds) external override {
        for (uint256 i = 0; i < wallets.length; i++) {
            DepositWallet wallet = DepositWallet(payable(wallets[i]));
            wallet.collectTokens(tokens, requestIds);
        }
    }

    function batchCollectETH(address[] memory wallets, string[] memory requestIds) external override {
        require(wallets.length == requestIds.length, "length not the same");
        for (uint256 i = 0; i < wallets.length; i++) {
            DepositWallet wallet = DepositWallet(payable(wallets[i]));
            wallet.collectETH(requestIds[i]);
        }
    }
}