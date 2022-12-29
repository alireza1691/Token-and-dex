// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "./IERC20.sol";


contract PairOfDex{

mapping (address => mapping(uint256 => uint256)) public orderOn1;
mapping (address => uint256) public orderOn2;

IERC20 public token1 ;
IERC20 public token2 ;

    constructor(address firstTokenAdress, address secondTokenAddress) {
        token1 = IERC20(firstTokenAdress);
        token1 = IERC20(secondTokenAddress);
    }

    function orderBuy (IERC20 tokenIn, uint256 amount, uint256 price) external{

        bool isToken1 = tokenIn ==  token1;
        (IERC20 tokenIn, IERC20 tokenOut) = isToken1 ? (token1, token2) : (token1, token2) ;

        tokenIn.approve(address(this),amount);
        orderOn1[msg.sender][price] = amount;
    }

}