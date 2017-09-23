import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import Register from './components/register.vue'
import Element from 'element-ui'
import 'element-ui/lib/theme-default/index.css'
 
Vue.use(Element)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: 'register',
    template: '<Register/>',
    data: {
    },
    components: { App, Register }
  })
})