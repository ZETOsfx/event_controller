<template>
  <iframe :data-id="itemId" :onload="load" :src="src"></iframe>
</template>

<script>
export default {
  props: ['src', 'load', 'itemId'],
  data() {
    return {
    }
  },
  methods: {
  },
  mounted() {
  }
}
</script>
