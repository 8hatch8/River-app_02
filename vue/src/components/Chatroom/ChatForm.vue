<template>
  <div class="chatform-wrapper">
    <form>
      <textarea
        name="chat"
        cols="30"
        placeholder="メッセージを入力してshift+Enterで送信してください"
        v-model="text"
        @keypress.enter.shift.prevent="onEnter"
      >
      </textarea>
    </form>
  </div>
</template>

<script>
export default {
  name: "ChatForm",
  emits: ["post"],
  data() {
    return {
      text: "",
    };
  },
  methods: {
    onEnter() {
      if (this.text !== "") {
        this.$emit("post", this.text);
        this.text = "";
      }
    },
  },
};
</script>

<style scoped lang="scss">
.chatform-wrapper {
  width: 100%;
  z-index: 10;
}
textarea {
  resize: none;
  font-size: 1rem;
  width: 100%;
  height: 60px;
  padding: 10px 15px;
  border-radius: 10px;
  outline: none;
  &:focus {
    background: rgb(226, 239, 250);
  }
}
</style>
