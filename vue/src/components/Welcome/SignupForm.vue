<template>
  <div class="signup-form">
    <div class="title">
      <h1 class="font font-lg">
        River for <br />
        Online Meeting
      </h1>
    </div>
    <div class="subtitle">
      <h2 class="font-md">新規登録</h2>
      <p class="font-sm">みんなの意見が会議をかえる</p>
    </div>
    <form class="Form" @submit.prevent="signUp">
      <input-box
        id="nickname"
        label="お名前"
        name="nickname"
        type="text"
        placeholder="お名前"
        :required="true"
        :value="form.nickname"
        @input="form.nickname = $event.target.value"
      />
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
      <input-box
        id="password-confirmation"
        label="パスワード（確認用）"
        name="password_confirmation"
        type="password"
        placeholder="もう一度ご入力ください"
        :required="true"
        :value="form.passwordConfirmation"
        @input="form.passwordConfirmation = $event.target.value"
      />
      <div class="error">{{ error }}</div>
      <form-button label="登録する" />
    </form>
    <p>
      登録済みの方は
      <span class="underline" @click="showLoginForm">こちら</span>
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
  emits: ["show-login-form", "redirect-to-chatroom"],
  data() {
    return {
      form: {
        nickname: "",
        email: "",
        password: "",
        passwordConfirmation: "",
      },
      error: null,
    };
  },
  methods: {
    showLoginForm() {
      this.$emit("show-login-form");
    },
    async signUp() {
      this.error = null;
      try {
        const response = await axios.post(`${apiServer}/auth`, {
          nickname: this.form.nickname,
          email: this.form.email,
          password: this.form.password,
          password_confirmation: this.form.passwordConfirmation,
        });

        if (!response) {
          throw new Error("アカウントを登録できませんでした");
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
        this.error = "アカウントを登録できませんでした";
      }
    },
  },
};
</script>

<style scoped>
.signup-form {
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
  margin-top: 30px;
  margin-bottom: -10px;
}
.Button {
  margin: 30px 0;
}
</style>
