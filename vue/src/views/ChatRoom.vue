<template>
  <div class="chat-room">
    <!-- ナビゲーションバー -->
    <div class="navbar">
      <chatroom-navbar :room="room" :user="user" />
    </div>

    <!-- メイン画面 -->
    <div class="main">
      <!-- Left Menu -->
      <div class="left-menu">
        <!-- アジェンダリスト -->
        <div class="agendas" v-for="agenda in agendas" :key="agenda.id">
          <chatroom-agenda
            :agenda="agenda"
            :selectedAgenda="selectedAgenda"
            @select="onSelectAgenda"
            @add-next="onAddNextAgenda"
            @edit-name="onEditAgendaName"
            @delete="onDeleteAgenda"
          />
        </div>
        <!-- アジェンダ追加ボタン -->
        <button class="agenda-add-button" @click="onClickAddButton">
          <fa-icon class="icon" icon="plus-square" />テーマを追加
        </button>
      </div>

      <!-- Right View -->
      <div class="right-view">
        <div class="right-top">
          <!-- アジェンダ -->
          <!-- 【TODO】コンポーネントとして切り出す -->
          <template v-if="selectedAgenda.id > 0">
            <div class="agenda">
              <div class="agenda-title font-md">
                {{ selectedAgenda.name }}
              </div>
              <!-- 説明文 編集時 -->
              <template v-if="isEditingContent">
                <input
                  v-model="selectedAgenda.content"
                  ref="contentEditBox"
                  class="content-edit"
                  onfocus="this.select()"
                  @keypress.enter="onBlurContent"
                  @blur="onBlurContent"
                />
              </template>
              <!-- 説明文 通常時 -->
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

          <template v-else>
            <div class="agenda">
              <div class="agenda-title font-md">
                {{ "テーマを選択してください" }}
              </div>
            </div>
          </template>

          <!-- アイテムリスト -->
          <div class="items">
            <div
              class="item"
              :class="{
                'item-text': item.format === 'text',
                'item-h1': item.format === 'heading-1',
                'item-h2': item.format === 'heading-2',
                'item-h3': item.format === 'heading-3',
              }"
              v-for="item in items"
              :key="item.id"
            >
              <chatroom-item
                :item="item"
                @add-next="onAddNextItem"
                @edit-text="onEditItemText"
                @delete="onDeleteItem"
                @change-format="onChangeFormat"
              />
            </div>
          </div>
        </div>

        <!-- 投稿フォーム -->
        <div class="chat-form" v-if="this.selectedAgenda.id > 0">
          <chat-form @post="onPost" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ChatroomNavbar from "@/components/Chatroom/ChatroomNavbar.vue";
import ChatroomAgenda from "@/components/Chatroom/ChatroomAgenda.vue";
import ChatroomItem from "@/components/Chatroom/ChatroomItem.vue";
import ChatForm from "@/components/Chatroom/ChatForm.vue";
import axios from "axios";
import ActionCable from "actioncable";
import { apiServer, axiosHeaders } from "@/mixin/auth";

export default {
  components: { ChatroomNavbar, ChatroomAgenda, ChatroomItem, ChatForm },
  data() {
    return {
      roomChannel: null,
      user: { id: 1, nickname: "ゆたか" },
      room: {},
      selectedAgenda: {},
      mouseOverContent: false,
      isEditingContent: false,
      // for dev 後で消す
      res: null,
    };
  },
  computed: {
    agendas() {
      return this.room.agendas;
    },
    items() {
      return this.selectedAgenda.items;
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
    onAddNextItem(targetItem) {
      const item = {
        text: "新規アイテム",
        format: "text",
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
    },
    // 右ビュー：ChatForm
    onPost(text) {
      const item = {
        text: text,
        format: "text",
        position: null,
        agenda_id: this.selectedAgenda.id,
      };
      this.postItem(item);
    },
    // API Communication：Item
    async postItem(item) {
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
      try {
        const res = await axios.post(
          `${apiServer}/rooms/${this.room.id}/agendas`,
          {
            agenda: {
              name: `新しいテーマ${this.agendas.length + 1}`,
              position: agenda ? agenda.position + 1 : null,
              room_id: this.room.id,
            },
          },
          { headers: axiosHeaders() }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    async putAgenda(editedAgenda) {
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
      const shouldDelete = confirm(`「${agenda.name}」を削除しますか？`);
      if (!shouldDelete) return;
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
    // API Communication：Room
    async getRoom(roomId = 1) {
      try {
        const res = await axios.get(`${apiServer}/rooms/${roomId}`, {
          headers: axiosHeaders(),
        });
        if (!res) {
          throw new Error("チャットルーム情報を取得できませんでした");
        }
        console.log("チャットルーム情報を取得しました");
        this.room = res.data;
        this.connectCable();
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
          {
            headers: axiosHeaders(),
          }
        );
        console.log(res);
      } catch (e) {
        console.log(e);
      }
    },
    // ActionCable
    connectCable() {
      //websocket:【TODO】本番環境ではURI変更
      const cable = ActionCable.createConsumer("ws://localhost:3000/cable"); // https:ならwss:
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
              // case "move_agenda":
              //   this.getRoom();
              //   break;
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
                // 対象Agendaを削除
                const index = this.room.agendas.indexOf(targetAgenda);
                this.room.agendas.splice(index, 1);
                // 対象Agendaを表示中の場合
                if (targetAgenda.id === this.selectedAgenda.id) {
                  this.selectedAgenda = {};
                  confirm("表示中のテーマは削除されました");
                }
                break;
              }
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
                if (targetItem) {
                  const index = this.selectedAgenda.items.indexOf(targetItem);
                  this.selectedAgenda.items.splice(index, 1);
                }
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
  },
  mounted() {},
  beforeUnmount() {
    this.disconnectCable();
  },
};
</script>

<style scoped lang="scss">
.navbar {
  height: 60px;
  background-color: #999;
}

.main {
  display: flex;
  height: calc(100vh - 60px);

  .left-menu {
    width: 350px;
    background-color: #f7f6f3;
    padding: 20px 10px;
    overflow: auto;
    .agenda-add-button {
      margin-left: 8px;
      padding: 5px 10px;
      .icon {
        margin-right: 5px;
      }
    }
  }

  .right-view {
    background-color: aliceblue;
    flex: 1;
    padding: 20px 30px;
    overflow: auto;

    .right-top {
      height: calc(100% - 60px);
      .agenda {
        padding: 10px;
        border: dotted 2px #999;
        .agenda-title {
        }
        .agenda-content {
          padding: 10px;
        }
        .content-edit {
          width: 100%;
          padding: 10px;
        }
      }
      // アイテムのインデント
      .items {
        padding-bottom: 200px;
        .item-h1 {
          margin-left: 0px;
        }
        .item-h2 {
          margin-left: 20px;
        }
        .item-h3 {
          margin-left: 40px;
        }
        .item-text {
          margin-left: 40px;
        }
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
