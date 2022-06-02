<template>
  <div
    class="item-wrapper"
    :class="{ mouseover: mouseOver && !isEditing, selected: isSelected }"
    @mouseover="onMouseOver"
    @mouseleave="onMouseLeave"
    @dblclick="onClickEdit"
    @click="if (isHeading && !isEditing) onClickItem(item);"
  >
    <!-- ドラッグハンドル -->
    <div v-if="mouseOver && !isEditing && !isDragging" class="draggable-handle">
      <fa-icon icon="grip-vertical" />
    </div>
    <!-- 選択中 -->
    <div v-if="isSelected && !isEditing" class="selected-checkmark">
      <fa-icon icon="check" />
    </div>

    <!-- type:テキスト -->
    <div v-if="item.format === 'text'" class="item item-text">
      <!-- アイコン -->
      <div class="icon fa-2x">
        <fa-icon icon="user" />
      </div>
      <div class="body">
        <div class="head">{{ item.user_name }}</div>
        <!-- テキスト -->
        <div v-if="!isEditing" class="text">{{ item.text }}</div>
        <!-- 編集時 -->
        <div v-else>
          <text-area
            class="text-area text"
            :value="item.text"
            :autofocus="true"
            @blur="onEditEnd"
          />
        </div>
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
        <div v-if="!isEditing" class="text">{{ item.text }}</div>
        <!-- 編集時 -->
        <div v-else>
          <text-area
            class="text-area text"
            :value="item.text"
            :autofocus="true"
            @blur="onEditEnd"
          />
        </div>
      </div>
    </div>

    <!-- type:見出し-1 -->
    <div
      v-if="item.format === 'heading-1'"
      class="item item-heading heading-1"
      :class="{ selected: isSelected }"
    >
      <div v-if="!isEditing">{{ item.text }}</div>
      <!-- 編集時 -->
      <div v-else>
        <text-area class="text-area text" :value="item.text" :autofocus="true" @blur="onEditEnd" />
      </div>
    </div>
    <!-- type:見出し-2 -->
    <div
      v-if="item.format === 'heading-2'"
      class="item item-heading heading-2"
      :class="{ selected: isSelected }"
    >
      <div v-if="!isEditing">{{ item.text }}</div>
      <!-- 編集時 -->
      <div v-else>
        <text-area class="text-area text" :value="item.text" :autofocus="true" @blur="onEditEnd" />
      </div>
    </div>
    <!-- type:見出し-3 -->
    <div
      v-if="item.format === 'heading-3'"
      class="item item-heading heading-3"
      :class="{ selected: isSelected }"
    >
      <div v-if="!isEditing">{{ item.text }}</div>
      <!-- 編集時 -->
      <div v-else>
        <text-area class="text-area text" :value="item.text" :autofocus="true" @blur="onEditEnd" />
      </div>
    </div>
    <!-- type:リスト -->
    <div v-if="item.format === 'list'" class="item item-list">
      <fa-icon icon="circle" class="circle fa-sm" />
      <div v-if="!isEditing" class="text">{{ item.text }}</div>
      <!-- 編集時 -->
      <text-area
        v-else
        class="text-area text"
        :value="item.text"
        :autofocus="true"
        @blur="onEditEnd"
      />
    </div>
    <!-- type:チェックボックス -->
    <div v-if="item.format === 'check-false'" class="item item-check false">
      <fa-icon icon="minus-square" class="check-box" @click="onClickFormat(item, 'check-true')" />
      <div v-if="!isEditing" class="text">{{ item.text }}</div>
      <!-- 編集時 -->
      <text-area
        v-else
        class="text-area text"
        :value="item.text"
        :autofocus="true"
        @blur="onEditEnd"
      />
    </div>
    <div v-if="item.format === 'check-true'" class="item item-check true">
      <fa-icon icon="check-square" class="check-box" @click="onClickFormat(item, 'check-false')" />
      <div v-if="!isEditing" class="text">{{ item.text }}</div>
      <!-- 編集時 -->
      <text-area
        v-else
        class="text-area text"
        :value="item.text"
        :autofocus="true"
        @blur="onEditEnd"
      />
    </div>

    <!-- 操作ボタン -->
    <div class="buttons" v-if="mouseOver && !isEditing">
      <!-- アイテム追加 -->
      <div class="button-icon" @click.stop="onClickAddIcon">
        <fa-icon icon="plus-circle" />
        <!-- ドロップダウンメニュー -->
        <div v-if="toggleMenuAddNext" class="dropdown-menu">
          <a class="dropdown-item" @click="onClickAddNext(item, 'heading-1')">見出し1</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'heading-2')">見出し2</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'heading-3')">見出し3</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'text')">テキスト</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'comment')">コメント</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'list')">リスト</a>
          <a class="dropdown-item" @click="onClickAddNext(item, 'check-false')">チェックリスト</a>
        </div>
      </div>
      <!-- テキスト編集 -->
      <div class="button-icon" @click.stop="onClickEdit">
        <fa-icon icon="edit" />
      </div>
      <!-- アイテム削除 -->
      <div class="button-icon" @click.stop="onClickDelete(item)">
        <fa-icon icon="trash" />
      </div>
      <!-- フォーマット変更 -->
      <div class="button-icon">
        <fa-icon icon="ellipsis-h" @click.stop="onClickFormatIcon" />
        <!-- ドロップダウンメニュー -->
        <div v-if="toggleMenuFormat" class="dropdown-menu">
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
  </div>
</template>

<script>
import textArea from "@/components/share/TextArea.vue";
export default {
  components: { textArea },
  name: "ChatroomItem",
  props: ["item", "selected-items", "is-dragging"],
  emits: ["delete", "edit-text", "add-next", "change-format", "select", "unselect"],
  data() {
    return {
      mouseOver: false,
      isEditing: false,
      toggleMenuFormat: false,
      toggleMenuAddNext: false,
    };
  },
  computed: {
    isSelected() {
      return this.selectedItems.find((item) => {
        return item.id === this.item.id;
      });
    },
    isHeading() {
      return (
        this.item.format === "heading-1" ||
        this.item.format === "heading-2" ||
        this.item.format === "heading-3"
      );
    },
    // ドラッグ中のカーソルを変更
    cursorValue() {
      if (this.isDragging) return "grabbing";
      return "default";
    },
  },
  methods: {
    // マウスオーバー
    onMouseOver() {
      this.mouseOver = true;
    },
    onMouseLeave() {
      this.mouseOver = false;
      this.toggleMenuFormat = false;
      this.toggleMenuAddNext = false;
    },
    // 操作メニュー
    onClickItem(item) {
      if (this.isSelected) {
        this.$emit("unselect", item);
      } else {
        this.$emit("select", item);
      }
    },
    onClickDelete(item) {
      this.$emit("delete", item);
    },
    onClickAddIcon() {
      this.toggleMenuAddNext = !this.toggleMenuAddNext;
      this.toggleMenuFormat = false;
    },
    onClickEdit() {
      this.isEditing = true;
    },
    onEditEnd(text) {
      // 入力フォームを非表示に
      this.isEditing = false;
      // textが空白なら元に戻す
      if (text.length === 0) return;
      if (text === this.item.text) return;
      this.$emit("edit-text", this.item, text);
    },
    onClickAddNext(item, format) {
      this.$emit("add-next", item, format);
    },
    onClickFormatIcon() {
      this.toggleMenuFormat = !this.toggleMenuFormat;
      this.toggleMenuAddNext = false;
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
  padding: 8px 18px;
  position: relative;
  cursor: v-bind(cursorValue);
  &.mouseover {
    background-color: rgba(255, 255, 255, 0.5);
  }
  .text-area {
    width: 100%;
    border: none;
    outline: none;
    color: grey;
    background-color: aliceblue;
  }
  .draggable-handle {
    z-index: 20;
    color: #999;
    position: absolute;
    left: 0;
    padding: 5px 5px 5px 10px;
    cursor: grab;
    &:hover {
      color: $river-green;
    }
    &:active {
      cursor: grabbing;
    }
  }
  .selected-checkmark {
    position: absolute;
    top: 1px;
    left: 1px;
    color: $river-green;
  }
  .item {
    width: 100%;
    white-space: pre-wrap;
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
    cursor: pointer;
    &.selected {
      color: $river-green;
    }
    &.heading-1 {
      font-size: 2.5rem;
      margin-top: 5px;
      padding-left: 10px;
      border-bottom: 2px solid;
    }
    &.heading-2 {
      font-size: 2rem;
      margin-left: 15px;
    }
    &.heading-3 {
      color: rgb(110, 110, 110);
      font-size: 1.5rem;
      margin-left: 23px;
      padding-left: 8px;
      border-left: 8px solid;
      &.selected {
        color: $river-green;
      }
    }
  }
  .item-list {
    width: 100%;
    font-size: 1rem;
    display: flex;
    margin-left: 22px;
    .circle {
      color: grey;
      padding: 5px 2px 0 1px;
    }
    .text {
      width: 100%;
      padding-left: 7px;
    }
  }
  .item-check {
    font-size: 1rem;
    display: flex;
    margin-left: 20px;
    &.false {
      .text {
        width: 100%;
      }
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
      width: 100%;
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
      .dropdown-menu {
        font-size: 0.8rem;
        width: 120px;
        position: absolute;
        right: 0px;
        z-index: 30;
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
