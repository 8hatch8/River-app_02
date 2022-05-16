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
          />
        </div>
        <!-- アジェンダ追加ボタン -->
        <button class="agenda-add-button" @click="onClickAddButton">
          <fa-icon class="icon" icon="plus-square" />議題を追加
        </button>
      </div>

      <!-- Right View -->
      <div class="right-view">
        <div class="right-top">
          <!-- アジェンダ -->
          <div class="agenda">
            <div class="agenda-title font-md">
              {{ selectedAgenda.name }}
            </div>
            <div class="agenda-content">
              {{ selectedAgenda.content }}
            </div>
          </div>
          <!-- アイテムリスト -->
          <div class="items">
            <div class="item" v-for="item in items" :key="item.id">
              <chatroom-item :item="item" />
            </div>
          </div>
        </div>

        <!-- 投稿フォーム -->
        <div class="chat-form">
          <chat-form @send="onSend" />
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

export default {
  components: { ChatroomNavbar, ChatroomAgenda, ChatroomItem, ChatForm },
  data() {
    return {
      user: { id: 1, nickname: "ゆたか" },
      room: { id: 1, name: "サンプルのミーティングルーム" },
      agendas: [
        { id: 1, name: "agenda01", content: "議題01の詳細です" },
        { id: 2, name: "agenda02", content: "議題02の詳細です" },
        { id: 3, name: "agenda03", content: "議題03の詳細です" },
      ],
      selectedAgendaOrder: 1, // 【検討】idの方がいい？
      itemsOrder: [1, 2, 3],
      items: [
        { id: 1, text: "1つ目の項目", format: "text", agenda_id: 1, user_id: 1 },
        { id: 2, text: "2つ目の項目", format: "text", agenda_id: 1, user_id: 1 },
        { id: 3, text: "3つ目の項目", format: "text", agenda_id: 1, user_id: 1 },
      ],
    };
  },
  methods: {
    onSelectAgenda(index) {
      this.selectedAgendaOrder = index + 1;
    },
    onClickAddButton() {
      this.addAgenda(this.createAgenda());
    },
    onAddNextAgenda(index) {
      this.addAgenda(this.createAgenda(), index);
    },
    createAgenda() {
      const agenda = {
        name: `新しいテーマ${this.agendas.length + 1}`,
        room_id: this.room.id,
      };
      // axiosでアジェンダを新規作成
      // headerに認証情報をセットするmixin
      console.log({ agenda });
      // responseからagendaを作成
      // const resAgenda = res.agenda
      // this.addAgenda(resAgenda)
    },
    addAgenda(agenda, index) {
      if (index == null) {
        this.agendas.push(agenda);
      } else {
        this.agendas.splice(index + 1, 0, agenda);
      }
    },
    onSend(text) {
      console.log(text);
    },
  },
  computed: {
    selectedAgenda() {
      return this.agendas[this.selectedAgendaOrder - 1];
    },
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
    flex-grow: 1;
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
      }
      .items {
      }
    }
    .chat-form {
    }
  }
}
</style>
