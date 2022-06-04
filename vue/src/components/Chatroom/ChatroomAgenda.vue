<template>
  <div>
    <div
      class="agenda-wrapper"
      :class="{ mouseover: mouseOver && !isEditing, selected: isSelectedAgenda }"
      @click="onClickAgenda(agenda)"
      @mouseover="onMouseOver"
      @mouseleave="onMouseLeave"
    >
      <!-- 編集時 -->
      <template v-if="isEditing">
        <input
          v-model="name"
          ref="editBox"
          class="input-box agenda-name"
          onfocus="this.select()"
          @keypress.enter="onKeypressEnter"
          @blur="onEditEnd(agenda)"
        />
      </template>

      <!-- 通常時 -->
      <template v-else>
        <div class="agenda-icon"><fa-icon icon="comment" /></div>
        <div class="agenda-name">{{ agenda.name }}</div>

        <!-- 操作ボタン -->
        <div class="buttons" v-if="mouseOver">
          <!-- アジェンダ移動 -->
          <div class="button-icon draggable-handle">
            <fa-icon icon="grip-lines" />
          </div>
          <!-- アジェンダ追加 -->
          <div class="button-icon tooltip" @click.stop="onClickAddNext(agenda)">
            <fa-icon icon="plus-circle" /><span class="balloon balloon-bottom">下に追加</span>
          </div>
          <!-- name編集 -->
          <div class="button-icon tooltip" @click.stop="onClickEdit">
            <fa-icon icon="edit" /><span class="balloon balloon-bottom">編集</span>
          </div>
          <!-- アジェンダ削除 -->
          <div class="button-icon tooltip" @click.stop="onClickDelete(agenda)">
            <fa-icon icon="trash" /><span class="balloon balloon-bottom">削除</span>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
export default {
  name: "ChatroomAgenda",
  props: ["agenda", "selectedAgenda"],
  emits: ["select", "delete", "edit-name", "add-next"],
  data() {
    return {
      name: this.agenda.name,
      mouseOver: false,
      isEditing: false,
    };
  },
  computed: {
    isSelectedAgenda() {
      return this.agenda.id === this.selectedAgenda.id;
    },
  },
  methods: {
    // 選択
    onClickAgenda(agenda) {
      this.$emit("select", agenda);
    },
    // マウスオーバー
    onMouseOver() {
      this.mouseOver = true;
    },
    onMouseLeave() {
      this.mouseOver = false;
    },
    // 操作メニュー
    onClickDelete(agenda) {
      this.$emit("delete", agenda);
    },
    onClickEdit() {
      this.name = this.agenda.name;
      this.isEditing = true;
      this.$nextTick(() => {
        this.$refs.editBox.focus();
      });
    },
    onKeypressEnter() {
      this.$refs.editBox.blur();
    },
    onEditEnd(agenda) {
      // 入力フォームを非表示に
      this.isEditing = false;
      // nameが空白なら元に戻す
      if (this.name.length === 0) this.name = this.agenda.name;
      if (this.name === this.agenda.name) return;
      this.$emit("edit-name", agenda, this.name);
    },
    onClickAddNext(agenda) {
      this.$emit("add-next", agenda);
    },
  },
};
</script>

<style scoped lang="scss">
$river-green: #51b392;
.agenda-wrapper {
  min-width: 280px;
  margin: 5px 0;
  display: flex;
  align-items: center;
  padding: 5px;
  color: rgba(25, 23, 17, 0.6);
  position: relative;
  &.mouseover {
    background-color: rgb(250, 250, 250);
    cursor: pointer;
  }
  &.selected {
    color: black;
    background-color: rgb(230, 230, 230);
    border-radius: 10px;
  }
  .input-box {
    padding-left: 5px;
    border: none;
    outline: none;
    background-color: aliceblue;
    border-radius: 10px;
  }
  .agenda-icon {
    padding-left: 5px;
  }
  .agenda-name {
    width: 100%;
    padding: 3px 10px;
    font-size: 1.2rem;
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
    }
  }
}
</style>
