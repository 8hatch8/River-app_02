<template>
  <div
    class="item-wrapper"
    :class="{ mouseover: mouseOver && !isEditing }"
    @mouseover="onMouseOver"
    @mouseleave="onMouseLeave"
  >
    <!-- 編集時 -->
    <template v-if="isEditing">
      <input
        v-model="text"
        ref="editBox"
        class="input-box"
        onfocus="this.select()"
        @keypress.enter="onKeypressEnter"
        @blur="onEditEnd(item)"
      />
    </template>

    <template v-else>
      <!-- type:テキスト -->
      <div v-if="item.format === 'text' && isEditing === false" class="item-text">
        <!-- アイコン -->
        <div class="icon">
          <div><fa-icon icon="user" /></div>
          <div class="nickname">name</div>
        </div>
        <!-- テキスト -->
        <div class="text">
          {{ item.text }}
        </div>
      </div>

      <!-- 操作ボタン -->
      <div class="buttons" v-if="mouseOver">
        <!-- アイテム追加 -->
        <div class="button-icon" @click.stop="onClickAddNext(item)">
          <fa-icon icon="plus-circle" />
        </div>
        <!-- text編集 -->
        <div class="button-icon" @click.stop="onClickEdit">
          <fa-icon icon="edit" />
        </div>
        <!-- アジェンダ削除 -->
        <div class="button-icon" @click.stop="onClickDelete(item)">
          <fa-icon icon="trash" />
        </div>
      </div>
    </template>
  </div>
</template>
<script>
export default {
  name: "ChatroomItem",
  props: ["item"],
  emits: ["delete", "edit-text", "add-next"],
  data() {
    return {
      text: this.item.text,
      mouseOver: false,
      isEditing: false,
    };
  },
  methods: {
    // マウスオーバー
    onMouseOver() {
      this.mouseOver = true;
    },
    onMouseLeave() {
      this.mouseOver = false;
    },
    // 操作メニュー
    onClickDelete(item) {
      this.$emit("delete", item);
    },
    onClickEdit() {
      this.isEditing = true;
      this.$nextTick(() => {
        this.$refs.editBox.focus();
      });
    },
    onKeypressEnter() {
      this.$refs.editBox.blur();
    },
    onEditEnd(item) {
      // 入力フォームを非表示に
      this.isEditing = false;
      // textが空白なら元に戻す
      if (this.text.length === 0) this.text = this.item.text;
      if (this.text === this.item.text) return;
      this.$emit("edit-text", item, this.text);
    },
    onClickAddNext(item) {
      this.$emit("add-next", item);
    },
  },
};
</script>
<style scoped lang="scss">
.item-wrapper {
  display: flex;
  align-items: center;
  padding: 10px 5px;
  &.mouseover {
    background-color: rgb(243, 243, 243);
    cursor: pointer;
  }
  .input-box {
    font-size: 1.2rem;
  }
  .item-text {
    width: 100%;
    display: flex;
    .icon {
      padding-right: 10px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      .nickname {
        font-size: 0.8rem;
      }
    }
    .text {
      font-size: 1.2rem;
      display: flex;
      align-items: center;
    }
  }
  .buttons {
    display: flex;
    flex-direction: row;
    .button-icon {
      padding: 3px;
      margin-left: 3px;
      border-radius: 5px;
    }
  }
}
</style>
