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
        <div class="agendas" v-for="(agenda, index) in agendas" :key="agenda.id">
          <chatroom-agenda
            :agenda="agenda"
            :index="index"
            :selected-agenda="selectedAgenda"
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
            <div class="item" v-for="item in items" :key="item.id">
              <chatroom-item :item="item" />
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
    // 左メニュー
    onSelectAgenda(agenda) {
      this.getAgenda(agenda);
    },
    onClickAddButton() {
      this.postAgenda();
    },
    onAddNextAgenda(agenda) {
      this.postAgenda(agenda.position + 1);
    },
    onEditAgendaName(agenda, name) {
      const editAgenda = { ...agenda };
      editAgenda.name = name;
      this.putAgenda(editAgenda);
    },
    onDeleteAgenda(agenda) {
      this.deleteAgenda(agenda);
    },
    // 右ビュー
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
    // チャット
    onPost(text) {
      this.roomChannel.perform("post", {
        room_id: this.room.id,
        text: text,
        agenda_id: this.selectedAgenda.id,
        user_id: this.user.id,
      });
    },
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
    async postAgenda(index = null) {
      try {
        const res = await axios.post(
          `${apiServer}/rooms/${this.room.id}/agendas`,
          {
            agenda: {
              name: `新しいテーマ${this.agendas.length + 1}`,
              position: index,
              room_id: this.room.id,
            },
          },
          { headers: axiosHeaders() }
        );
        // 再読み込み
        this.getRoom();
        return res;
      } catch (e) {
        console.log(e);
      }
    },
    async putAgenda(editAgenda) {
      try {
        const res = await axios.put(
          `${apiServer}/rooms/${this.room.id}/agendas/${editAgenda.id}`,
          { agenda: editAgenda },
          { headers: axiosHeaders() }
        );
        // 再読み込み
        this.getRoom();
        return res;
      } catch (e) {
        console.log(e);
      }
    },
    async deleteAgenda(agenda) {
      const shouldDelete = confirm(`「${agenda.name}」を削除しますか？`);
      if (!shouldDelete) {
        return;
      }
      try {
        const res = await axios.delete(`${apiServer}/rooms/${this.room.id}/agendas/${agenda.id}`, {
          headers: axiosHeaders(),
        });
        if (agenda.id === this.selectedAgenda.id) {
          this.selectedAgenda = {};
        }
        this.getRoom();
        return res;
      } catch (e) {
        console.log(e);
      }
    },
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
            console.log("websocket接続を開始しました");
          },
          received: (data) => {
            this.data = data;
            console.log("received");
            if (data.type === "post") {
              console.log("post");
              if (data.payload.agenda_id === this.selectedAgenda.id) {
                console.log("same_id");
                this.getAgenda(this.selectedAgenda);
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
  mounted() {
    this.connectCable();
  },
  beforeUnmount() {
    this.disconnectCable();
  },
};
</script>

<style lang="scss">
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
      .items {
      }
    }
    .chat-form {
    }
  }
}
</style>
