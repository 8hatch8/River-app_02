import { createRouter, createWebHistory } from "vue-router";
import Welcome from "@/views/Welcome";
import Chatroom from "@/views/ChatRoom";
import useValidate from "@/mixin/validate";
import { setItem } from "../mixin/auth";

const { error, validate } = useValidate();

// ログインしていなければWelcomeへリダイレクト
const requireAuth = async (to, from, next) => {
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");

  // 認証情報が存在しない場合Welcomeへ
  if (!uid || !client || !accessToken) {
    next({ name: "Welcome" });
    return;
  }

  // 認証情報をRailsAPIで確認し、エラーであればWelcomeへ
  await validate();
  if (error.value) {
    next({ name: "Welcome" });
  } else {
    next();
  }
};

// ログインしていればマイページへリダイレクト
const noRequireAuth = async (to, from, next) => {
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");

  if (!uid && !client && !accessToken) {
    next();
    return;
  }

  await validate();

  if (!error.value) {
    next({ name: "Chatroom" }); // 【TODO】マイページへ変更
  } else {
    next();
  }
};

// OmniAuth
const callbackOmniAuth = async (to, from, next) => {
  const authHeaders = {
    headers: {
      "access-token": to.query.auth_token,
      client: to.query.client_id,
      uid: to.query.uid,
    },
    data: {
      data: {
        nickname: to.query.nickname,
      },
    },
  };
  setItem(authHeaders);
  next("/");
};

// Routeの設定
const routes = [
  {
    path: "/",
    name: "Welcome",
    component: Welcome,
    beforeEnter: noRequireAuth,
  },
  {
    path: "/chatroom",
    name: "Chatroom",
    component: Chatroom,
    beforeEnter: requireAuth,
  },
  {
    path: "/omniauth/:provider/callback",
    name: "Callback",
    component: Chatroom,
    beforeEnter: callbackOmniAuth,
  },
];

// Vue-Routerの設定
const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
