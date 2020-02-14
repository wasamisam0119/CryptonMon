pragma solidity ^0.5.1.16;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Full.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol';
contract Cryptomon is ERC721Enumerable,Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    using SafeMath for uint8;
    
    //Counting total cards using OpenZeppelin library
    using Counters for Counters.Counter;
    Counters.Counter private _cardIds;
    
    //This struct will be used to represent one Cards
    struct Card {
        
        uint256 id;
        uint8 genes;
        uint256 matronId;
        uint256 sireId;
        uint HP;
        uint ATK;
    }
    
    event List(address owner, uint price, uint256 id);
    event unList(address owner,uint256 id);
    event Empty(string messgae);
    
    //id->Card
    mapping(uint256=>Card) cards;
    
    mapping (uint256 => uint256) private market_listIndex;
    
    uint[] public price_list;
    
    //card id=>price
    mapping (uint256=>uint) public price_list_map;
    
    //card id => if it is on market
    mapping (uint256 => bool) private _tokenOnMarket;
    
    //card id that are on the market
    uint256 [] private market_list;
    
    function getCardPrice(uint256 id) public view returns(uint){
        return price_list_map[id];
    }
    
    function getMarketCards() public view returns (uint256[] memory){
        
        uint256 [] memory market_on_list = market_list;
        return market_on_list;
    }
    function onMarket(uint256 id) public view returns(bool){
        return _tokenOnMarket[id];
    }

    modifier isOnMarket(uint256 id){
        require(_tokenOnMarket[id]==true,"On market");
        _;
    }
    
    modifier isOffMarket(uint256 id){
        require(_tokenOnMarket[id]==false,"On market");
        _;
    }
    
    // initialize the contract with some cards and put them to the market.
    constructor() ERC721Enumerable() public {
        createCard(msg.sender,1);
        createCard(msg.sender,3);
        createCard(msg.sender,5);
        createCard(msg.sender,8);
        createCard(msg.sender,4);
        putOnMarket(1,3);
        putOnMarket(2,1);
        
        
    }
    //createCard and assign the owner and genes to the pokemon
    function createCard(address receiver, uint8 genes) internal returns (uint256)
    {
        _cardIds.increment();
        uint256 newCardId = _cardIds.current();
        //call _mint() as create from ERC721Enumerable
        _mint(receiver, newCardId);
        
        //use time stamp to add some interesting random initialization of attack.
        Card memory newCard = Card({
            id: newCardId,
            genes: genes,
            matronId: 0,
            sireId: 0,
            HP: 100,
            ATK: 16+now%8 
        });
        
        //add new card to the list
        cards[newCardId] = newCard;
    
        return newCardId;
    }
    
    function breedKid(uint256 matronId, uint256 sireId) public payable {
        require(msg.value >= 0.05 ether);   //breeding cost 0.05 ether
        _cardIds.increment();
        
        uint256 newCardId = _cardIds.current();
        uint8 sire_gene = cards[sireId].genes;
        uint8 matron_gene = cards[matronId].genes;
        uint matronATK = cards[matronId].ATK;
        uint sireATK = cards[sireId].ATK;
        uint8 new_gene = matron_gene;
        
        //create new Cryptomon
        Card memory newCard = Card({
            id: newCardId,
            genes: new_gene,
            matronId: matronId,
            sireId: sireId,
            HP: 100,
            ATK:(matronATK+sireATK)/2+ random()%20
        });
        cards[newCardId] = newCard;
        price_list_map[newCardId] = 0;
        _tokenOnMarket[newCardId] = false;
        //call _mint() to generate a new token using ERC721._mint()
        _mint(msg.sender, newCardId);
        
        
    }
    // block time stamp and block difficulty to add some interesting random initialization.
    function random() public view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(now, block.difficulty))));
    }

    /*
    Put a card on to the market, use #tx.origin# because at the contract construction stage, 
    the caller should be the creator not the contract itself. A->B->C, here the owner is A not B.
    */
    function putOnMarket(uint256 id, uint price) public isOffMarket(id)  {
        require(price>0,"Price must bigger than 0");
        require(tx.origin==ownerOf(id),"You must be the owner");
        _tokenOnMarket[id] = true;
        _addTokenToMarket(id,price);
        emit List(msg.sender, id, price);
     }
    
    function takeOffMarket(uint256 id) public payable isOnMarket(id) {
        require(msg.sender == ownerOf(id),"You are not the owner");
        _tokenOnMarket[id] = false;
        _removeTokenFromMarket(id);
        emit unList(msg.sender, id);
        
    }
    
    /*maintain a market index and price list*/    
    function _addTokenToMarket(uint256 id, uint price) private {
        market_listIndex[id] = price_list.length;
        price_list.push(price);
        market_list.push(id);
        price_list_map[id] = price;
    }
    
    /*maintain a market index and price list*/ 
    function _removeTokenFromMarket(uint256 id) private {
        uint256 lastTokenIndex = market_list.length - 1;
        uint256 tokenIndex = market_listIndex[id];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = market_list[lastTokenIndex];
            uint256 lastPrice = price_list[lastTokenIndex];
            market_list[tokenIndex] = lastTokenId;
            price_list[tokenIndex] = lastPrice;
            market_listIndex[lastTokenId] = tokenIndex;
        }
        
        market_list.pop();
        price_list.pop();
        price_list_map[id] = 0;
    }
    
    /*
    Buy a card from the market, I use nonReentrant modifier-- it's a mutex lock from OpenZeppelin's implementation
    to keep the transfer safe, and ensure the function execute in atomic.
    */
    
    function buyCard(uint256 id, uint price) public payable isOnMarket(id) nonReentrant{
        //require the msg price is higher than market price
        require(msg.value>=price_list_map[id]);
        require(ownerOf(id) != msg.sender);
        
        address payable seller = address(uint160(ownerOf(id)));
        _transferFrom(seller,msg.sender,id);
        takeOffMarket(id);
        seller.transfer(msg.value);
        
        
    }
    //emit a fight result event to the front end JS to update the page
    event Fight(string msg, uint HP_gain);
    
    function fight(uint256 atk_id, uint256 def_id) public{
        // returns(string memory,uint)
        require(ownerOf(atk_id) == msg.sender, "this is not your token");
        require(ownerOf(def_id) != msg.sender, "you can't attack yourself");

        Card memory cardATK = cards[atk_id];
        Card memory cardDEF = cards[def_id];

        uint bonusATK = 1;
        uint bonusDEF = 1;
        //get some extra bonus attack from the gene 
        if((cardATK.genes+1)%3 == cardDEF.genes) {
            bonusDEF = 2;
        } else if((cardDEF.genes+1)%3 == cardATK.genes) {
            bonusATK = 2;
        }
        
        uint random_number = random()%10;
        uint extra_winning_chance;
        
        if(cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP>0)
        {
            //extra_winning_chance = (cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP) +1;
            extra_winning_chance = 2;
        }
        else{
            //extra_winning_chance = 1 - (cardATK.ATK*bonusATK/cardDEF.HP - cardDEF.ATK*bonusDEF/cardATK.HP);
            extra_winning_chance = 0;
        }
        
        if (random_number+extra_winning_chance>5)
        {
            cards[atk_id].HP = cards[atk_id].HP+random_number;
            emit Fight("Win",random_number);
        }
        else
        {
            emit Fight("Lose",0);
        }

    
    }
    
    /*get all the detail of a single card*/
    function getCardDetails(uint256 id) external view returns (uint256, uint8, uint256, uint256, uint,uint) {
        require(id<=totalSupply());
        Card memory card = cards[id];
        return (id, card.genes, card.matronId, card.sireId,card.HP,card.ATK);
    }
    
    // debug for output
    event test_value(uint256 [] value);
    
    
    function getMyCard() public view returns(uint256[] memory)
    {
        
        uint256 [] memory mycards_id = _tokensOfOwner(msg.sender);
        if (mycards_id.length ==0){
            return new uint256[](0);
        }
        else{
            return mycards_id;
        }
    }
    
    /*give a card to some address, require not on the market*/
    function give(address to, uint256 id) public payable isOffMarket(id) {
        require(msg.sender == ownerOf(id));
        _transferFrom(msg.sender,to,id);
        
    } 

        
   
    
}