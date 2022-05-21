<template>
  <nav class="navigation-bar">
    <div class="navbar-left">
      <!-- タイトル -->
      <a class="logo font font-md" href="/">River</a>
      <!-- ルーム名 -->
      <p class="room-name">【{{ room.name }}】</p>
    </div>
    <div class="navbar-right">
      <!-- マイページ -->
      <a class="my-page" href="#">{{ user.nickname }}さんのマイページ</a>
      <!-- ログアウト -->
      <logout-button label="ログアウト" @click="logout" />
    </div>
  </nav>
</template>

<script>
import axios from "axios";
import LogoutButton from "@/components/share/Button.vue";
import { removeItem, apiServer } from "@/mixin/auth";
export default {
  name: "ChatroomNavbar",
  components: { LogoutButton },
  props: ["room", "user"],
  methods: {
    async logout() {
      try {
        const res = await axios.delete(`${apiServer}/auth/sign_out/`, {
          headers: {
            uid: window.localStorage.getItem("uid"),
            "access-token": window.localStorage.getItem("access-token"),
            client: window.localStorage.getItem("client"),
          },
        });
        // responseがない場合
        if (!res) {
          throw new Error("ログアウトできませんでした");
        }
        // 成功時
        console.log("ログアウトしました");
        removeItem();
        this.$router.push({ name: "Welcome" });
        return res;
      } catch {
        (e) => console.log({ e });
        //【TODO】エラー文の表示
      }
    },
  },
};
</script>

<style scoped lang="scss">
.navigation-bar {
  height: 100%;
  width: 100%;
  color: aliceblue;
  padding: 0 10px;
  background-color: #51b392;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  .navbar-left {
    color: inherit;
    display: flex;
    align-items: center;
    .room-name {
      font-size: 1.4rem;
      padding-left: 10px;
    }
  }
  .navbar-right {
    .my-page {
      color: inherit;
    }
  }
}
</style>
