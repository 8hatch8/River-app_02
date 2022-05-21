<template>
  <div class="login-form">
    <div class="title">
      <h1 class="font font-lg">
        River for <br />
        Online Meeting
      </h1>
    </div>
    <div class="subtitle">
      <h2 class="font-md">ログイン</h2>
      <p class="font-sm">みんなの意見が会議をかえる</p>
    </div>
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
    <p>
      はじめての方は
      <span class="underline" @click="showSignupForm">こちら</span>
    </p>
  </div>
</template>

<script>
import axios from "axios";
import InputBox from "@/components/share/InputBox.vue";
import FormButton from "@/components/share/Button.vue";
import { setItem, apiServer } from "@/mixin/auth";
export default {
  components: { InputBox, FormButton },
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
  methods: {
    showSignupForm() {
      this.$emit("show-signup-form");
    },
    async login() {
      this.error = null;

      try {
        const response = await axios.post(`${apiServer}/auth/sign_in`, {
          email: this.form.email,
          password: this.form.password,
        });

        if (!response) {
          throw new Error("メールアドレスかパスワードが違います");
        }

        if (!this.error) {
          // ローカルストレージに認証情報を保存
          setItem(response);
          // ChatRoomへリダイレクト
          this.$emit("redirect-to-chatroom");
        }

        console.log({ response });
        return response;
      } catch (error) {
        console.log({ error });
        this.error = "メールアドレスかパスワードが違います";
      }
    },
  },
};
</script>

<style scoped>
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
.Button {
  margin: 30px 0;
}
</style>
