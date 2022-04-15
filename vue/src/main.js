import { createApp } from "vue";
import App from "./App.vue";
import router from "./router/router";
import store from "./store/store";
import "./assets/main.scss";

createApp(App).use(store).use(router).mount("#app");
