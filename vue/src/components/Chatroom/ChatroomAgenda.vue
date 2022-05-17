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
          class="input-box"
          onfocus="this.select()"
          @keypress.enter="onKeypressEnter"
          @blur="onEditEnd(agenda)"
        />
      </template>

      <!-- 通常時 -->
      <template v-else>
        <div class="agenda-icon"><fa-icon icon="comment" /></div>
        <div class="agenda-name">{{ name }}</div>

        <!-- 操作ボタン -->
        <div class="buttons" v-if="mouseOver">
          <!-- アジェンダ追加 -->
          <div class="button-icon" @click.stop="onClickAddNext(agenda)">
            <fa-icon icon="plus-circle" />
          </div>
          <!-- name編集 -->
          <div class="button-icon" @click.stop="onClickEdit">
            <fa-icon icon="edit" />
          </div>
          <!-- アジェンダ削除 -->
          <div class="button-icon" @click.stop="onClickDelete(agenda)">
            <fa-icon icon="trash" />
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
export default {
  name: "ChatroomAgenda",
  props: ["agenda", "selectedAgenda", "index"],
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
      return this.agenda === this.selectedAgenda;
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
      this.$emit("edit-name", agenda, this.name);
    },
    onClickAddNext(index) {
      this.$emit("add-next", index);
    },
  },
};
</script>

<style scoped lang="scss">
.agenda-wrapper {
  min-width: 280px;
  margin: 5px 0;
  display: flex;
  align-items: center;
  padding: 5px;
  color: rgba(25, 23, 17, 0.6);
  &.mouseover {
    background-color: rgb(232, 231, 228);
    cursor: pointer;
  }
  &.selected {
    color: black;
    background-color: rgb(232, 231, 228);
    font-weight: 600;
  }
  .input-box {
    font-size: 1.2rem;
    padding-left: 5px;
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
