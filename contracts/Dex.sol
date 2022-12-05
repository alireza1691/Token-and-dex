// // SPDX-License-Identifier: GPL-2.0-or-later
// pragma solidity ^0.8.17;
// pragma abicoder v2;

// import "./ISwapRouter.sol";

// interface IERC20 {
//     function balanceOf(address account) external view returns (uint256);

//     function transfer(address recipient, uint256 amount)
//         external
//         returns (bool);

//     function approve(address spender, uint256 amount) external returns (bool);
// }

// contract SingleSwap {
//     address public routerAddress;
//     ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

//     address public constant USDCToken = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
//     address public Token;

//     IERC20 public USDC = IERC20(USDCToken);

//     // For this example, we will set the pool fee to 0.3%.
//     uint24 public constant poolFee = 5000;

//     constructor(address _tokenAddress,address _routerAddress) {
//         Token = _tokenAddress;
//         routerAddress = _routerAddress;
//     }

//     function swapExactInputSingle(uint256 amountIn)
//         external
//         returns (uint256 amountOut)
//     {
//         USDC.approve(address(swapRouter), amountIn);

//         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
//             .ExactInputSingleParams({
//                 tokenIn: USDCToken,
//                 tokenOut: Token,
//                 fee: poolFee,
//                 recipient: address(this),
//                 deadline: block.timestamp,
//                 amountIn: amountIn,
//                 amountOutMinimum: 0,
//                 sqrtPriceLimitX96: 0
//             });

//         amountOut = swapRouter.exactInputSingle(params);
//     }

//     function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum)
//         external
//         returns (uint256 amountIn)
//     {
//         USDC.approve(address(swapRouter), amountInMaximum);

//         ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
//             .ExactOutputSingleParams({
//                 tokenIn: USDCToken,
//                 tokenOut: Token,
//                 fee: poolFee,
//                 recipient: address(this),
//                 deadline: block.timestamp,
//                 amountOut: amountOut,
//                 amountInMaximum: amountInMaximum,
//                 sqrtPriceLimitX96: 0
//             });

//         amountIn = swapRouter.exactOutputSingle(params);

//         if (amountIn < amountInMaximum) {
//             USDC.approve(address(swapRouter), 0);
//             USDC.transfer(address(this), amountInMaximum - amountIn);
//         }
//     }
// }