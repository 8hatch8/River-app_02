<template>
  <div class="login-form">
    <div class="title">
      <h1 class="font font-lg">
        River for <br />
        Online Meeting
      </h1>
    </div>
    <div class="subtitle">
      <p class="font-sm">オンライン会議がもっと楽しくなるチャットアプリ</p>
    </div>
    <h2 class="font-md">ログイン</h2>
    <form class="Form" @submit.prevent="login">
      <input-box
        id="email"
        label="メールアドレス"
        name="email"
        type="text"
        placeholder="メールアドレス"
        :required="true"
        :value="form.email"
        @input="form.email = $event.target.value"
      />
      <input-box
        id="password"
        label="パスワード"
        name="password"
        type="password"
        placeholder="パスワード（6文字以上）"
        :required="true"
        :value="form.password"
        @input="form.password = $event.target.value"
      />
      <div class="error">{{ error }}</div>
      <form-button label="ログインする" />
    </form>
    <google-button @click.prevent="loginOmniAuth(googleLoginURL)" />
    <p class="mt-30">新規登録は<span @click="showSignupForm" class="underline">こちら</span></p>
  </div>
</template>

<script>
import axios from "axios";
import InputBox from "@/components/share/InputBox.vue";
import FormButton from "@/components/share/Button.vue";
import GoogleButton from "@/components/share/GoogleButton.vue";
import { setItem, apiServer, appServer } from "@/mixin/auth";
export default {
  components: { InputBox, FormButton, GoogleButton },
  emits: ["show-signup-form", "redirect-to-chatroom"],
  data() {
    return {
      form: {
        email: "",
        password: "",
      },
      error: null,
    };
  },
  computed: {
    googleLoginURL() {
      return `${apiServer}/auth/google_oauth2?auth_origin_url=${encodeURI(
        appServer
      )}/omniauth/google_oauth2/callback`;
    },
  },
  methods: {
    showSignupForm() {
      this.$emit("show-signup-form");
    },
    loginOmniAuth(URL) {
      location.href = URL;
    },
    async login() {
      this.error = null;
      try {
        const response = await axios.post(`${apiServer}/auth/sign_in`, {
          email: this.form.email,
          password: this.form.password,
        });
        // サーバーからレスポンスがない場合
        if (!response) {
          throw new Error("通信に失敗しました");
        }
        // 成功
        if (!this.error) {
          // ローカルストレージに認証情報を保存
          setItem(response);
          this.$emit("redirect-to-chatroom");
        }
        return response;
        // 失敗
      } catch (error) {
        console.log({ error });
        this.error = "メールアドレスかパスワードが違います";
      }
    },
  },
};
</script>

<style scoped lang="scss">
.mt-30 {
  margin-top: 30px;
}
.login-form {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: center;
  text-align: center;
  margin: auto;
  padding: 30px;
}
.title,
.subtitle {
  padding: 10px 0;
}
.Form {
  width: 80%;
  max-width: 400px;
}
.error {
  margin-top: 15px;
  margin-bottom: -10px;
}
.Button {
  width: 200px;
  margin: 30px 0;
}
</style>
