<template>
  <div
    class="chatform-wrapper"
    @focusin="focus = true"
    @focusout="focus = false"
    @mouseover="mouseOver = true"
    @mouseleave="mouseOver = false"
  >
    <div v-if="focus || mouseOver" class="menu-bar">
      <a class="menu-item" :class="{ selected: format === 'text' }" @click="format = 'text'"
        >テキスト</a
      >
      <a class="menu-item" :class="{ selected: format === 'list' }" @click="format = 'list'"
        >リスト</a
      >
      <a
        class="menu-item"
        :class="{ selected: format === 'check-false' }"
        @click="format = 'check-false'"
        >チェックリスト</a
      >
      <a
        class="menu-item"
        :class="{ selected: format === 'heading-1' }"
        @click="format = 'heading-1'"
        >見出し1</a
      >
      <a
        class="menu-item"
        :class="{ selected: format === 'heading-2' }"
        @click="format = 'heading-2'"
        >見出し2</a
      >
      <a
        class="menu-item"
        :class="{ selected: format === 'heading-3' }"
        @click="format = 'heading-3'"
        >見出し3</a
      >
    </div>
    <form class="form">
      <!-- ダミーの大きさにあわせてテキストエリアが自動で拡大 -->
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
      mouseOver: false,
      focus: false,
      format: "text",
    };
  },
  methods: {
    onEnter() {
      if (this.text !== "") {
        this.$emit("post", this.text, this.format);
        this.text = "";
      }
    },
  },
};
</script>

<style scoped lang="scss">
.chatform-wrapper {
  z-index: 10;
  position: relative;
  .menu-bar {
    z-index: 20;
    position: absolute;
    top: -30px;
    left: 0;
    display: inline-block;
    height: 20px;
    font-size: 0.8rem;
    background-color: rgb(240, 240, 240);
    border-radius: 1px;
    .menu-item {
      display: inline-block;
      text-align: center;
      padding: 5px 10px;
      border-radius: 1px;
      background-color: rgb(231, 231, 231);
      cursor: pointer;
      &.selected {
        background-color: white;
      }
    }
    :hover {
      background-color: rgb(210, 210, 210);
    }
  }
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
