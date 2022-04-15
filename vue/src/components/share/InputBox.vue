<template>
  <div class="InputBox">
    <label v-if="label" class="InputBox__Label" :for="id">{{ label }}</label>
    <input
      class="InputBox__Input"
      :id="id"
      :name="name"
      :value="value"
      :type="type"
      :placeholder="placeholder"
      :required="required ? true : false"
      :autofocus="autofocus"
      @input="$emit('input', $event)"
      @focus="$emit('focus', $event)"
      @blur="$emit('blur', $event)"
    />
  </div>
</template>

<script>
export default {
  props: {
    id: { type: String },
    label: { type: String },
    name: { type: String },
    value: { type: String },
    type: { type: String, default: "text" },
    placeholder: { type: String },
    required: { type: Boolean, default: false },
    autofocus: { type: Boolean, default: false },
  },
  emits: ["input", "focus", "blur"],
};
</script>

<style scoped>
.InputBox__Label {
  display: block;
  text-align: left;
  margin-top: 20px;
}

.InputBox__Input {
  width: 100%;
  padding: 12px 20px;
  margin: 8px auto;
  border-radius: 4px;
  border: 1px solid #eee;
  outline: none;
}
</style>
