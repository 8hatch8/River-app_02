<template>
  <button class="Button" @click="$emit('click', $event)">{{ label }}</button>
</template>

<script>
export default {
  props: {
    label: { type: String, required: true },
  },
  emits: ["click"],
};
</script>

<style scoped>
.Button {
  text-decoration: none;
  background: #51b392;
  color: white;
  font-weight: bold;
  border: 0;
  border-radius: 3px;
  padding: 10px 20px;
  cursor: pointer;
}
</style>
