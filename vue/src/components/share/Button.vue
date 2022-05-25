<template>
  <button class="Button" @click="$emit('click', $event)">{{ label }}</button>
</template>

<script>
export default {
  props: {
    label: { type: String, required: true },
    backgroundColor: { type: String, required: false, default: "#51b392" },
  },
  emits: ["click"],
  data() {
    return {
      backgoundColor: this.backgroundColor,
    };
  },
};
</script>

<style scoped>
.Button {
  text-decoration: none;
  background: v-bind(backgroundColor);
  color: white;
  font-weight: bold;
  border: 0;
  border-radius: 3px;
  padding: 10px 20px;
  cursor: pointer;
}
</style>
