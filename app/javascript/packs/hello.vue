<template>
  <div id='hello'>
    <p>{{ message }}</p>
  </div>

</template>

<script>
  export default {
    data: function () {
      return {
        message: "sss to vue!"
      }
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>