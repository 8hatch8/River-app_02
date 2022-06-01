<template>
  <div class="chatform-wrapper">
    <form class="form">
      <div class="dummy" aria-hidden="true">{{ text + " " }}</div>
      <textarea
        class="textarea"
        id="chatform"
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
  z-index: 10;
  .form {
    position: relative;
    font-size: 1rem;
    line-height: 1.8;
    .dummy,
    .textarea {
      overflow: hidden;
      padding: 5px 15px;
      white-space: pre-wrap;
      word-wrap: break-word;
      overflow-wrap: break-word;
      &.dummy {
        visibility: hidden;
        min-height: 60px;
        border: 1px solid;
      }
      &.textarea {
        position: absolute;
        top: 0;
        left: 0;
        display: block;
        width: 100%;
        height: 100%;
        border: 1px solid #b6c3c6;
        border-radius: 10px;
        outline: none;
        resize: none;
        &:focus {
          background: rgb(226, 239, 250);
          box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.3);
          outline: 0;
        }
      }
    }
  }
}
</style>
