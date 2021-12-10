//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/ILuckyTreasury.sol";

contract LuckyTreasury is Ownable, ILuckyTreasury {
    using SafeERC20 for IERC20;

    event WhitelistGame(address indexed game);
    event DewhitelistGame(address indexed game);

    mapping(address => bool) public whitelistedGames;

    modifier onlyGame() {
        require(whitelistedGames[_msgSender()], "not whitelisted!");
        _;
    }

    function transferToken(
        address token,
        uint256 amount,
        address recipient
    ) external override onlyGame {
        require(recipient != address(0), "zero recipient!");
        IERC20(token).safeTransfer(recipient, amount);
    }

    function transferETH(uint256 amount, address recipient)
        external
        override
        onlyGame
    {
        require(recipient != address(0), "zero recipient!");
        payable(recipient).transfer(amount);
    }

    function whitelistGame(address game) external onlyOwner {
        require(game != address(0), "zero addr!");
        require(!whitelistedGames[game], "whitelisted!");
        whitelistedGames[game] = true;

        emit WhitelistGame(game);
    }

    function dewhitelistGame(address game) external onlyOwner {
        require(whitelistedGames[game], "not whitelisted!");
        whitelistedGames[game] = false;

        emit DewhitelistGame(game);
    }
}
