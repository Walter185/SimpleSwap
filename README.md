# 🌀 SimpleSwap

## Overview

**SimpleSwap** is a lightweight decentralized exchange (DEX) smart contract written in Solidity that replicates core features of Uniswap V2, enabling token swaps and liquidity management without relying on external protocols.

This project was developed as part of the ETHEKIPU learning program to deepen understanding of AMM-based liquidity pools and decentralized token exchange mechanics.

---

## 🧠 Features

- ✅ Add liquidity to any ERC-20 token pair
- ✅ Remove liquidity and withdraw proportional assets
- ✅ Swap one token for another based on pool reserves
- ✅ View real-time price of one token relative to another
- ✅ Estimate output amount for swaps

---

## 📄 Contract Functions

### `addLiquidity(...)`
Adds liquidity to a token pair pool, minting liquidity tokens.

### `removeLiquidity(...)`
Removes liquidity from a pool, burning liquidity tokens and returning underlying assets.

### `swapExactTokensForTokens(...)`
Swaps an exact amount of one token for the calculated amount of another token.

### `getPrice(...)`
Returns the spot price of one token in terms of another, based on pool reserves.

### `getAmountOut(...)`
Calculates how much output you'd receive when swapping a given amount in.

---

## 🔧 Technologies Used

- **Solidity** `^0.8.0`
- **OpenZeppelin Contracts** for safe ERC-20 token operations
- **Math utilities** for liquidity and price calculations

---

## 🧪 Usage & Deployment

1. Compile the contract using [Remix](https://remix.ethereum.org/) or Hardhat.
2. Deploy it to a local testnet or a public testnet (e.g., Sepolia).
3. Interact using tools like Remix, Etherscan, or a front-end DApp interface.
4. Make sure tokens are approved before calling `addLiquidity` or `swapExactTokensForTokens`.

---

## 📁 File Structure

📦SimpleSwap
┣ 📄SimpleSwap.sol
┗ 📄TokenA.sol
┗ 📄TokenB.sol
┗ 📄README.md


---

## 🧾 Autor

Walter Liendo ( walter.liendo@gmail.com )

## 🧾 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## 🙌 Acknowledgements

Built as part of the **ETHEKIPU** program. Inspired by [Uniswap V2 Docs](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02).

---
