# 🌀 SimpleSwap

**SimpleSwap** is a minimalistic Automated Market Maker (AMM) smart contract, inspired by [Uniswap V2](https://uniswap.org/), and written in Solidity. It enables token swaps, liquidity provisioning, and LP token minting between two ERC20 tokens with a constant product formula.

---

## ✨ Features

* 🔁 **ERC20-to-ERC20 swaps** based on x \* y = k formula
* 💧 **Liquidity provision and redemption** with internal LP tokens (`Liquidity Token`, symbol: `LQT`)
* 📈 **Live reserve tracking** and token pricing
* ⚠️ **Slippage control** and transaction deadline handling
* 🔒 **Fully on-chain**, no need for oracles

---

## 📦 Requirements

* `Solidity ^0.8.0`
* [`@openzeppelin/contracts`](https://github.com/OpenZeppelin/openzeppelin-contracts)

Install dependencies:

```bash
npm install @openzeppelin/contracts
```

---

## 🔗 Deployed Contracts (Verified)

| Contract       | Address                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Token A**    | [`0x06B27208fA66d387633EfBe628f02a15d6608A1F`](https://sepolia.etherscan.io/address/0x06B27208fA66d387633EfBe628f02a15d6608A1F) |
| **Token B**    | [`0xeC6CDbB141aEc0C981c0E5e4a825227E412f7B99`](https://sepolia.etherscan.io/address/0xeC6CDbB141aEc0C981c0E5e4a825227E412f7B99) |
| **SimpleSwap** | [`0xD4c51Fb24A1Fa0d68241a58b9AF623d60313Fbbd`](https://sepolia.etherscan.io/address/0xD4c51Fb24A1Fa0d68241a58b9AF623d60313Fbbd) |

---

## 🧪 Core Functions

### `addLiquidity(...)`

👅 Adds liquidity using both tokens. Mints LP tokens proportional to the deposit. Slippage protection with `amountAMin` and `amountBMin`.

### `removeLiquidity(...)`

👄 Burns LP tokens and returns the proportional amounts of both tokens. Enforces minimum output thresholds.

### `swapExactTokensForTokens(...)`

🔄 Swaps an exact input amount of one token for the maximum possible output of the other.

### `getAmountOut(...)`

📊 Calculates the output token amount using the constant product formula.

### `getPrice(...)`

💱 Returns the current price between `tokenA` and `tokenB`, normalized to 18 decimals.

### `getReserves()`

🛆 Retrieves current token reserves.

---

## 🧾 Example Usage

```solidity
SimpleSwap pool = new SimpleSwap(address(tokenA), address(tokenB));

pool.addLiquidity(
    address(tokenA),
    address(tokenB),
    1000 ether,
    1000 ether,
    900 ether,
    900 ether,
    msg.sender,
    block.timestamp + 300
);

pool.swapExactTokensForTokens(
    100 ether,
    90 ether,
    new address[](2) { tokenA, tokenB },
    msg.sender,
    block.timestamp + 300
);
```

---

## 👨‍💼 Author

Developed by **Walter Liendo**
📄 Licensed under the [MIT License](https://opensource.org/licenses/MIT)

---
