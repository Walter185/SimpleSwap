# 🌀 SimpleSwap

**SimpleSwap** is a lightweight Automated Market Maker (AMM) smart contract, inspired by [Uniswap V2](https://uniswap.org/), written in Solidity. It enables token swaps, liquidity provision, and LP token management between two ERC20 tokens.

## ✨ Features

- ERC20 ↔ ERC20 token swaps using constant product formula
- Liquidity provision and redemption with internal LP tokens (`Liquidity Token`, symbol: `LQT`)
- Real-time reserve and price tracking
- Slippage protection and deadline handling
- Fully on-chain, no external oracles

## 📦 Requirements

- Solidity `^0.8.0`
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)

## 🛠 Installation

Install OpenZeppelin dependencies:

```bash
npm install @openzeppelin/contracts

🔗 Deployed Contracts
All contracts are deployed and verified:

Contract	Address
Token A	0x06B27208fA66d387633EfBe628f02a15d6608A1F
Token B	0xeC6CDbB141aEc0C981c0E5e4a825227E412f7B99
SimpleSwap	0xD4c51Fb24A1Fa0d68241a58b9AF623d60313Fbbd

🧪 Core Functions
addLiquidity(...)
Adds liquidity to the pool using both tokens. Mints LP tokens proportional to the contribution.

removeLiquidity(...)
Burns LP tokens and returns the underlying tokens to the user.

swapExactTokensForTokens(...)
Swaps a fixed amount of one token for the other based on reserves.

getAmountOut(...)
Calculates the output token amount using the constant product formula.

getPrice(...)
Returns the current token price between tokenA and tokenB.

getReserves()
Returns current reserve balances.

🧾 Example Usage

SimpleSwap pool = new SimpleSwap(address(tokenA), address(tokenB));
pool.addLiquidity(...);
pool.swapExactTokensForTokens(...);

👨‍💻 Author
Developed by Walter Liendo
Licensed under the MIT License