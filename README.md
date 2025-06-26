
# 🦄 SimpleSwap Smart Contract

This project implements a basic decentralized exchange (DEX) smart contract similar to Uniswap V2. It allows users to:

- Add liquidity to a token pair
- Remove liquidity
- Swap tokens with constant product formula
- Query prices and estimated output amounts

## 🚀 Contracts Deployed on Sepolia

- **Token A (TKA)**  
  [`0x06B27208fA66d387633EfBe628f02a15d6608A1F`](https://sepolia.etherscan.io/address/0x06B27208fA66d387633EfBe628f02a15d6608A1F)

- **Token B (TKB)**  
  [`0xeC6CDbB141aEc0C981c0E5e4a825227E412f7B99`](https://sepolia.etherscan.io/address/0xeC6CDbB141aEc0C981c0E5e4a825227E412f7B99)

- **SimpleSwap**  
  [`0x3F5C540D9087f4C95Ca6264B65A170353d2Ab03D`](https://sepolia.etherscan.io/address/0x3F5C540D9087f4C95Ca6264B65A170353d2Ab03D)

---

## 🛠 Features

### ✅ Add Liquidity

```solidity
function addLiquidity(
  address tokenA,
  address tokenB,
  uint amountADesired,
  uint amountBDesired,
  uint amountAMin,
  uint amountBMin,
  address to,
  uint deadline
) external returns (uint amountA, uint amountB, uint liquidity)
```

### ✅ Remove Liquidity

```solidity
function removeLiquidity(
  address tokenA,
  address tokenB,
  uint liquidity,
  uint amountAMin,
  uint amountBMin,
  address to,
  uint deadline
) external returns (uint amountA, uint amountB)
```

### 🔄 Swap Tokens

```solidity
function swapExactTokensForTokens(
  uint amountIn,
  uint amountOutMin,
  address[] calldata path,
  address to,
  uint deadline
) external
```

### 📈 Get Price

```solidity
function getPrice(address tokenA, address tokenB) external view returns (uint price)
```

### 🔍 Estimate Output Amount

```solidity
function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut)
```

---

## 👨‍🎓 Author

**Walter Liendo**  
*Student at [EthKipu](https://campus.ethkipu.org/)*  
📧 walter.liendo@gmail.com

---

## 📄 License

MIT  
Smart contract code is open source and free to use under the [MIT License](https://opensource.org/licenses/MIT).
