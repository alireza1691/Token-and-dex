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

    struct user {
        uint256 balanceOfToken1;
        uint256 balanceOfToken2;
        address userAddress;
    }

    struct buy1_order {
        uint256 orderAmount;
        address userAddres;
    }
    struct buy2_order {
        uint256 orderAmount;
        address userAddres;
    }
    struct sell1_order {
        uint256 orderAmount;
        address userAddres;
    }
    struct sell2_order {
        uint256 orderAmount;
        address userAddres;
    }

    buy1_order[] buy1_orders;
    buy2_order[] buy2_orders;
    sell1_order[] sell1_orders;
    sell2_order[] sell2_orders;
    mapping (uint256 => uint256) public buy1InThisPrice;
    mapping (uint256 => uint256) public buy2InThisPrice;
    mapping (uint256 => uint256) public sell1InThisPrice;
    mapping (uint256 => uint256) public sell2InThisPrice;
    mapping (uint256 => buy1_order) public getAmountFrom;
    mapping (address => user) public userBalances;

    function deposit () external {}

    function withdraw () external {}

    function decreaseOrderAmount() external {}

    function increaseOrderAmount() external {}

    function sellToken1 (uint256 amountIn, uint256 price) external {

        userBalances[msg.sender].balanceOfToken1 -= amountIn;
        uint256 amountOut = amountIn / price;

            if (buy2InThisPrice[price] > amountOut) {
                _sellToken1Match(amountOut, msg.sender, price);

            } else {
            sell1InThisPrice[price] += amountIn;
            sell1_orders.push(sell1_order(amountIn,msg.sender));
            }

    }

    function cancelOrder () external {}
    function buyToken2(uint256 amountIn, uint256 price) public {

        // bool isToken1 = tokenIn ==  token1;
        // (IERC20 tokenIn, IERC20 tokenOut) = isToken1 ? (token1, token2) : (token1, token2) ;

        uint256 amountOut = amountIn / price;
        userBalances[msg.sender].balanceOfToken1 -= amountIn;

            if (sell2InThisPrice[price] > amountOut) {
                _buyToken2Match( amountOut, msg.sender, price);

            } else {
            buy2InThisPrice[price] += amountIn;
            buy2_orders.push(buy2_order(amountIn,msg.sender));
            }
      
    }

        

    

    function _buyToken2Match(uint256 amountIn ,address to, uint256 price) internal {
       
       uint256 amountOut = amountIn / price;
        for (uint i = 0; i < sell2_orders.length; i++) {
            sell2_order memory order = sell2_orders[i];
            uint256 thisOrderAmount = order.orderAmount;
            uint256 filledAmount;
            if ( thisOrderAmount > amountOut - filledAmount ) {
                order.orderAmount = (thisOrderAmount - (amountOut - filledAmount));
                address addressOfPeer = order.userAddres;
                // userBalances[addressOfPeer].balanceOfToken2 -= amount;
                userBalances[to].balanceOfToken2 += amountOut - filledAmount ;
                sell2InThisPrice[price] -= amountOut - filledAmount ;
                break;
            } else {
                uint256 amountOfThisOrder = order.orderAmount ;
                userBalances[to].balanceOfToken2 += amountOfThisOrder;
                sell2InThisPrice[price] -= amountOfThisOrder;
                filledAmount += amountOfThisOrder;
                sell2_orders[i] = sell2_orders[sell2_orders.length - 1];
                sell2_orders.pop();
            }

        }

        

                

    }

    function _sellToken1Match(uint256 amountIn ,address to, uint256 price) internal {
       
       uint256 amountOut = amountIn / price;
        for (uint i = 0; i < sell2_orders.length; i++) {
            buy1_order memory order = buy1_orders[i];
            uint256 thisOrderAmount = order.orderAmount;
            uint256 filledAmount;
            if ( thisOrderAmount > amountOut - filledAmount ) {
                order.orderAmount = (thisOrderAmount - (amountOut - filledAmount));
                address addressOfPeer = order.userAddres;
                // userBalances[addressOfPeer].balanceOfToken2 -= amount;
                userBalances[to].balanceOfToken2 += amountOut - filledAmount ;
                buy1InThisPrice[price] -= amountOut - filledAmount ;
                break;
            } else {
                uint256 amountOfThisOrder = order.orderAmount ;
                userBalances[to].balanceOfToken2 += amountOfThisOrder;
                buy1InThisPrice[price] -= amountOfThisOrder;
                filledAmount += amountOfThisOrder;
                buy1_orders[i] = buy1_orders[buy1_orders.length - 1];
                buy1_orders.pop();
            }

        }

        

                

    }

    function matchOrder () internal {

    }

}