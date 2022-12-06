// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


interface Idex {
    
    function _swap (IERC20 _tokenAddress, uint _amount) external returns(uint );

    function _addLiquidity (uint _amountUSDCToken, uint _amountMYToken) external returns (uint shares);

    function _removeLiquidity(uint _shares)external returns (uint amountUSDC, uint amountMYToken);

    function _getTokenAddress()external view returns (address);
    function _getUSDCAddress()external view returns (address);
}
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}



contract Arbitrage {

    uint immutable usdcDecimal = 6;
    uint immutable myTokenDecimal = 18;
    uint immutable difDecimals = 12;

    IERC20 public MToken;
    IERC20 public UToken;
    uint public _myTokenPrice;
    uint public _range;
    address _dexAddress;

    constructor (uint price, address usdcA, address tokenA, address dexA) {
        _myTokenPrice = price;
        _dexAddress = dexA;
        IERC20  UToken = IERC20(usdcA);
        IERC20  MToken = IERC20(tokenA);
    }

    function setPriceAndRange (uint newPrice, uint range) external {
        _myTokenPrice = newPrice;
        _range = range;
    }
    
    function start() external {
        uint duration = block.timestamp + 6 weeks;
        
        for (uint i = block.timestamp ; i < duration; checkBalance()) {
           
        }
    }

    function checkBalance() public returns(uint balanceU, uint balanceM){
        
        uint UB = UToken.balanceOf(address(_dexAddress));
        uint MB = MToken.balanceOf(address(_dexAddress));
        if (MB / (UB * 10 ** 16) > (_myTokenPrice * 101) ) {

            uint amount = calculateHowMuch();
            buy(amount);
        }
        if (MB / (UB * difDecimals) < _myTokenPrice  * 99) {
            uint amount = calculateHowMuch();
            sell(amount);
        }
        return(UB, MB);
    }

    // **** keep going with here: ******

    function calculateHowMuch() public returns(uint) {

        return (2);   
    }


    function buy (uint amount) internal {
        Idex(_dexAddress)._swap(UToken, amount);
    }

    function sell (uint amount) internal {
        Idex(_dexAddress)._swap(MToken , amount);
    }

}

