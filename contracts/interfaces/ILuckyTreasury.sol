//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.10;

interface ILuckyTreasury {
    function transferToken(
        address token,
        uint256 amount,
        address recipient
    ) external;

    function transferETH(uint256 amount, address recipient) external;
}
