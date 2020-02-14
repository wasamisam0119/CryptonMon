<template>
  <b-container class="mb-5">
    <b-row class="header-row">
      <b-col>
        <h1 class="basil--text">CryptoMons</h1>
      </b-col>
    </b-row>
    <v-app>
      <v-tabs v-model="tab" background-color="transparent" color="basil" grow>
        <v-tab key="tab1">Market</v-tab>
        <v-tab key="tab2">My Account</v-tab>
        <v-tab key="tab3">World</v-tab>
      </v-tabs>

      <v-tabs-items v-model="tab">
        <v-tab-item key="tab1">
          <v-container>
            <v-card
              v-for="token in market_cards
      "
              v-bind:key="token.id"
              class="ma-2 text-left d-inline-block"
              width="300"
              outlined
            >
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="headline mb-1">{{names[token.genes-1]}}</v-list-item-title>
                  <div class="body-2">
                    <v-row no-gutters>
                      <v-col class="ma-1">ID {{token.id}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">HP {{token.HP}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">Attack {{token.ATK}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">Price {{token.price}}</v-col>
                    </v-row>
                  </div>
                </v-list-item-content>

                <v-list-item-avatar tile size="90" color="white">
                  <v-img v-bind:src="require('./assets/sprites/large/'+token.url + '.png')"></v-img>
                </v-list-item-avatar>
                <v-card-actions>
                  <b-btn
                    text
                    v-on:click.stop="buyDialog = true; buyToken = token; price = buyToken.price"
                    variant="primary"
                  >Buy</b-btn>
                </v-card-actions>
              </v-list-item>

              <v-dialog v-model="buyDialog" max-width="350" background-color="white">
                <v-card>
                  <v-card-title class="headline">Buy</v-card-title>
                  <v-card-text>Are you sure to buy it with {{price}} ether?</v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      color="green darken-1"
                      text
                      @click="buyDialog = false; buyCard(buyToken.id,buyToken.price)"
                    >OK</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
              <v-dialog v-model="buyAlert" max-width="350" background-color="white">
                <v-card>
                  <v-card-title class="headline">Alert</v-card-title>
                  <v-card-text>"Cheeky! You'd better not buy card from yourself"</v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="green darken-1" text @click="buyAlert= false">OK</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
              <!-- "require('assets/Viper/'+token.id+'.png')" -->
            </v-card>
          </v-container>
        </v-tab-item>

        <v-tab-item key="tab2">
          <v-card>
            <v-card>
              <v-card-title class="headline mb-1">My Account</v-card-title>
              <v-divider></v-divider>
            </v-card>
            <b-container>
              <b-row no-gutters>
                <b-col>
                  <b-list-group>
                    <b-list-group-item active>Address</b-list-group-item>
                    <b-list-group-item active>{{account}}</b-list-group-item>
                  </b-list-group>
                </b-col>
                <b-col>
                  <b-list-group>
                    <b-list-group-item active>Balance</b-list-group-item>
                    <b-list-group-item active>{{balance}}</b-list-group-item>
                  </b-list-group>
                </b-col>
              </b-row>
            </b-container>

            <b-container>
              <b-row>
                <b-col class="action-container">
                  <h4>Breed two of the Pokemons you own to make a new one!</h4>
                  <b-form>
                    <b-form-group id="matron" label="Matron ID:" label-for="matron">
                      <b-form-input
                        id="matron"
                        v-model="matron"
                        required
                        placeholder="Enter Matron ID"
                      ></b-form-input>
                    </b-form-group>
                    <b-form-group id="sire" label="Sire ID:" label-for="sire">
                      <b-form-input id="sire" v-model="sire" required placeholder="Enter Sire ID"></b-form-input>
                    </b-form-group>
                    <b-button
                      v-on:click="breedKid()"
                      type="button"
                      variant="success"
                    >Breed Your Pokemon</b-button>
                    <p>Breeding Pokemon cost 0.05 Ether</p>
                  </b-form>
                </b-col>
              </b-row>
              <b-row>
                <v-dialog v-model="breedDialog" max-width="350" background-color="white">
                  <v-card>
                    <v-card-title class="headline">Breed</v-card-title>
                    <v-card-text>{{alertmessage}}</v-card-text>
                    <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn color="green darken-1" text @click="breedDialog = false">OK</v-btn>
                    </v-card-actions>
                  </v-card>
                </v-dialog>
              </b-row>
            </b-container>

            <h2 class="mb-5">Owned Pokemon</h2>
            <b-row v-if="myCards.length == 0">
              <b-col>
                <h2>No Pokemon owned yet!</h2>
              </b-col>
            </b-row>

            <v-container>
              <v-card
                v-for="token in myCards"
                v-bind:key="token.id"
                class="ma-2 text-left d-inline-block"
                width="290"
                outlined
              >
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title class="headline mb-1">{{token.gene}}</v-list-item-title>
                    <div class="body-2">
                      <!-- <v-chip v-if="token.onBreeding" x-small color="green white--text" label>BREED</v-chip>      -->
                      <v-chip v-if="token.onMarket" x-small color="purple white--text" label>MARKET</v-chip>
                      <v-chip
                        v-if="!token.onMarket && !token.onBreeding"
                        x-small
                        color="white"
                        outlined
                      ></v-chip>
                      <v-row no-gutters>
                        <v-col class="ma-1">ID {{token.id}}</v-col>
                      </v-row>
                      <v-row no-gutters>
                        <v-col class="ma-1">❤️ {{token.HP}}</v-col>
                      </v-row>
                      <v-row no-gutters>
                        <v-col class="ma-1">⚔️ {{token.ATK}}</v-col>
                      </v-row>
                    </div>
                  </v-list-item-content>

                  <v-list-item-avatar tile size="90" color="white">
                    <v-img v-bind:src="require('./assets/sprites/large/'+token.url + '.png')"></v-img>
                  </v-list-item-avatar>
                  <v-card-actions>
                    <b-btn
                      v-if="!token.onMarket"
                      text
                      v-on:click.stop="sellDialog = true; sellToken = token"
                    >Sell</b-btn>
                    <b-btn v-if="token.onMarket" text v-on:click="takeOff(token)">Take off</b-btn>

                    <b-btn
                      :disabled="token.onMarket"
                      text
                      v-on:click.stop="giveDialog = true; giveToken = token"
                      variant="warning"
                    >Give</b-btn>

                    <b-btn
                      :disabled="token.onMarket"
                      text
                      v-on:click="fightDialog= true; fightToken= token"
                      variant="danger"
                    >Fight</b-btn>
                  </v-card-actions>
                </v-list-item>                
              </v-card>

              <v-dialog v-model="sellDialog" max-width="290">
                <v-card v-if="sellToken != null">
                  <v-card-title class="headline">Sell id: {{sellToken.id}}</v-card-title>
                  <v-text-field
                    v-model="sellPrice"
                    tile
                    outlined
                    label="amount (ether)"
                    type="number"
                    class="mx-2"
                  ></v-text-field>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      outlined
                      color="green darken-1"
                      @click="sellDialog = false; sell(sellToken,sellPrice)"
                    >Sell</v-btn>
                    <v-btn outlined color="error" @click="sellDialog = false">Cancel</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>

              <v-dialog v-model="giveDialog" max-width="300" max-height="300">
                <v-card v-if="giveToken != null">
                  <v-card-title class="headline">Give</v-card-title>
                  <v-text-field
                    v-model="giveAddress"
                    tile
                    outlined
                    label="Address(hash)"
                    type="string"
                    class="mx-2"
                  ></v-text-field>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      outlined
                      color="green darken-1"
                      @click="giveDialog = false; give(giveToken,giveAddress)"
                    >Give</v-btn>
                    <v-btn outlined color="error" @click="sellDialog = false">Cancel</v-btn>
                  </v-card-actions>
                </v-card>

                <!-- Fight diglog section -->
                <!-- Fight diglog section -->
                <!-- Fight diglog section -->
              </v-dialog>
              <v-dialog v-model="fightDialog" width="300px" height="300px">
                <v-card v-if="fightToken != null">
                  <v-card-title class="headline">Fight</v-card-title>
                  <v-text-field
                    v-model="defendToken"
                    tile
                    outlined
                    label="Which you want to fight(id)?"
                    type="number"
                    class="mx-2"
                  ></v-text-field>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      outlined
                      color="green darken-1"
                      @click="giveDialog = false; fight(fightToken.id,defendToken)"
                    >Fight</v-btn>
                    <v-btn outlined color="error" @click="fightDialog = false">Cancel</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
              <!-- Fight alert -->
              <v-dialog v-model="fightAlert" max-width="350" background-color="white">
                <v-card v-if="fightToken != null">
                  <v-card-title>Alert</v-card-title>
                  <v-card-text>{{alertmessage}}</v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="green darken-1" text @click="fightAlert= false">OK</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>

              <v-dialog v-model="fightResultDig" max-width="300" background-color="white">
                <v-card>
                  <v-card-title class="headline">You {{fightRes}}!</v-card-title>
                  <v-card-text
                    v-if="fightResultDig"
                  >You earned {{HP}} HP for your {{names[fightToken.genes-1]}}!</v-card-text>
                  <v-img
                    v-if="fightToken!=null"
                    v-bind:src="require('./assets/sprites/large/'+fightToken.url + '.png')"
                  ></v-img>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="green darken-1" text @click="fightResultDig= false">OK</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-container>
          </v-card>
        </v-tab-item>

        <v-tab-item key="tab3">
          <v-container>
            <v-card
              v-for="token in allcards
      "
              v-bind:key="token.id"
              class="ma-2 text-left d-inline-block"
              width="300"
              outlined
            >
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title class="headline mb-1">{{names[token.genes-1]}}</v-list-item-title>
                  <div class="body-2">
                    <v-row no-gutters>
                      <v-col class="ma-1">ID {{token.id}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">❤️ {{token.HP}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">⚔️ {{token.ATK}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">Father {{token.sire}}</v-col>
                    </v-row>
                    <v-row no-gutters>
                      <v-col class="ma-1">Mother {{token.matron}}</v-col>
                    </v-row>
                  </div>
                </v-list-item-content>

                <v-list-item-avatar tile size="90" color="white">
                  <v-img v-bind:src="require('./assets/sprites/large/'+token.url + '.png')"></v-img>
                </v-list-item-avatar>
              </v-list-item>              
            </v-card>
          </v-container>
        </v-tab-item>
      </v-tabs-items>
      <!-- transaction receipt -->
      <!-- transaction receipt -->
      <!-- transaction receipt -->
      <!-- transaction receipt -->
      <!-- transaction receipt -->
      <v-snackbar v-model="receipt" color="success" :timeout="0">
        <span>Transaction confirmed: {{tx['transactionHash']}}</span>
        <v-btn outlined color="error" @click="receipt = false">Close</v-btn>
      </v-snackbar>
    </v-app>
  </b-container>
</template>

<style>
/* Helper classes */
.basil {
  background-color: white;
  /* #FFFBE6 !important; */
}
.basil--text {
  color: #356859 !important;
}
</style>

<script>
import getWeb3 from "../contracts/web3";
import contractAbi from "../contracts/abi";

const contractAddress = "0x57aD602ACaA1D0560dD1394F78E5bf54A8505cf4";

export default {
  name: "App",
  computed: {},
  data() {
    return {
      names: [
        "Bulbasaur",
        "Ivysaur",
        "Venusaur",
        "Charmander",
        "Charmeleon",
        "Charizard",
        "Squirtle",
        "Wartortle",
        "Blastoise",
        "Caterpie",
        "Metapod",
        "Butterfree",
        "Weedle",
        "Kakuna",
        "Beedrill",
        "Pidgey",
        "Pidgeotto",
        "Pidgeot",
        "Rattata",
        "Raticate",
        "Spearow",
        "Fearow",
        "Ekans",
        "Arbok",
        "Pikachu",
        "Raichu",
        "Sandshrew",
        "Sandslash",
        "Nidoran♀",
        "Nidorina",
        "Nidoqueen",
        "Nidoran♂",
        "Nidorino",
        "Nidoking",
        "Clefairy",
        "Clefable",
        "Vulpix",
        "Ninetales",
        "Jigglypuff",
        "Wigglytuff",
        "Zubat",
        "Golbat",
        "Oddish",
        "Gloom",
        "Vileplume",
        "Paras",
        "Parasect",
        "Venonat",
        "Venomoth",
        "Diglett",
        "Dugtrio",
        "Meowth",
        "Persian",
        "Psyduck",
        "Golduck",
        "Mankey",
        "Primeape",
        "Growlithe",
        "Arcanine",
        "Poliwag",
        "Poliwhirl",
        "Poliwrath",
        "Abra",
        "Kadabra",
        "Alakazam",
        "Machop",
        "Machoke",
        "Machamp",
        "Bellsprout",
        "Weepinbell",
        "Victreebel",
        "Tentacool",
        "Tentacruel",
        "Geodude",
        "Graveler",
        "Golem",
        "Ponyta",
        "Rapidash",
        "Slowpoke",
        "Slowbro",
        "Magnemite",
        "Magneton",
        "Farfetch'd",
        "Doduo",
        "Dodrio",
        "Seel",
        "Dewgong",
        "Grimer",
        "Muk",
        "Shellder",
        "Cloyster",
        "Gastly",
        "Haunter",
        "Gengar",
        "Onix",
        "Drowzee",
        "Hypno",
        "Krabby",
        "Kingler",
        "Voltorb",
        "Electrode",
        "Exeggcute",
        "Exeggutor",
        "Cubone",
        "Marowak",
        "Hitmonlee",
        "Hitmonchan",
        "Lickitung",
        "Koffing",
        "Weezing",
        "Rhyhorn",
        "Rhydon",
        "Chansey",
        "Tangela",
        "Kangaskhan",
        "Horsea",
        "Seadra",
        "Goldeen",
        "Seaking",
        "Staryu",
        "Starmie",
        "Mr. Mime",
        "Scyther",
        "Jynx",
        "Electabuzz",
        "Magmar",
        "Pinsir",
        "Tauros",
        "Magikarp",
        "Gyarados",
        "Lapras",
        "Ditto",
        "Eevee",
        "Vaporeon",
        "Jolteon",
        "Flareon",
        "Porygon",
        "Omanyte",
        "Omastar",
        "Kabuto",
        "Kabutops",
        "Aerodactyl",
        "Snorlax",
        "Articuno",
        "Zapdos",
        "Moltres",
        "Dratini",
        "Dragonair",
        "Dragonite",
        "Mewtwo",
        "Mew"
      ],
      tab: null,
      card: null,
      tx: { transactionHash: "0" },
      receipt: false,
      totalSupply: 0,
      market_cards: [],
      buyToken: null,
      buyDialog: false,
      price: null,
      buyAlert: false,
      giveAddress: null,
      giveDialog: false,

      fightDialog: false,
      fightToken: null,
      defendToken: null,
      fightAlert: false,
      fightRes: "",
      HP: null,
      fightResultDig: false,

      sellPrice: null,
      sellDialog: false,
      breedDialog: false,
      alertmessage: "",

      sellToken: null,
      web3: null,
      account: null,
      balance: null,
      crt: null,
      gene: null,
      matron: null,
      sire: null,
      url: 1,
      myCards: [],
      allcards: [],
      isLoading: false
    };
  },
  mounted() {
    getWeb3().then(res => {
      this.web3 = res;
      this.crt = new this.web3.eth.Contract(contractAbi, contractAddress);
      this.web3.eth.getAccounts().then(accounts => {
        [this.account] = accounts;
        //console.log(this.account);
        this.web3.eth.getBalance(this.account).then(res => {
          this.balance = web3.fromWei(res, "ether");
        });
        this.getMyCard();
        this.getTotalSupply();
        this.getMarketCard();
        this.getallCard();
      });
    });
  },

  methods: {
    isOnMarket() {
      return this.crt.methods.onMarket();
    },
    accountToken() {
      return this.myCards;
    },
    account() {
      return this.account;
    },
    getBalance() {
      this.web3.eth.getBalance(this.account).then(res => {
        this.balance = web3.fromWei(res, "ether");
      });
    },
    getTotalSupply() {
      this.crt.methods
        .totalSupply()
        .call({ from: this.account })
        .then(res => {
          this.totalSupply = res;
        });
    },

    fight(atk_id, def_id) {
      this.getTotalSupply();
      if (this.contains(this.myCards, def_id)) {
        this.fightAlert = true;
        this.alertmessage = "Cheeky! You'd better not fight with yourself";
      } else if (def_id > this.totalSupply) {
        this.fightAlert = true;
        this.alertmessage =
          "Oh man, you seemed choose a Pokemon that doesn't exist";
      } else {
        this.crt.methods
          .fight(atk_id, def_id)
          .send({ from: this.account })
          .then(res => {
            this.fightRes = res.events.Fight.returnValues["msg"];
            this.HP = res.events.Fight.returnValues["HP_gain"];
            this.fightResultDig = true;
            this.getMyCard();
          });
      }
    },

    give(giveToken, address) {
      this.crt.methods
        .give(address, giveToken.id)
        .send({ from: this.account })
        .then(receipt => {
          this.tx["transactionHash"] = receipt.transactionHash;
          this.receipt = true;
          this.getMyCard();
        });
    },
    sell(sellToken, sellPrice) {
      this.crt.methods
        .putOnMarket(sellToken.id, sellPrice)
        .send({ from: this.account })
        .then(receipt => {
          sellToken.onMarket = true;

          this.getMarketCard();
        });
    },

    takeOff(token) {
      this.crt.methods
        .takeOffMarket(token.id)
        .send({ from: this.account, value: web3.toWei(0.0001, "ether") })
        .then(receipt => {
          token.onMarket = false;
          this.getMarketCard();
        });
    },

    buyCard(id, price) {
      this.isLoading = true;
      if (this.contains(this.myCards, id)) {
        this.isLoading = false;
        this.buyAlert = true;
      } else {
        this.crt.methods
          .buyCard(id, price)
          .send({
            from: this.account,
            value: web3.toWei(price, "ether")
          })
          .then(receipt => {            
            this.getMyCard();
            this.getBalance();
            this.getMarketCard();
            this.isLoading = false;
          })
          .catch(err => {
            console.log(err, "err");
            this.isLoading = false;
          });
      }
    },

    contains(cards, id) {
      for (var i = 0; i < cards.length; i++) {
        if (id == cards[i].id) {
          return true;
        }
      }
      return false;
    },
    breedKid() {
      this.isLoading = true;
      if (
        this.contains(this.myCards, this.matron) &&
        this.contains(this.myCards, this.sire)
      ) {
        this.crt.methods
          .breedKid(this.matron, this.sire)
          .send({
            from: this.account,
            value: web3.toWei(0.05, "ether")
          })
          .then(receipt => {
            //this.updateCardFromReceipt(receipt);
            this.getMyCard();
            this.getBalance();
            this.getallCard();
            this.isLoading = false;
          })
          .catch(err => {
            console.log(err, "err");
            this.isLoading = false;
          });
      } else {
        this.isLoading = false;
        this.alertmessage = "You should use your own pokemon!";
        this.breedDialog = true;
      }
    },
    async getallCard() {
      this.isLoading = true;
      this.allcards.length = 0;
      const receipt = await this.crt.methods
        .totalSupply()
        .call({ from: this.account });
      console.log("Recipt is " + receipt);
      for (let i = 1; i < receipt; i += 1) {
        if (receipt == 0) {
          continue;
        }
        let card = await this.crt.methods
          .getCardDetails(i)
          .call({ from: this.account });

        this.allcards.push({
          id: card[0],
          genes: card[1],
          matron: card[2],
          sire: card[3],
          HP: card[4],
          ATK: card[5],
          url: card[1]
        });
      }
      this.isLoading = false;
    },
    async getMarketCard() {
      this.isLoading = true;
      this.market_cards.length = 0;
      const receipt = await this.crt.methods
        .getMarketCards()
        .call({ from: this.account });

      for (let i = 0; i < receipt.length; i += 1) {
        if (receipt[i] == 0) {
          continue;
        }
        let card = await this.crt.methods
          .getCardDetails(receipt[i])
          .call({ from: this.account });
        let card_price = await this.crt.methods
          .getCardPrice(receipt[i])
          .call({ from: this.account });
        this.market_cards.push({
          id: card[0],
          genes: card[1],
          matron: card[2],
          sire: card[3],
          HP: card[4],
          ATK: card[5],
          url: card[1],
          price: card_price
        });
      }
      this.isLoading = false;
    },
    async getMyCard() {
      this.isLoading = true;
      this.myCards.length = 0;
      const receipt = await this.crt.methods
        .getMyCard()
        .call({ from: this.account });

      for (let i = 0; i < receipt.length; i += 1) {
        let card = await this.crt.methods
          .getCardDetails(receipt[i])
          .call({ from: this.account });

        let card_on_market = await this.crt.methods
          .onMarket(receipt[i])
          .call({ from: this.account });

        this.myCards.push({
          id: card[0],
          genes: card[1],
          matron: card[2],
          sire: card[3],
          HP: card[4],
          ATK: card[5],
          url: card[1],
          onMarket: card_on_market
        });
      }
      console.log(this.myCards);
      this.isLoading = false;
    },    

    // updateCardFromReceipt(receipt) {

    //   this.myCards.push({
    //     id: receipt.events.Birth.returnValues.id,
    //     genes: receipt.events.Birth.returnValues.genes,
    //     matron: receipt.events.Birth.returnValues.matronId,
    //     sire: receipt.events.Birth.returnValues.sireId,
    //     HP: receipt.events.Birth.returnValues.HP,
    //     ATK: receipt.events.Birth.returnValues.ATK,
    //     url: cardsMap[receipt.events.Birth.returnValues.genes],
    //     onMarket: receipt.events.Birth.returnValues.sireId
    //   });
    // }
  }
};
</script>

<style lang="css">
@import url("https://fonts.googleapis.com/css?family=Poppins:400,500");

* {
  font-family: "Poppins", sans-serif;
}
button {
  width: 100%;
}
.header-row {
  text-align: center;
  margin: 30px 0;
}
.action-container h4 {
  text-align: center;
  margin-bottom: 30px;
}
.action-container p {
  text-align: center;
  margin-top: 10px;
}
.middle-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
.middle-container img {
  height: 100px;
}
.unknown-viper {
  height: 180px;
  width: 180px;
  margin: 9px 0;
}
</style>
