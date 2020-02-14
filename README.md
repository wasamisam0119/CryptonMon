# CryptoMon

A simple Ethereum-based [CryptoKitties](https://www.cryptokitties.co/)-like decentralized application (dapp) where you can own, buy, trade, fight and breed pokemon.



---

![CryptoVipers](./sell.gif)


## Prerequisites

* **Node** - v10.x.x (preferrably v10.15.0 for long term support)
* **npm** - v6.x.x (preferrably v6.6.0)

## Running It Locally

Clone this repo via to your local machine and install the dependencies by doing the following:

```bash
git clone https://github.com/wasamisam0119/CryptonMon.git
cd CryptonMon
npm install
```

Serve the application with hot reload in a development environment via:

```bash
npm run dev
```

## Built With

* [Solidity](https://solidity.readthedocs.io/en/v0.5.3/) - Ethereum's smart contract programming language
* [Vue.js](https://vuejs.org/) - The Javascript framework used
* [web3.js](https://github.com/ethereum/web3.js/) - Javascript library used to interact with the Ethereum blockchain

## Market  

You can either buy and sell cryptomons from/on the market. Just put some gas, no extra cost!

![market](./sell.gif)

## Fight

You can fight with other crypotomon by simply type in the id, and if you wins, your cryptomon will get some HP reward! 

![CryptoVipers](./fight.gif)

###Implementation:




## Share 

You are allowed to give their crypotomon to others, as long as you know his/her public address.

![CryptoVipers](./give.gif)

## Breed
You can breed a new crypotomon from two cryptomon, and probably the new crypotomon will inherite good genes from  their parents!
![CryptoVipers](./fight.gif) 

##Security
The contract implements ERC721 token standard and inherite from **openzeppelin-ERC721** which already ensure some security function.

### Overflow and underflow--SafeMath

It is very common to use unsigned integer in solidity like uint8, but we can see simple overflow example as below:

```python
uint8 number = 255;
number++;
```

 I use openzeppelin's safemath implementation to aviod the problem:

```solidity
using SafeMath for uint8;
```

```java
function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
```

### Reentrancy Attack

I researched on solidity docs, and the `.transfer()` has already prevent reentrancy attack to some extent:

![attack](./Pics/attack.png)