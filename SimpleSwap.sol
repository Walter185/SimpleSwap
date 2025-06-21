// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title SimpleSwap - Uniswap V2-style AMM with internal LP Token
contract SimpleSwap is ERC20 {
using SafeMath for uint256;


address public immutable tokenA;
address public immutable tokenB;

uint256 public reserveA;
uint256 public reserveB;

constructor(address _tokenA, address _tokenB) ERC20("Liquidity Token", "LQT") {
    require(_tokenA != _tokenB, "Tokens must differ");
    tokenA = _tokenA;
    tokenB = _tokenB;
}

/// @notice Adds liquidity to the pool and mints LP tokens
function addLiquidity(
    address _tokenA,
    address _tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
) external returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
    require(block.timestamp <= deadline, "Deadline passed");
    require((_tokenA == tokenA && _tokenB == tokenB) || (_tokenA == tokenB && _tokenB == tokenA), "Invalid tokens");

    (amountA, amountB) = (_tokenA == tokenA)
        ? (amountADesired, amountBDesired)
        : (amountBDesired, amountADesired);

    require(amountA >= amountAMin && amountB >= amountBMin, "Slippage too high");

    IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
    IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

    if (totalSupply() == 0) {
        liquidity = Math.sqrt(amountA.mul(amountB));
    } else {
        liquidity = Math.min(
            amountA.mul(totalSupply()) / reserveA,
            amountB.mul(totalSupply()) / reserveB
        );
    }

    require(liquidity > 0, "Insufficient liquidity minted");
    _mint(to, liquidity);

    reserveA += amountA;
    reserveB += amountB;
}

/// @notice Removes liquidity from the pool and burns LP tokens
function removeLiquidity(
    address _tokenA,
    address _tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
) external returns (uint256 amountA, uint256 amountB) {
    require(block.timestamp <= deadline, "Deadline passed");
    require((_tokenA == tokenA && _tokenB == tokenB) || (_tokenA == tokenB && _tokenB == tokenA), "Invalid tokens");

    uint256 _totalSupply = totalSupply();
    amountA = liquidity.mul(reserveA) / _totalSupply; // multiplico
    amountB = liquidity.mul(reserveB) / _totalSupply;

    require(amountA >= amountAMin && amountB >= amountBMin, "Slippage too high");

    _burn(msg.sender, liquidity);
    IERC20(tokenA).transfer(to, amountA);
    IERC20(tokenB).transfer(to, amountB);

    reserveA -= amountA;
    reserveB -= amountB;
}

/// @notice Swaps exact tokens for tokens
function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
) external returns (uint256[] memory amounts) {
    require(path.length == 2, "Only 2-token path supported");
    require(block.timestamp <= deadline, "Deadline passed");
    require((path[0] == tokenA && path[1] == tokenB) || (path[0] == tokenB && path[1] == tokenA), "Invalid path");

    bool isAToB = path[0] == tokenA;

    address inputToken = path[0];
    address outputToken = path[1];

    uint256 reserveIn = isAToB ? reserveA : reserveB;
    uint256 reserveOut = isAToB ? reserveB : reserveA;

    IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

    uint256 amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
    require(amountOut >= amountOutMin, "Slippage exceeded");

    IERC20(outputToken).transfer(to, amountOut);

    if (isAToB) {
        reserveA += amountIn;
        reserveB -= amountOut;
    } else {
        reserveB += amountIn;
        reserveA -= amountOut;
    }

    amounts = new uint256[](2);
    amounts[0] = amountIn;
    amounts[1] = amountOut;
}

/// @notice Calculates how many output tokens will be received for a given input
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut)
    public
    pure
    returns (uint256 amountOut)
{
    require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid input or reserves");
    amountOut = (amountIn * reserveOut) / (reserveIn + amountIn);
}

/// @notice Gets price of tokenA in terms of tokenB
function getPrice(address _tokenA, address _tokenB) external view returns (uint256 price) {
    require((_tokenA == tokenA || _tokenA == tokenB) && (_tokenB == tokenA || _tokenB == tokenB), "Invalid tokens");
    if (_tokenA == tokenA && _tokenB == tokenB) {
        price = (reserveB * 1e18) / reserveA;
    } else if (_tokenA == tokenB && _tokenB == tokenA) {
        price = (reserveA * 1e18) / reserveB;
    } else {
        revert("Invalid token pair");
    }
}

/// @notice Returns current reserves
function getReserves() external view returns (uint256, uint256) {
    return (reserveA, reserveB);
}

}
