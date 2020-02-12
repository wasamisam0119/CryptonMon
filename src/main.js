/* eslint-disable no-unused-vars */
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

import App from './App.vue';


Vue.use(BootstrapVue);
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";



Vue.use(Vuetify);
const vm = new Vue({
  transformToRequire: {
    img: 'src',
    image: 'xlink:href',
  },
  //router,
  render: h => h(App),
});
vm.$mount('#app');

//export default vm;
window.ethereum.on('accountsChanged', function (accounts) {
  console.log("You changed your account");
  
});