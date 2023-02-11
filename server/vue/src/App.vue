<template>
  <div class="event__block">
    <div class="event__block__in">
      <label for="event_name" class="text_under">Наименование события</label>
      <input type="text" name="event_name" value="" id="event_name">
    </div>
    <div class="event__block__in">
      <label for="event_url" class="text_under">Ссылка на ресурс</label>
      <input type="text" name="event_url" value="">
    </div>
    <div class="event__block__in">
      <label for="event_duration" class="text_under">Длительность (в сек.)</label>
      <input type="number" name="event_duration" value="">
    </div>
    <div class="event__block__in">
      <button class="add-btn">Вверх</button>
      <button class="sub-btn">Вниз</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      events: {}
    }
  },
  methods: {
    async get() {
      let response = await fetch(`${process.env.API_URL}/events`, {});
      this.events = (await response.json());

    },
  },
  mounted() {
    this.get();
  }
}
</script>
