// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SimpleSwap {
    string public name = "SimpleSwapLiquidityToken";
    string public symbol = "SSLT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public tokenA;
    address public tokenB;

    uint public reserveA;
    uint public reserveB;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    // Internal mint
    function _mint(address to, uint256 amount) internal {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    // Internal burn
    function _burn(address from, uint256 amount) internal {
        require(balanceOf[from] >= amount, "Burn exceeds balance");
        balanceOf[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        require(block.timestamp <= deadline, "Deadline expired");
        require(_tokenA == tokenA && _tokenB == tokenB, "Invalid pair");

        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);

        amountA = amountADesired;
        amountB = amountBDesired;

        require(amountA >= amountAMin && amountB >= amountBMin, "Slippage");

        liquidity = sqrt(amountA * amountB);
        _mint(to, liquidity);

        reserveA += amountA;
        reserveB += amountB;
    }

    function removeLiquidity(
        address _tokenA,
        address _tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB) {
        require(block.timestamp <= deadline, "Deadline expired");
        require(_tokenA == tokenA && _tokenB == tokenB, "Invalid pair");

        uint totalLiq = totalSupply;
        amountA = (liquidity * reserveA) / totalLiq;
        amountB = (liquidity * reserveB) / totalLiq;

        require(amountA >= amountAMin && amountB >= amountBMin, "Slippage");

        _burn(msg.sender, liquidity);

        IERC20(tokenA).transfer(to, amountA);
        IERC20(tokenB).transfer(to, amountB);

        reserveA -= amountA;
        reserveB -= amountB;
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        require(block.timestamp <= deadline, "Deadline expired");
        require(path.length == 2, "Invalid path");
        address fromToken = path[0];
        address toToken = path[1];
        require((fromToken == tokenA && toToken == tokenB) || (fromToken == tokenB && toToken == tokenA), "Invalid pair");

        IERC20(fromToken).transferFrom(msg.sender, address(this), amountIn);

        uint reserveIn = fromToken == tokenA ? reserveA : reserveB;
        uint reserveOut = toToken == tokenA ? reserveA : reserveB;

        uint amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= amountOutMin, "Slippage");

        IERC20(toToken).transfer(to, amountOut);

        if (fromToken == tokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }
    }

    function getPrice(address _tokenA, address _tokenB) external view returns (uint price) {
        require((_tokenA == tokenA && _tokenB == tokenB) || (_tokenA == tokenB && _tokenB == tokenA), "Invalid pair");
        if (_tokenA == tokenA) {
            price = (reserveB * 1e18) / reserveA;
        } else {
            price = (reserveA * 1e18) / reserveB;
        }
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid input");
        uint amountInWithFee = amountIn * 997;
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function sqrt(uint y) internal pure returns (uint z) {
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
}
