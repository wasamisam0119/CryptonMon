<template>
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
                <v-col class="ma-1">HP {{token.HP}}</v-col>
              </v-row>
              <v-row no-gutters>
                <v-col class="ma-1">Attack {{token.ATK}}</v-col>
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

       
        <!-- "require('assets/Viper/'+token.id+'.png')" -->
      </v-card>
      </v-container>
      </v-tab-item>
</template>