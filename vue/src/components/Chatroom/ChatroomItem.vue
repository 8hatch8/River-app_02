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
      <div v-if="item.format === 'text'" class="item item-text">
        <!-- アイコン -->
        <div class="icon fa-2x">
          <fa-icon icon="user" />
        </div>
        <div class="body">
          <div class="head">{{ item.user_name }}</div>
          <!-- テキスト -->
          <div class="text">{{ item.text }}</div>
        </div>
      </div>

      <!-- type:コメント -->
      <div v-if="item.format === 'comment'" class="item item-comment">
        <!-- アイコン -->
        <div class="icon fa-2x">
          <fa-icon icon="user" />
        </div>
        <div class="body">
          <div class="head">{{ item.user_name }}</div>
          <!-- テキスト -->
          <div class="text">{{ item.text }}</div>
        </div>
      </div>

      <!-- type:見出し -->
      <div v-if="item.format === 'heading-1'" class="item item-heading heading-1">
        {{ item.text }}
      </div>
      <div v-if="item.format === 'heading-2'" class="item item-heading heading-2">
        {{ item.text }}
      </div>
      <div v-if="item.format === 'heading-3'" class="item item-heading heading-3">
        {{ item.text }}
      </div>
      <!-- type:リスト -->
      <div v-if="item.format === 'list'" class="item item-list">
        {{ "● " + item.text }}
      </div>
      <!-- type:チェックボックス -->
      <div v-if="item.format === 'check-false'" class="item item-check false">
        <fa-icon icon="minus-square" class="check-box" @click="onClickFormat(item, 'check-true')" />
        <div class="text">{{ item.text }}</div>
      </div>
      <div v-if="item.format === 'check-true'" class="item item-check true">
        <fa-icon
          icon="check-square"
          class="check-box"
          @click="onClickFormat(item, 'check-false')"
        />
        <div class="text">{{ item.text }}</div>
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
            <a class="dropdown-item" @click="onClickFormat(item, 'comment')">コメント</a>
            <a class="dropdown-item" @click="onClickFormat(item, 'list')">リスト</a>
            <a class="dropdown-item" @click="onClickFormat(item, 'check-false')">チェックリスト</a>
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
$river-green: #51b392;
.item-wrapper {
  color: #444;
  display: flex;
  align-items: center;
  margin: 3px 0;
  padding: 8px;
  position: relative;
  &.mouseover {
    background-color: rgba(255, 255, 255, 0.5);
  }
  .input-box {
    font-size: 1.2rem;
  }
  .item {
    width: 100%;
  }
  .item-text {
    display: flex;
    margin-left: 20px;
    .icon {
      width: 50px;
      height: 50px;
      padding: 2px 0 0 5px;
    }
    .body {
      width: 100%;
      display: block;
      .head {
        font-size: 0.8rem;
        font-weight: bold;
        padding: 3px 0;
      }
      .text {
        font-size: 1rem;
      }
    }
  }
  .item-comment {
    display: flex;
    margin-left: 37px;
    border-left: 4px dotted #666;
    padding-left: 15px;

    color: #666;
    .icon {
      width: 50px;
      height: 50px;
      padding: 2px 0 0 3px;
    }
    .body {
      display: block;
      width: 100%;
      .head {
        font-size: 0.8rem;
        font-weight: bold;
        padding: 3px 0;
      }
      .text {
        font-size: 1rem;
      }
    }
  }

  .item-heading {
    font-weight: bold;
    &.heading-1 {
      color: $river-green;
      font-size: 2.5rem;
      margin-top: 5px;
      border-bottom: 1px solid $river-green;
    }
    &.heading-2 {
      color: $river-green;
      font-size: 2rem;
      margin-left: 15px;
    }
    &.heading-3 {
      color: rgb(110, 110, 110);
      font-size: 1.5rem;
      margin-left: 23px;
      padding-left: 8px;
      border-left: 8px solid rgb(110, 110, 110);
    }
  }
  .item-list {
    font-size: 1rem;
    margin-left: 22px;
  }
  .item-check {
    font-size: 1rem;
    display: flex;
    margin-left: 20px;
    &.false {
      color: $river-green;
    }
    &.true {
      color: #888;
      .text {
        text-decoration: line-through;
      }
    }
    .check-box {
      padding-top: 2px;
      font-size: 1.4rem;
      cursor: pointer;
    }
    .text {
      padding-left: 7px;
    }
  }
  .buttons {
    z-index: 20;
    display: flex;
    flex-direction: row;
    position: absolute;
    top: 5px;
    right: 10px;
    .button-icon {
      padding: 3px;
      margin-left: 3px;
      border-radius: 5px;
      position: relative;
      cursor: pointer;
      &:hover {
        color: $river-green;
      }
      &.draggable-handle {
        cursor: grab;
      }
      &:active {
        cursor: grabbing;
      }
      .dropdown-menu {
        font-size: 0.8rem;
        width: 120px;
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
