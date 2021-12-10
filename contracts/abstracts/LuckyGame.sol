//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract LuckyGame is Ownable {
    event WhitelistToken(address indexed token);
    event DewhitelistToken(address indexed token);
    event UpdateTreasury(address indexed treasury);

    address public treasury;
    mapping(address => bool) public whitelistedTokens;

    modifier onlyWhitelistedToken(address token) {
        require(whitelistedTokens[token], "not whitelisted token!");
        _;
    }

    constructor(address treasury_) {
        setTreasury(treasury_);
    }

    function setTreasury(address treasury_) public onlyOwner {
        require(treasury_ != address(0), "zero treasury!");
        treasury = treasury_;

        emit UpdateTreasury(treasury_);
    }

    function whitelistToken(address token) external onlyOwner {
        require(token != address(0), "zero addr!");
        require(!whitelistedTokens[token], "whitelisted!");
        whitelistedTokens[token] = true;

        emit WhitelistToken(token);
    }

    function dewhitelistToken(address token) external onlyOwner {
        require(whitelistedTokens[token], "not whitelisted!");
        whitelistedTokens[token] = false;

        emit DewhitelistToken(token);
    }
}
