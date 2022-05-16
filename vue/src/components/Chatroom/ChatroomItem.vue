<template>
  <div class="item-wrapper">
    <div v-if="item.format === 'text'" class="item-text">
      <!-- アイコン -->
      <div class="icon">
        <div><fa-icon icon="circle" /></div>
        <div class="nickname">name</div>
      </div>
      <!-- テキスト -->
      <div class="text">
        {{ item.text }}
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "ChatroomItem",
  props: ["item"],
};
</script>
<style scoped lang="scss">
.item-wrapper {
  padding-top: 20px;
  .item-text {
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
}
</style>
