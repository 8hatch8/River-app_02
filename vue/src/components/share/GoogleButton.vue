<template>
  <div class="google-btn">
    <div class="google-icon-wrapper">
      <img class="google-icon" src="@/assets/images/btn_google_light_normal_ios.svg" />
    </div>
    <p class="btn-text"><b>Sign in with google</b></p>
  </div>
</template>

<script>
export default {};
</script>

<style scoped lang="scss">
$white: #fff;
$google-blue: #4285f4;
$button-active-blue: #1669f2;

.google-btn {
  width: 200px;
  height: 42px;
  background-color: $google-blue;
  display: flex;
  border-radius: 2px;
  box-shadow: 0 3px 4px 0 rgba(0, 0, 0, 0.25);
  .google-icon-wrapper {
    margin-top: 1px;
    margin-left: 1px;
    width: 40px;
    height: 40px;
    border-radius: 2px;
    background-color: $white;
  }
  .google-icon {
    max-width: 100%;
    height: auto;
  }
  .btn-text {
    margin: auto;
    color: $white;
    font-size: 14px;
    letter-spacing: 0.2px;
    font-family: "Roboto";
  }
  &:hover {
    box-shadow: 0 0 3px $google-blue;
  }
  &:active {
    background: $button-active-blue;
  }
}

@import url(https://fonts.googleapis.com/css?family=Roboto:500);
</style>
