/*!

=========================================================
* Vue Argon Dashboard - v1.1.1
=========================================================

* Product Page: https://www.creative-tim.com/product/vue-argon-dashboard
* Copyright 2020 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://github.com/creativetimofficial/vue-argon-dashboard/blob/master/LICENSE.md)

* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/
import Vue from 'vue'
import App from '../app.vue'
import router from '../router'
import '../registerServiceWorker'
import ArgonDashboard from '../plugins/argon-dashboard'
import Vuetify from "vuetify"
import "vuetify/dist/vuetify.min.css"

Vue.config.productionTip = false
Vue.use(ArgonDashboard)
Vue.use(Vuetify)
const vuetify = new Vuetify()

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    router,
    vuetify,
    render: h => h(App)
  }).$mount();
  document.body.appendChild(app.$el);

  console.log(app);
});
