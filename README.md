# CryptoMon

A simple Ethereum-based [CryptoKitties](https://www.cryptokitties.co/)-like decentralized application (dapp) where you can own, buy, trade, fight and breed pokemon.



---

![CryptoVipers](./Pics/sell.gif)


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

Serve the application with hot reload in a development environment via(you may need to wait 20 sec when initialization):

```bash
npm run dev
```

## Built With

* [Solidity](https://solidity.readthedocs.io/en/v0.5.3/) - Ethereum's smart contract programming language
* [Vue.js](https://vuejs.org/) - The Javascript framework used
* [web3.js](https://github.com/ethereum/web3.js/) - Javascript library used to interact with the Ethereum blockchain

## User Interface

There are three tabs that user can view:

* **MARKET** Sell cards will be listed on rthe market
* **MY ACCOUNT** User can see his/her cards and do operations
* **WORLD** User can view and verify all the cards

![UI](./Pics/UI.png)

### Market

You can either buy and sell cryptomons from/on the market. Just put some gas, no extra cost!

<img src="./Pics/sell.gif" width="75%" height="75%" alt="ceremony" align = center>

When cryptomon is on the market, you can not fight or give to other users. I implemented this function in the front-end by disable the button.

<img src="./Pics/disable.png" width="30%" height="50%" alt="ceremony" align = center>

Once the item has been sold, the application will update the market and user's account and balance. 



### Fight

You can fight with other crypotomon by simply type in the id, and if you wins, your cryptomon will get some extra HP reward! 

<img src="./Pics/fight.gif" width="75%" height="75%" alt="ceremony" align = center>

### Fight Mechanism:  

The winning chance is partially depend on **Your Attack/Opponent HP** and **Opponent Attack/Your HP**. I also introduced genes: if a water pokemon vs fire pokemon, the water pokemon can get 2 times bonus attack. 

**\*\*Randomness\*\*** When fighting, it will calculated:

random number(between 0-10) +**extra winning chances** > 5

```java
if(cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP>0){
            //extra_winning_chance = (cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP) +1;
            extra_winning_chance = 2;
        }
        else{
            //extra_winning_chance = 1 - (cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP);
            extra_winning_chance = 0;
        }             
```

However, the solidity doesn't support float numbers which is a sad thing, I finnally substitude the fraction number to integer.

```java
  if (random_number+extra_winning_chance>5)
  	{
        cards[atk_id].HP = cards[atk_id].HP+random_number;
        emit Fight("Win",random_number);
    }
```
```java
function random() public view returns (uint8) {
    return uint8(uint256(keccak256(abi.encodePacked(now, block.difficulty))));
}
```
I use the **block.timestamp** and **block.difficulty** to generate random numbers. The **block.timestamp** is generated once the block is mined and confirmed by the miner and it's kind of random, and **block.difficulty** is also not controlled by user, but it may be controlled by the miners as [Hovsepyan](https://medium.com/@promentol?source=post_page-----4f586a152b27----------------------) demonstrated in his article. However, there are nicer random number generation based on hash of user post data(lottery number) which can be explored further.

#### Fight Result

`event Fight(string msg, uint HP_gain);`

An **event.Fight** will be emitted once the fight is over, and if you wins, you will have a random HP gaining adding to your cryptomon.



### Share

You are allowed to give their crypotomon to others, as long as you know his/her public address.

<img src="./Pics/give.gif" width="75%" height="75%" alt="ceremony" align = center>

### Breed

You can breed a new crypotomon from two cryptomon, and probably the new crypotomon will inherite good genes from their parents!

<img src="./Pics/breed.gif" width="75%" height="75%" alt="ceremony" align = center>

#### Breed Mechanism: 

The breed process took instantly and the kid's gene is inherit from his/her parents, his `gene` will be `matron_gene`and his/her attack will be `(matronATK+sireATK)/2+ random()%20`

### Transactions

When user successfully make an behavior, transaction confirmation will be showed at the bottom snackbar:

![snackbar](./Pics/snackbar.png)



##Contract Implementation and Security

The contract implements **ERC721** non-fungible token standard and inherite from **openzeppelin-ERC721 interface** which already ensure some security function.

`contract Cryptomon is ERC721Enumerable,Ownable, ReentrancyGuard`

### Data Structure and Access Control

Instead of constructing a new contract everytime when generating new pokemon, I use a struct to represent and store the pokemon which will be more efficient for gas fees:

```c
   struct Card {  
        uint256 id;
        uint8 genes;
        uint256 matronId;
        uint256 sireId;
        uint HP;
        uint ATK;
    }
```

I introduced **private** variables to hide the data value not to be changed by unknown entity. 

```java
mapping (uint256 => bool) private _tokenOnMarket;
uint256 [] private market_list;
```

Modifier is also been used to aviod violated behavior:

```java
  modifier isOnMarket(uint256 id){
        require(_tokenOnMarket[id]==true,"On market");
        _;
    }
```
### Overflow and Underflow--SafeMath

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

**In addition**, I used a mutex to ensure the `buyCard(uint256 id, uint price)` function execute in atomic: **nonReentrant** modifier-- it's a implementation from OpenZeppelin, and basiclly it set a [True-false flag](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/06983a2075ab8fd114352af210bf62246ddb6b1d/contracts/utils/ReentrancyGuard.sol) in a function to lock.

### Function Visibility

Function sometimes can be vulnerable if expose in public, and hacker might actually use javascript to exploit some function that can bring him benefits. At first, I make the `createCard()` public because I want to let the contract owner to create the card, and I add an modifier `onlyOwner` then I realize it has conflicted with the situation that create some cards when initializing the contract.  After thinking I finally make the function into `internal` and add an `constructor()`:

``` javascript
function createCard(address receiver, uint8 genes) internal returns (uint256)
```

```java
constructor() ERC721Enumerable() public {
	createCard(msg.sender,1);
    createCard(msg.sender,3);
}
```
So that the contract owner will be able to create cards and the function will not be exposed to other user.

### Front-end Input Checking

User might type unexpected input. Instead of handling it in the back-end, it's best to prevent bad things happen before it passed to solidity. 

For example, when `breeding` the cryptomon, user can not breed with a cryptomon that user doesn't own:

```javascript
if (this.contains(this.myCards,this.matron) && this.contains(this.myCards,this.sire))
```

For example, when `fighting`, user can not fight with himself/herself:

```javascript
if(this.contains(this.myCards,def_id))
      {
        this.fightAlert = true;
        this.alertmessage = "Cheeky! You'd better not fight with yourself";
      }
```

