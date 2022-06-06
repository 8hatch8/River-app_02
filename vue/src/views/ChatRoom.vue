<template>
  <div class="chat-room">
    <!-- ナビゲーションバー -->
    <div class="navbar">
      <chatroom-navbar :room="room" :user="user" />
    </div>

    <!-- メイン画面 -->
    <main class="main">
      <!-- Left Menu -->
      <div class="left-menu">
        <!-- アジェンダリスト -->
        <vue-draggable
          class="agendas"
          v-model="room.agendas"
          item-key="id"
          :animation="300"
          :delay="5"
          handle=".draggable-handle"
          @change="onDragAgenda"
        >
          <template #item="{ element }">
            <chatroom-agenda
              :agenda="element"
              :selectedAgenda="selectedAgenda"
              @select="onSelectAgenda"
              @add-next="onAddNextAgenda"
              @edit-name="onEditAgendaName"
              @delete="onDeleteAgenda"
            />
          </template>
        </vue-draggable>
        <!-- アジェンダ追加ボタン -->
        <button class="agenda-add-button" @click="onClickAddButton">
          <fa-icon class="icon" icon="plus-square" />テーマを追加
        </button>
      </div>

      <!-- Right View -->
      <div class="right-view">
        <div class="right-top">
          <!-- アジェンダ選択時 -->
          <template v-if="selectedAgenda.id > 0">
            <div class="agenda">
              <div class="agenda-title font-md">
                {{ selectedAgenda.name }}
              </div>
              <!-- 説明文（編集時） -->
              <template v-if="isEditingContent">
                <input
                  v-model="selectedAgenda.content"
                  ref="contentEditBox"
                  class="agenda-content input-box"
                  onfocus="this.select()"
                  @keypress.enter="onBlurContent"
                  @blur="onBlurContent"
                />
              </template>
              <!-- 説明文（通常時） -->
              <template v-else>
                <div
                  class="agenda-content"
                  @click="onClickContent"
                  @mouseover="onMouseOverContent"
                  @mouseleave="onMouseLeaveContent"
                >
                  {{ selectedAgenda.content || "説明を追加" }}
                </div>
              </template>
            </div>
          </template>

          <!-- アジェンダ未選択時 -->
          <template v-else>
            <div class="agenda">
              <div class="agenda-title font-md">
                {{ "テーマを選択してください" }}
              </div>
            </div>
          </template>

          <!-- アイテムリスト -->
          <vue-draggable
            class="items"
            v-model="selectedAgenda.items"
            item-key="id"
            :animation="300"
            :delay="5"
            handle=".draggable-handle"
            :force-fallback="true"
            @change="onDragItem"
            @start="isDragging = true"
            @end="isDragging = false"
          >
            <template #item="{ element }" class="item">
              <chatroom-item
                :item="element"
                :selected-item="selectedItem"
                :is-dragging="isDragging"
                @add-next="onAddNextItem"
                @edit-text="onEditItemText"
                @delete="onDeleteItem"
                @change-format="onChangeFormat"
                @select="onSelectItem"
                @unselect="onUnselectItem"
              />
            </template>
          </vue-draggable>
        </div>

        <!-- 投稿フォーム -->
        <div class="chat-form" v-if="this.selectedAgenda.id > 0 && !isDragging">
          <chat-form @post="onPost" />
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import ChatroomNavbar from "@/components/Chatroom/ChatroomNavbar.vue";
import ChatroomAgenda from "@/components/Chatroom/ChatroomAgenda.vue";
import ChatroomItem from "@/components/Chatroom/ChatroomItem.vue";
import ChatForm from "@/components/Chatroom/ChatForm.vue";
import VueDraggable from "vuedraggable";
import axios from "axios";
import ActionCable from "actioncable";
import { apiServer, axiosHeaders } from "@/mixin/auth";

export default {
  components: { ChatroomNavbar, ChatroomAgenda, ChatroomItem, ChatForm, VueDraggable },
  data() {
    return {
      roomChannel: {},
      user: { id: 0, nickname: "テストユーザー" },
      room: { id: 0 },
      selectedAgenda: { id: 0 },
      selectedItem: { id: 0 },
      mouseOverContent: false,
      isEditingContent: false,
      isDragging: false,
    };
  },
  computed: {
    agendas() {
      return this.room.agendas;
    },
    items() {
      return this.selectedAgenda.items;
    },
    postPosition() {
      if (!this.selectedItem.id) return null;
      const nextHeading = this.items.find((item) => {
        return (
          item.position > this.selectedItem.position &&
          (item.format === "heading-1" ||
            item.format === "heading-2" ||
            item.format === "heading-3")
        );
      });
      if (!nextHeading) return null;
      return nextHeading.position;
    },
  },
  methods: {
    // 左メニュー:Agenda
    onSelectAgenda(agenda) {
      this.getAgenda(agenda);
    },
    onClickAddButton() {
      this.postAgenda();
    },
    onAddNextAgenda(agenda) {
      // 【TODO】positionの処理をここに移す
      this.postAgenda(agenda);
    },
    onEditAgendaName(agenda, editedName) {
      const editedAgenda = { ...agenda };
      editedAgenda.name = editedName;
      this.putAgenda(editedAgenda);
    },
    onDeleteAgenda(agenda) {
      this.deleteAgenda(agenda);
    },
    onDragAgenda(arg) {
      if (!arg.moved) return;
      const agenda = this.room.agendas.find((agenda) => {
        return agenda === arg.moved.element;
      });
      agenda.position = arg.moved.newIndex + 1;
      this.dragAgenda(agenda);
    },
    // 右ビュー：Content
    onClickContent() {
      this.isEditingContent = true;
      this.$nextTick(() => {
        this.$refs.contentEditBox.focus();
      });
    },
    onMouseOverContent() {
      this.mouseOverContent = true;
    },
    onMouseLeaveContent() {
      this.mouseOverContent = false;
    },
    onBlurContent() {
      this.isEditingContent = false;
      this.putAgenda(this.selectedAgenda);
    },
    // 右ビュー：Item
    onSelectItem(item) {
      this.selectedItem = item;
    },
    onUnselectItem() {
      this.selectedItem = {};
    },
    onAddNextItem(targetItem, format) {
      const item = {
        text: "新規アイテム",
        format: format,
        position: targetItem.position + 1,
        agenda_id: this.selectedAgenda.id,
      };
      this.postItem(item);
    },
    onEditItemText(item, text) {
      const editedItem = { ...item };
      editedItem.text = text;
      this.putItem(editedItem);
    },
    onDeleteItem(item) {
      this.deleteItem(item);
    },
    onChangeFormat(item, format) {
      const editedItem = { ...item };
      editedItem.format = format;
      this.putItem(editedItem);
      // 選択されていた場合、選択解除
      if (this.selectedItem === item) {
        this.selectedItem = {};
      }
    },
    onDragItem(arg) {
      if (!arg.moved) return;
      const item = this.selectedAgenda.items.find((item) => {
        return item === arg.moved.element;
      });
      item.position = arg.moved.newIndex + 1;
      this.dragItem(item);
    },
    // 右ビュー：ChatForm
    onPost(text, format) {
      const item = {
        text: text,
        format: format,
        position: this.postPosition,
        agenda_id: this.selectedAgenda.id,
      };
      this.postItem(item);
    },
    getUser() {
      this.user.nickname = window.localStorage.getItem("nickname");
    },
    // API Communication：Item
    async postItem(item) {
      // クライアントの処理
      if (item.position) {
        this.items.splice(item.position - 1, 0, item);
      } else {
        this.items.push(item);
      }
      // API通信
      try {
        const res = await axios.post(
          `${apiServer}/rooms/${this.room.id}/agendas/${this.selectedAgenda.id}/items`,
          { item: item },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async putItem(editedItem) {
      try {
        const res = await axios.put(
          `${apiServer}/rooms/${this.room.id}/agendas/${this.selectedAgenda.id}/items/${editedItem.id}`,
          { item: editedItem },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async deleteItem(item) {
      const shouldDelete = confirm(`「${item.text}」\nを削除しますか？`);
      if (!shouldDelete) return;
      try {
        const res = await axios.delete(
          `${apiServer}/rooms/${this.room.id}/agendas/${this.selectedAgenda.id}/items/${item.id}`,
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async dragItem(item) {
      try {
        const res = await axios.patch(
          `${apiServer}/rooms/${this.room.id}/agendas/${this.selectedAgenda.id}/items/${item.id}/move`,
          { item: item },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    // API Communication：Agenda
    async getAgenda(agenda) {
      try {
        const res = await axios.get(`${apiServer}/rooms/${this.room.id}/agendas/${agenda.id}`, {
          headers: axiosHeaders(),
        });
        if (!res) {
          throw new Error("テーマ情報を取得できませんでした");
        }
        console.log("テーマ情報を取得しました");
        this.selectedAgenda = res.data;
      } catch (e) {
        console.log(e);
      }
    },
    async postAgenda(agenda) {
      const postAgenda = {
        name: `新しいテーマ${this.agendas.length + 1}`,
        position: agenda ? agenda.position + 1 : null,
        room_id: this.room.id,
      };
      // クライアントの処理
      if (postAgenda.position) {
        this.room.agendas.splice(postAgenda.position - 1, 0, postAgenda);
      } else {
        this.room.agendas << postAgenda;
      }
      // API通信
      try {
        const res = await axios.post(
          `${apiServer}/rooms/${this.room.id}/agendas`,
          { agenda: postAgenda },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async putAgenda(editedAgenda) {
      // クライアントの処理
      const agenda = this.agendas.find((agenda) => {
        return agenda.id === editedAgenda.id;
      });
      agenda.name = editedAgenda.name;
      agenda.content = editedAgenda.content;
      // API通信
      try {
        const res = await axios.put(
          `${apiServer}/rooms/${this.room.id}/agendas/${editedAgenda.id}`,
          { agenda: editedAgenda },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async deleteAgenda(agenda) {
      // 削除の確認
      const shouldDelete = confirm(`「${agenda.name}」を削除しますか？`);
      if (!shouldDelete) return;
      // API通信
      try {
        const res = await axios.delete(`${apiServer}/rooms/${this.room.id}/agendas/${agenda.id}`, {
          headers: axiosHeaders(),
        });
        if (agenda.id === this.selectedAgenda.id) {
          this.selectedAgenda = {};
        }
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async dragAgenda(agenda) {
      try {
        const res = await axios.patch(
          `${apiServer}/rooms/${this.room.id}/agendas/${agenda.id}/move`,
          { agenda: agenda },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    // API Communication：Room
    async getRoom(roomId = 4) {
      try {
        const res = await axios.get(`${apiServer}/rooms/${roomId}`, {
          headers: axiosHeaders(),
        });
        if (!res) {
          throw new Error("チャットルーム情報を取得できませんでした");
        }
        console.log("チャットルーム情報を取得しました");
        this.room = res.data;
      } catch (e) {
        console.log(e);
      }
    },
    async putRoom(room) {
      try {
        const res = await axios.put(
          `${apiServer}/rooms/${this.room.id}`,
          {
            room: {
              name: this.room.name,
              password_digest: this.room["password_digest"],
              agendas_order: room["agendas_order"],
            },
          },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    // ActionCable
    connectCable() {
      const cable = ActionCable.createConsumer(`${apiServer}/cable`); // http:ならws:、https:ならwss:
      this.roomChannel = cable.subscriptions.create(
        {
          channel: `RoomChannel`, // Rails: channels/room_channel.rb
          roomId: this.room.id, // Rails: params[:roomId]
        },
        {
          connected: () => {
            console.log(`websocket接続を開始しました（room_channel_${this.room.id}）`);
          },
          received: (data) => {
            this.res = data;
            switch (data.type) {
              case "add_agenda":
                this.getRoom();
                break;
              case "update_agenda": {
                const targetAgenda = this.room.agendas.find((agenda) => {
                  return agenda.id === data.agenda.id;
                });
                if (!targetAgenda) return;
                targetAgenda.name = data.agenda.name;
                targetAgenda.content = data.agenda.content;

                if (targetAgenda.id === this.selectedAgenda.id) {
                  this.selectedAgenda.name = targetAgenda.name;
                  this.selectedAgenda.content = targetAgenda.content;
                }
                break;
              }
              case "delete_agenda": {
                const targetAgenda = this.room.agendas.find((agenda) => {
                  return agenda.id === data.agenda.id;
                });
                if (!targetAgenda) return;
                // 対象Agendaを表示中の場合はメッセージを表示
                if (targetAgenda.id === this.selectedAgenda.id) {
                  confirm("表示中のテーマは削除されました");
                  this.selectedAgenda = {};
                }
                this.getRoom();
                break;
              }
              case "move_agenda":
                this.getRoom();
                break;
              case "post_item":
                if (data.item.agenda_id === this.selectedAgenda.id) {
                  const agenda = { id: data.item.agenda_id };
                  this.getAgenda(agenda);
                }
                break;
              case "update_item": {
                const targetItem = this.selectedAgenda.items.find((item) => {
                  return item.id === data.item.id;
                });
                if (!targetItem) return;
                targetItem.text = data.item.text;
                targetItem.format = data.item.format;
                break;
              }
              case "delete_item": {
                const targetItem = this.selectedAgenda.items.find((item) => {
                  return item.id === data.item.id;
                });
                if (!targetItem) return;
                const index = this.selectedAgenda.items.indexOf(targetItem);
                this.selectedAgenda.items.splice(index, 1);
                break;
              }
              case "move_item": {
                const targetItem = this.selectedAgenda.items.find((item) => {
                  return item.id === data.item.id;
                });
                if (!targetItem) return;
                this.getAgenda(this.selectedAgenda);
                break;
              }
            }
          },
        }
      );
    },
    disconnectCable() {
      this.roomChannel.unsubscribe();
      console.log("websocket接続を切断しました");
    },
  },
  created() {
    this.getRoom();
    this.getUser();
  },
  beforeUnmount() {
    this.disconnectCable();
  },
  watch: {
    "room.id"() {
      this.connectCable();
    },
  },
};
</script>

<style scoped lang="scss">
$river-green: #51b392;
.navbar {
  z-index: 100;
  position: absolute;
  width: 100%;
  height: 60px;
  box-shadow: 0 4px 3px rgba(0, 0, 0, 0.3);
}

.main {
  display: flex;
  height: 100vh;
  padding-top: 60px;

  .left-menu {
    width: 350px;
    background-color: #f7f6f3;
    padding: 20px 10px;
    overflow: auto;
    .agenda-add-button {
      margin-left: 8px;
      padding: 5px 10px;
      box-shadow: 0 3px 4px rgba(0, 0, 0, 0.3);
      .icon {
        margin-right: 5px;
      }
    }
  }

  .right-view {
    background-color: aliceblue;
    flex: 1;
    padding: 20px 20px;
    overflow: auto;

    .right-top {
      height: calc(100% - 60px);
      .agenda {
        padding: 10px 20px;
        margin-left: -15px;
        margin-right: -30px;
        border-left: 8px solid $river-green;
        background: #e4fcff;
        box-shadow: 0 3px 4px rgba(0, 0, 0, 0.3);
        .agenda-title {
        }
        .agenda-content {
          padding: 10px;
        }
        .input-box {
          width: 100%;
          border: none;
          outline: none;
          background-color: #e4fcff;
        }
      }
      // アイテムリスト
      .items {
        padding-bottom: 200px;
      }
    }
    .chat-form {
      width: calc(100% - 400px);
      position: absolute;
      bottom: 10px;
    }
  }
}
</style>
