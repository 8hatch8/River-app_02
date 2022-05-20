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

      <!-- 見出し -->
      <div v-if="item.format === 'heading-1'" class="item-heading heading-1">
        {{ item.text }}
      </div>
      <div v-if="item.format === 'heading-2'" class="item-heading heading-2">
        {{ item.text }}
      </div>
      <div v-if="item.format === 'heading-3'" class="item-heading heading-3">
        {{ item.text }}
      </div>

      <!-- 操作ボタン -->
      <div class="buttons" v-if="mouseOver">
        <!-- アイテム移動 -->
        <div class="button-icon draggable-handle">
          <fa-icon icon="grip-lines" />
        </div>
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
        <!-- コンフィグ -->
        <div class="button-icon">
          <fa-icon icon="ellipsis-h" @click="toggle = !toggle" />
          <div v-if="toggle" class="dropdown-menu">
            <a class="dropdown-item" @click="onClickFormat(item, 'heading-1')">見出し1</a>
            <a class="dropdown-item" @click="onClickFormat(item, 'heading-2')">見出し2</a>
            <a class="dropdown-item" @click="onClickFormat(item, 'heading-3')">見出し3</a>
            <a class="dropdown-item" @click="onClickFormat(item, 'text')">テキスト</a>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  name: "ChatroomItem",
  props: ["item"],
  emits: ["delete", "edit-text", "add-next", "change-format"],
  data() {
    return {
      text: this.item.text,
      mouseOver: false,
      isEditing: false,
      toggle: false,
    };
  },
  methods: {
    // マウスオーバー
    onMouseOver() {
      this.mouseOver = true;
    },
    onMouseLeave() {
      this.mouseOver = false;
      this.toggle = false;
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
    onClickFormat(item, format = "text") {
      if (item.format === format) return;
      this.$emit("change-format", item, format);
    },
  },
};
</script>

<style scoped lang="scss">
.item-wrapper {
  display: flex;
  align-items: center;
  margin: 5px 0;
  padding: 10px;
  &.mouseover {
    background-color: rgba(255, 255, 255, 0.5);
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
  .item-heading {
    font-weight: bold;
    width: 100%;
    &.heading-1 {
      color: #51b392;
      font-size: 2.5rem;
      margin-top: 5px;
      border-bottom: 1px solid #51b392;
    }
    &.heading-2 {
      color: #51b392;
      font-size: 2rem;
    }
    &.heading-3 {
      color: rgb(110, 110, 110);
      font-size: 1.5rem;
      padding-left: 8px;
      border-left: 8px solid rgb(110, 110, 110);
    }
  }
  .buttons {
    display: flex;
    flex-direction: row;
    .button-icon {
      padding: 3px;
      margin-left: 3px;
      border-radius: 5px;
      position: relative;
      cursor: pointer;
      &:hover {
        color: #51b392;
      }
      &.draggable-handle {
        cursor: grab;
      }
      &:active {
        cursor: grabbing;
      }
      .dropdown-menu {
        width: 100px;
        position: absolute;
        right: 0px;
        z-index: 20;
        display: flex;
        flex-direction: column;
        background-color: rgb(240, 240, 240);
        border-radius: 1px;
        .dropdown-item {
          text-align: center;
          padding: 5px 3px;
          border-radius: 1px;
          cursor: pointer;
        }
        :hover {
          background-color: white;
        }
      }
    }
  }
}
</style>
