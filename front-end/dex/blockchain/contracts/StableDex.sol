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

    address public USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    address public myToken;
    IERC20 public USDCToken = IERC20(USDC);
    IERC20 public MYToken;

    uint public reserveUSDC;
    uint public reserveMYToken;

    uint public price;

    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    constructor(address _token, uint _price, address ethPriceFeedAddress) {
        MYToken = IERC20 (_token);
        myToken = _token;
        price = _price;
        ethPriceFeed = AggregatorV3Interface(ethPriceFeedAddress);
    }

    // ETH/USDC goerli feed price address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e

    function _changePrice(uint _newPrice) external {
        price = _newPrice;
    }

    function _getTokenAddress() external view returns (address) {
        return (USDC);
    }
    function _getUSDCAddress() external view returns (address){
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
    function _swap (IERC20 _tokenIn, uint _amountIn) external returns(uint _amountOut) {
        require(_tokenIn == USDCToken || _tokenIn == MYToken, "Invalid Token");
        require(_amountIn > 0 , "Amount zero");


        // Pull in token in
        bool isUsdc = _tokenIn ==  USDCToken;
        (IERC20 tokenIn, IERC20 tokenOut , uint reserveIn, uint reserveOut) = isUsdc ? (USDCToken, MYToken, reserveUSDC, reserveMYToken) : (MYToken, USDCToken, reserveMYToken, reserveUSDC) ;

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        // Calculate token out
        // ydx / (x + dx) = dy
        uint _amountInWithFee = (_amountIn * 995) / 1000;
        _amountOut = (reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);
        // _amountOut = isUsdc ? (_amountInWithFee * price * 10 ** 12) : (_amountInWithFee / (price * 10 ** 12));

        // Transfer token out to msg.sender
        tokenOut.transfer(msg.sender, _amountOut);

        // Update Reserves
        _updateReserves(USDCToken.balanceOf(address(this)), MYToken.balanceOf(address(this)));

        // if (reserveMYToken / (reserveUSDC * 10 ** 12) > 2) {
            
        // }

    }

    function _swapWithMyToken (IERC20 _tokenIn, uint _amountIn) external returns(uint _amountOut) {
        require(_tokenIn == USDCToken || _tokenIn == MYToken, "Invalid Token");
        require(_amountIn > 0 , "Amount zero");


        // Pull in token in
        bool isUsdc = _tokenIn ==  USDCToken;
        (IERC20 tokenIn, IERC20 tokenOut ) = isUsdc ? (USDCToken, MYToken) : (MYToken, USDCToken) ;

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        // Calculate token out
        // ydx / (x + dx) = dy
        uint _amountInWithFee = (_amountIn * 995) / 1000;
        // _amountOut = (reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);
        _amountOut = isUsdc ? (_amountInWithFee * price * 10 ** 12) : (_amountInWithFee / (price * 10 ** 12));

        // Transfer token out to msg.sender
        tokenOut.transfer(msg.sender, _amountOut);

        // Update Reserves
        _updateReserves(USDCToken.balanceOf(address(this)), MYToken.balanceOf(address(this)));

        // if (reserveMYToken / (reserveUSDC * 10 ** 12) > 2) {
            
        // }

    }

    function _swapWithEth () external payable returns(uint _amountOut) {
        // require(_tokenIn == 0 || _tokenIn == MYToken, "Invalid Token");
        require(msg.value > 0 , "Amount zero");


        // Pull in token in
    
        // Calculate token out
        // ydx / (x + dx) = dy
        uint _amountInWithFee = (msg.value * 995) / 1000;
        
        uint256 ethPrice = getEthPrice();
        _amountOut =(_amountInWithFee * ethPrice * price / (10 ** 18));

        // Transfer token out to msg.sender
        MYToken.transfer(msg.sender, _amountOut);

        // // Update Reserves
        // _updateReserves(USDCToken.balanceOf(address(this)), MYToken.balanceOf(address(this)));

        // if (reserveMYToken / (reserveUSDC * 10 ** 12) > 2) {
            
        // }

    }
    function showPrice(uint amountEth) external view returns (uint){
        uint256 ethPrice = getEthPrice();
        uint _amountOut =((amountEth * ethPrice * price) / (10 ** 18));
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
    


    function _updateReserves (uint _reserveUSDC, uint _reserveMYToken) private {
        reserveUSDC = _reserveUSDC;
        reserveMYToken = _reserveMYToken;
    }

    function _addLiquidity (uint _amountUSDCToken, uint _amountMYToken) external returns (uint shares){
        // Pull in USDC & MYToken
        USDCToken.transferFrom(msg.sender, address(this), (_amountUSDCToken ));
        MYToken.transferFrom(msg.sender, address(this), (_amountMYToken));

        // DY / DX = Y / X
        if (reserveUSDC > 0 || reserveMYToken > 0) {
            require(reserveUSDC * _amountMYToken == reserveMYToken * _amountUSDCToken, "This amounts will change the price");
        }

        // Mint shares
        // f(x, y) = value of liquidity = sqrt(xy)
        // s = dx / x * T = dy / y * T 
        if (totalSupply == 0) {
            shares = _sqrt(_amountUSDCToken *  _amountMYToken);
        } else {
            shares = _min((_amountUSDCToken * totalSupply) / reserveUSDC, (_amountMYToken * totalSupply) / reserveMYToken);
            require(shares > 0, "shares = 0");
        }
        _mintShares(msg.sender, shares);

        // Update reserves
        _updateReserves(USDCToken.balanceOf(address(this)), MYToken.balanceOf(address(this)));
    }

    function _removeLiquidity(uint _shares)external returns (uint amountUSDC, uint amountMYToken) {
        // Calculate amounts with shares:
        // dx = (s * x) / T
        // dy = (s * y) / T
        uint balUSDC = USDCToken.balanceOf(address(this));
        uint balMYT = MYToken.balanceOf(address(this));

        amountUSDC = (_shares * balUSDC ) / totalSupply;
        amountMYToken = (_shares * balMYT ) / totalSupply;

        require(amountUSDC > 0 && amountMYToken > 0, "One the amounts = 0");

        // Burn the shares
        _burnShares(msg.sender, _shares);

        // Update reserves 
        _updateReserves(balUSDC - amountUSDC, balMYT - amountMYToken);

        // Transfer tokens to msg.sender
        USDCToken.transfer(msg.sender, amountUSDC);
        MYToken.transfer(msg.sender, amountMYToken);

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