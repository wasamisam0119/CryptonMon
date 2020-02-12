<template>

<b-row>
      <b-col class="action-container text-center">
        <h4>Buy a random Viper</h4>
        <img :src="unknownViperImg" class="unknown-viper">
        <b-button type="button" v-on:click="buyViper()">Buy</b-button>
        <p>Each Viper costs 0.02 Ether</p>
      </b-col>
      <b-col cols="2" class="middle-container">
        <img v-if="isLoading" src="https://media.giphy.com/media/2A6xoqXc9qML9gzBUE/giphy.gif">
        <h3 v-if="!isLoading">or</h3>
      </b-col>
      <b-col class="action-container">
        <h4>Breed two of the Vipers you own to make a new one!</h4>
        <b-form>
          <b-form-group id="matron"
                        label="Matron ID:"
                        label-for="matron">
            <b-form-input id="matron"
                          v-model="matron"
                          required
                          placeholder="Enter Matron ID">
            </b-form-input>
          </b-form-group>
          <b-form-group id="sire"
                        label="Sire ID:"
                        label-for="sire">
            <b-form-input id="sire"
                          v-model="sire"
                          required
                          placeholder="Enter Sire ID">
            </b-form-input>
          </b-form-group>
          <b-button v-on:click="breedVipers" type="button">Breed Vipers</b-button>
          <p>Breeding Vipers cost 0.05 Ether</p>
        </b-form>
      </b-col>
    </b-row>

    
    <h2 class="mb-5">Owned Vipers</h2>

    <b-row v-if="myCards.length == 0">
      <b-col>
        <h2>No Vipers owned yet!</h2>
      </b-col>
    </b-row>

    <!-- <b-row v-for="i in Math.ceil(myCards.length / 3)" v-bind:key="i">
      <b-col cols="4" v-for="item in myCards.slice((i - 1) * 3, i * 3)"
             v-bind:item="item"
             v-bind:key="item.id">
        <b-card style="height:400px;" class="mb-2">
          <b-img thumbnail fluid :src="item.url" class="image"/>
          <p class="card-text mt-2 text-center">
            <b>ID:</b> {{ item.id }}
            <br>
            <b>Origin:</b>
            <span v-if="item.matron == 0 && item.sire == 0">Bought</span>
            <span v-else>{{ item.matron }} & {{ item.sire }}</span>
          </p>
        </b-card>
      </b-col>
    </b-row>  -->

  </template>>

  <script>
//export default {};
</script>
