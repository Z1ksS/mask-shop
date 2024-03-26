import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

function scaling() {
  let defaultHeight = 1080;
  let currentHeight = window.innerHeight;
  let scaleCoefficient = currentHeight / defaultHeight;
  document.documentElement.style.setProperty('--scale-coefficient', scaleCoefficient);
}

window.onload = () => {
  scaling();
}
window.onresize = () => {
  scaling();
}

new Vue({
  render: h => h(App),
}).$mount('#app')
