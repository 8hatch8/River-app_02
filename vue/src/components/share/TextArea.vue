<template>
  <textarea
    class="TextArea"
    v-model="text"
    :placeholder="placeholder"
    :required="required ? true : false"
    :autofocus="autofocus"
    :ref="ref"
    :style="styles"
    @focus="onFocus"
    @input="onInput"
    @blur="onBlur"
    @keypress.enter.shift="onKeyPressEnterShift"
    @keypress.enter.exact.prevent="onKeyPressEnter"
    @keyup.prevent.enter.exact="onKeyUpEnter"
  >
  </textarea>
</template>

<script>
export default {
  props: {
    value: { type: String },
    ref: { type: String, default: "TextArea" },
    placeholder: { type: String },
    required: { type: Boolean, default: false },
    autofocus: { type: Boolean, default: false },
  },
  emits: ["blur"],
  data() {
    return {
      text: this.value,
      height: "",
      canSubmit: false,
    };
  },
  computed: {
    styles() {
      return {
        height: this.height,
      };
    },
  },
  methods: {
    focusText() {
      this.$nextTick(() => {
        this.$refs[this.ref].focus();
      });
    },
    onKeyPressEnterShift() {
      return;
    },
    onKeyPressEnter() {
      this.canSubmit = true;
    },
    onKeyUpEnter() {
      if (!this.canSubmit) return;
      this.onBlur();
      this.canSubmit = false;
    },
    onFocus() {
      this.$nextTick(() => {
        this.$refs[this.ref].select();
      });
    },
    onInput() {
      this.resize();
    },
    onBlur() {
      this.$emit("blur", this.text);
    },
    resize() {
      this.height = "auto";
      this.$nextTick(() => {
        this.height = this.$refs[this.ref].scrollHeight + "px";
      });
    },
  },
  mounted() {
    this.resize();
    this.focusText();
  },
};
</script>

<style scoped>
.TextArea {
  width: 100%;
  border: none;
  outline: none;
  resize: none;
}
</style>
