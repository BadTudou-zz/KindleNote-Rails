import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import Login from './components/login.vue'
import Element from 'element-ui'
import 'element-ui/lib/theme-default/index.css'
 
Vue.use(Element)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: 'login',
    template: '<Login/>',
    components: { App, Login }
  })
})