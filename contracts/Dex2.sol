// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;
pragma abicoder v2;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
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

contract MyDex {

    address public USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    address public myToken;
    IERC20 public USDCToken = IERC20(USDC);
    IERC20 public MYToken = IERC20(myToken);

    uint public reserveUSDC;
    uint public reserveMYToken;

    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    constructor(address _token) {
        myToken = _token;
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

        tokenIn.approve(msg.sender, _amountIn);
        // Calculate token out
        // ydx / (x + dx) = dy
        uint _amountInWithFee = (_amountIn * 995) / 1000;
        _amountOut = (reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);

        // Transfer token out to msg.sender
        tokenOut.transfer(msg.sender, _amountOut);

        // Update Reserves
        _updateReserves(USDCToken.balanceOf(address(this)), MYToken.balanceOf(address(this)));

    }

    function _updateReserves (uint _reserveUSDC, uint _reserveMYToken) private {
        reserveUSDC = _reserveUSDC;
        reserveMYToken = _reserveMYToken;
    }

    function _addLiquidity (uint _amountUSDCToken, uint _amountMYToken) external returns (uint shares){

        // Pull in USDC & MYToken
        USDCToken.transferFrom(msg.sender, address(this), _amountUSDCToken);
        MYToken.transferFrom(msg.sender, address(this), _amountMYToken);

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

   
}