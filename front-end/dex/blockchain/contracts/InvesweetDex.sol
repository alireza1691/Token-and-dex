// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "./IERC20.sol";


error Insufficient_Balance();


contract PairOfDex{

mapping (address => mapping(uint256 => uint256)) public orderOn1;
mapping (address => uint256) public orderOn2;
mapping (uint256 => mapping(uint256 => address)) public ordersInThi;

// mapping (uint256 => mapping(address =>uint256))

IERC20 public token1 ;
IERC20 public token2 ;

    constructor(address firstTokenAdress, address secondTokenAddress) {
        token1 = IERC20(firstTokenAdress);
        token2 = IERC20(secondTokenAddress);
    }

    struct user {
        uint256 balanceOfToken1;
        uint256 balanceOfToken2;
        address userAddress;
        bytes32[] orderHashes;
        
    }

    struct buy_order {
        uint256 orderAmount;
        address userAddres;
    }

    struct sell_order {
        uint256 orderAmount;
        address userAddres;
        bytes hashOfOrder;
    }

   
    buy_order[] buy_orders;
    sell_order[] sell_orders;

    mapping (address => bytes[]) userActiveOrders;

    mapping (uint256 => uint256) public buyInThisPrice;
    mapping (uint256 => uint256) public sellInThisPrice;
    mapping (uint256 => mapping (uint256 => buy_order[])) public buyOrdersInThisPrice;
    // mapping (uint256 => mapping (uint256 => sell_order[])) public sellOrdersInThisPrice;
    mapping (uint256 => sell_order[]) public sellOrdersInThisPrice;
    mapping (address => user) public userBalances;

    uint256 highestPriceBuyOrder;
    uint256 smallerPriceSellOrder;

   

    function decreaseOrderAmount() external {}

    function increaseOrderAmount() external {}

    function sellToken (uint256 amountIn, uint256 price) external {

        if ( amountIn >= userBalances[msg.sender].balanceOfToken1 ) {
            revert Insufficient_Balance();
        }

        userBalances[msg.sender].balanceOfToken1 -= amountIn;
        uint256 amountOut = amountIn / price;

        if (buyInThisPrice[price] > amountOut) {
            if (highestPriceBuyOrder > price) {
                orderExistCheaper();
            } else {
                buyOrderAlreadyExist(amountIn, price, msg.sender);
            }

        }
        if ( buyInThisPrice[price] < amountOut && buyInThisPrice[price] > 0) {      
        }
        else{
           orderNotExist(amountIn, price, msg.sender, false);
        }

    }
    function buyOrderAlreadyExist( uint256 amountIn, uint256 price, address orderBelongTo) public {
       uint256 amountOut = amountIn / price;
        // for (uint i = 0; i < sell_orders.length; i++) {
            for (uint i = 0; i < sellOrdersInThisPrice[price][i].orderAmount; i++) {
            buy_order memory order = buy_orders[i];
            uint256 thisOrderAmount = order.orderAmount;
            uint256 filledAmount;
            if ( thisOrderAmount > amountOut - filledAmount ) {
                order.orderAmount = (thisOrderAmount - (amountOut - filledAmount));
                address addressOfPeer = order.userAddres;
                // userBalances[addressOfPeer].balanceOfToken2 -= amount;
                userBalances[orderBelongTo].balanceOfToken2 += amountOut - filledAmount ;
                buyInThisPrice[price] -= amountOut - filledAmount ;
                break;
            } else {
                uint256 amountOfThisOrder = order.orderAmount ;
                userBalances[orderBelongTo].balanceOfToken2 += amountOfThisOrder;
                buyInThisPrice[price] -= amountOfThisOrder;
                filledAmount += amountOfThisOrder;
                buy_orders[i] = buy_orders[buy_orders.length - 1];
                buy_orders.pop();
            }

        }
    }
    function orderExistCheaper() public {}
    function partOfOrderAvailable() public {}
    function orderNotExist( uint256 amountIn, uint256 price, address orderBelongTo ,bool isBuy) public {

        if (isBuy == true) {
            
        } else {
            sellInThisPrice[price] += amountIn;
            
            bytes memory details = hash(false , amountIn, price);
            userActiveOrders[orderBelongTo].push(details);  
            sell_orders.push(sell_order(amountIn, orderBelongTo, details));
        }
       
    }



    function cancelOrder (uint256 index) external {

        sell_order memory order = sell_orders[index];
        bytes[] storage orders = userActiveOrders[msg.sender];
        (bool isBuy,uint256 amount,uint256 price) = deHash(orders[index]);
        if (isBuy == true) {
            
        } else {
        userBalances[msg.sender].balanceOfToken2 += amount;
        sellInThisPrice[price] -= amount;
        for (uint i = 0; i < sell_orders.length; i++) {
            bytes memory thisIndexHash = order.hashOfOrder;
            bytes memory hashOfOrder = orders[index];
            // if (thisIndexHash == hashOfOrder ) {
                
            // } 
        }
        }
        orders[index] = orders[orders.length - 1];
        orders.pop();
        // define some hash in struct which help us to find order and delete the order in array of orders which belongs to sell orders

     
    }

    function buyToken(uint256 amountIn, uint256 price) public {

        if(amountIn>= userBalances[msg.sender].balanceOfToken1){
            revert Insufficient_Balance();
        }

        // bool isToken1 = tokenIn ==  token1;
        // (IERC20 tokenIn, IERC20 tokenOut) = isToken1 ? (token1, token2) : (token1, token2) ;

        uint256 amountOut = amountIn / price;
        userBalances[msg.sender].balanceOfToken1 -= amountIn;

            if (sellInThisPrice[price] > amountOut) {
                _buyTokenMatch( amountOut, msg.sender, price);

            } else {
            buyInThisPrice[price] += amountIn;
            buy_orders.push(buy_order(amountIn,msg.sender));
            // bytes32 details = hash("buy2", amountIn, price, );
            // userBalances[msg.sender].orderHashes.push(details);
            }
        
      
    }

        

    

    function _buyTokenMatch(uint256 amountIn ,address to, uint256 price) internal {
       
       uint256 amountOut = amountIn / price;
        for (uint i = 0; i < sell_orders.length; i++) {
            sell_order memory order = sell_orders[i];
            uint256 thisOrderAmount = order.orderAmount;
            uint256 filledAmount;
            if ( thisOrderAmount > amountOut - filledAmount ) {
                order.orderAmount = (thisOrderAmount - (amountOut - filledAmount));
                address addressOfPeer = order.userAddres;
                // userBalances[addressOfPeer].balanceOfToken2 -= amount;
                userBalances[to].balanceOfToken2 += amountOut - filledAmount ;
                sellInThisPrice[price] -= amountOut - filledAmount ;
                break;
            } else {
                uint256 amountOfThisOrder = order.orderAmount ;
                userBalances[to].balanceOfToken2 += amountOfThisOrder;
                sellInThisPrice[price] -= amountOfThisOrder;
                filledAmount += amountOfThisOrder;
                sell_orders[i] = sell_orders[sell_orders.length - 1];
                sell_orders.pop();
            }

        }

        

                

    }

    function _sellTokenMatch(uint256 amountIn ,address to, uint256 price) internal {
       
       uint256 amountOut = amountIn / price;
        for (uint i = 0; i < sell_orders.length; i++) {
            buy_order memory order = buy_orders[i];
            uint256 thisOrderAmount = order.orderAmount;
            uint256 filledAmount;
            if ( thisOrderAmount > amountOut - filledAmount ) {
                order.orderAmount = (thisOrderAmount - (amountOut - filledAmount));
                address addressOfPeer = order.userAddres;
                // userBalances[addressOfPeer].balanceOfToken2 -= amount;
                userBalances[to].balanceOfToken2 += amountOut - filledAmount ;
                buyInThisPrice[price] -= amountOut - filledAmount ;
                break;
            } else {
                uint256 amountOfThisOrder = order.orderAmount ;
                userBalances[to].balanceOfToken2 += amountOfThisOrder;
                buyInThisPrice[price] -= amountOfThisOrder;
                filledAmount += amountOfThisOrder;
                buy_orders[i] = buy_orders[buy_orders.length - 1];
                buy_orders.pop();
            }

        }

        

                

    }

     function depositToken1 (uint256 amount) external {
        token1.transferFrom(
        msg.sender,
        address(this),
        amount
        );
        userBalances[msg.sender].balanceOfToken1 += amount;
    }

    function withdrawToken1 (uint256 amount) external {
        if (userBalances[msg.sender].balanceOfToken1 < amount) {
            revert Insufficient_Balance();
        }
        token1.transfer(
        msg.sender,
        amount
        );
        userBalances[msg.sender].balanceOfToken1 += amount; 
    }

    function hash(
        bool  _isBuy,
        uint256 _amount,
        uint256 _price
    ) public pure returns (bytes memory) {
        // return keccak256(abi.encodePacked(_isBuy, _amount, _price));
        return abi.encode(_isBuy, _amount, _price);
    }

    function deHash(bytes memory hashedDetails) public pure returns(bool isBuy,uint256 amount,uint256 price) {
        (isBuy, amount, price) = abi.decode(hashedDetails,(bool, uint256, uint256));
    }

    function _amountOut( uint256 amountIn, uint256 price) pure public  returns(uint256 amountOut){
        return (amountIn / price);
    }

}