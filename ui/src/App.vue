<template>
<div class="app">
  <header-bar></header-bar>
  <article class="container app-page">
    <router-view></router-view>
  </article>
</div>
</template>

<script>
  import './assets/styles/app.scss'
  import 'font-awesome/css/font-awesome.css'

  import HeaderBar from './components/HeaderBar.vue'

  export default {
    components: {HeaderBar}
  }
</script>

<style>
  .app-page {
    padding-top:50px;
  }
</style>
