import Vue from 'vue'
import VueRouter from 'vue-router'

import App from './App.vue'

import routes from './routes'

Vue.use(VueRouter)

App.router = new VueRouter({
  mode: 'history',
  routes
})

new Vue(App).$mount('#app')
