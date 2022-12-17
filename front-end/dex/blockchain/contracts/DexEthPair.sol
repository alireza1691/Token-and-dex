// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
pragma abicoder v2;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
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

contract StableDex {

    AggregatorV3Interface internal ethPriceFeed;

    address public myToken;
    IERC20 public PairToken;

    uint public reservePairToken;
    uint public reserveEth;


    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    constructor(address _token, address ethPriceFeedAddress) {
        PairToken = IERC20 (_token);
        myToken = _token;
        ethPriceFeed = AggregatorV3Interface(ethPriceFeedAddress);
    }

    // ETH/USDC goerli feed price address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e


    function _getTokenAddress() external view returns (address) {
        return (myToken);
    }

    function _mintShares (address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burnShares (address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }
   
    

    function _swapEthToIst () external payable returns(uint _amountOut) {
        // require(_tokenIn == 0 || _tokenIn == MYToken, "Invalid Token");
        require(msg.value > 0 , "Amount zero");

        
        // Pull in token in
        uint reserveIn = reserveEth;
        uint reserveOut = reservePairToken;
        // Calculate token out
        // ydx / (x + dx) = dy
        uint _amountInWithFee = (msg.value * 995) / 1000;
        
        // uint256 ethPrice = getEthPrice();
        _amountOut = (reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);
        // _amountOut =(_amountInWithFee * ethPrice * price / (10 ** 18));

        // Transfer token out to msg.sender
        PairToken.transfer(msg.sender, _amountOut);

        // // Update Reserves
        _updateReserves(reserveEth + msg.value , PairToken.balanceOf(address(this)));

        // if (reserveMYToken / (reserveUSDC * 10 ** 12) > 2) {
            
        // }
        return(_amountOut);

    }

    function _swapIstToEth (uint _amountIn) external payable returns(uint _amountOut) {
        // require(_tokenIn == 0 || _tokenIn == MYToken, "Invalid Token");

        require(PairToken.balanceOf(msg.sender) > _amountIn, "Insufficient balance");
        // Pull in token in
        uint reserveOut = reserveEth;
        uint reserveIn = reservePairToken;
        PairToken.transferFrom(msg.sender, address(this), _amountIn);(msg.sender, _amountOut);

        // Calculate token out
        // ydx / (x + dx) = dy
        
        uint _amountInWithFee = (_amountIn * 995) / 1000;
        
        // uint256 ethPrice = getEthPrice();
        _amountOut = (reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);

        // Transfer token out to msg.sender
        
        payable(msg.sender).transfer(_amountOut);

        // Update Reserves
        _updateReserves(reserveEth - _amountOut, PairToken.balanceOf(address(this)));
        
        // if (reserveMYToken / (reserveUSDC * 10 ** 12) > 2) {
            
        // }
        return(_amountOut);

    }
    function getPrice(uint amountEth) external view returns (uint){
        uint256 ethPrice = getEthPrice();
        uint _amountOut =((amountEth * ethPrice ) / (10 ** 18));
        return (_amountOut);
    }
    function getEthPrice()public view returns (uint256) {
        (
            ,
            /*uint80 roundID*/ int price /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/,
            ,
            ,

        ) = ethPriceFeed.latestRoundData();
        return uint256(price * 10000000000);
    }
    

    function _updateReserves (uint _reserveEth, uint _reserveMYToken) private {
        reserveEth = _reserveEth;
        reservePairToken = _reserveMYToken;
    }

    function _addLiquidity (uint _amountPairToken) external payable returns (uint shares){
        // Pull in USDC & MYToken
        require(msg.value > 0," msg.value = 0" );
        PairToken.transferFrom(msg.sender, address(this), (_amountPairToken));
        uint _amountEth = msg.value;
        // DY / DX = Y / X
        if (reserveEth > 0 || reservePairToken > 0) {
            require(reserveEth * _amountPairToken == reservePairToken * _amountEth, "This amounts will change the price");
        }

        // Mint shares
        // f(x, y) = value of liquidity = sqrt(xy)
        // s = dx / x * T = dy / y * T 
        if (totalSupply == 0) {
            shares = _sqrt(_amountEth *  _amountPairToken);
        } else {
            shares = _min((_amountEth * totalSupply) / reserveEth, (_amountPairToken * totalSupply) / reservePairToken);
            require(shares > 0, "shares = 0");
        }
        _mintShares(msg.sender, shares);

        // Update reserves
        _updateReserves(reserveEth + msg.value, PairToken.balanceOf(address(this)));
    }

    function _removeLiquidity(uint _shares)external payable returns (uint amountETH, uint amountPairToken) {
        // Calculate amounts with shares:
        // dx = (s * x) / T
        // dy = (s * y) / T
        uint balETH = reserveEth;
        uint balPairToken = PairToken.balanceOf(address(this));

        amountETH = (_shares * balETH ) / totalSupply;
        amountPairToken = (_shares * balPairToken ) / totalSupply;

        require(amountETH > 0 && amountPairToken > 0, "One the amounts = 0");

        // Burn the shares
        _burnShares(msg.sender, _shares);

        // Update reserves 
        _updateReserves(balETH - amountETH, balPairToken - amountPairToken);

        // Transfer tokens to msg.sender
        payable(msg.sender).transfer(amountETH);
        PairToken.transfer(msg.sender, amountPairToken);

    }

    function _sqrt (uint y) private pure returns (uint z) {

        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min (uint x, uint y) private pure returns(uint) {
        return x<= y ? x : y;
    }

    receive() external payable {}
   
}