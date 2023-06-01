// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./BaseTreasury.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract HotTreasury is BaseTreasury, Initializable {
    function initialize(address token_) external initializer {
        owner = msg.sender; 
        token = token_;
    }
}