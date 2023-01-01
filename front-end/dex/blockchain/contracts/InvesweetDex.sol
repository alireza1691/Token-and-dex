// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "./IERC20.sol";


contract PairOfDex{

mapping (address => mapping(uint256 => uint256)) public orderOn1;
mapping (address => uint256) public orderOn2;
mapping (uint256 => mapping(uint256 => address)) public ordersInThi;

// mapping (uint256 => mapping(address =>uint256))

IERC20 public token1 ;
IERC20 public token2 ;

    constructor(address firstTokenAdress, address secondTokenAddress) {
        token1 = IERC20(firstTokenAdress);
        token1 = IERC20(secondTokenAddress);
    }

    struct inThisPrice {
        mapping (uint256 => address) amountToAddress;
        uint256 Amount;
        address userAddres;
        uint256[] orderAmounts;
        mapping (uint256 => address) orderToUser;
    }
    inThisPrice[] inEachPrice;
    mapping (uint256 => uint256) public orderInThisPrice;
    mapping (uint256 => inThisPrice) public getAmountFrom;

    function orderBuy (IERC20 tokenIn, uint256 amount, uint256 price) external{

        bool isToken1 = tokenIn ==  token1;
        (IERC20 tokenIn, IERC20 tokenOut) = isToken1 ? (token1, token2) : (token1, token2) ;

        address sender;

        tokenIn.approve(address(this),amount);
        orderOn1[msg.sender][price] = amount;
        if (orderInThisPrice[price] > amount) {
                if (getAmountFrom[price].orderAmounts[0] > amount) {

                    uint256 indexAmount = getAmountFrom[price].orderAmounts[0];

                    sender = getAmountFrom[price].orderToUser[indexAmount];
                    tokenOut.transferFrom(sender,msg.sender,amount);
                } else {
                    for (uint i = 0; i < getAmountFrom[price].orderAmounts.length; i++) {

                        }
                }
            
            // tokenOut.transferFrom()
        }
    }

    uint256 [] arr;
    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function matchOrder () internal {

    }

}