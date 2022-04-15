<template>
  <div class="container welcome">
    <div v-if="shouldShowLoginForm">
      <login-form
        @redirect-to-chatroom="redirectToChatRoom"
        @showSignupForm="shouldShowLoginForm = false"
      />
    </div>
    <div v-if="!shouldShowLoginForm">
      <signup-form
        @redirect-to-chatroom="redirectToChatRoom"
        @showLoginForm="shouldShowLoginForm = true"
      />
    </div>
  </div>
</template>

<script>
import LoginForm from "../components/LoginForm.vue";
import SignupForm from "../components/SignupForm.vue";
export default {
  components: { LoginForm, SignupForm },
  data() {
    return {
      shouldShowLoginForm: true,
    };
  },
  methods: {
    redirectToChatRoom() {
      this.$router.push({ name: "Chatroom" });
    },
  },
};
</script>

<style scoped>
.container {
  width: 90%;
  max-width: 960px;
  margin: 80px auto;
  border-radius: 15px;
  box-shadow: 2px 4px 6px rgba(28, 6, 49, 0.1);
  background: white;
}
</style>
