<template>
  <!--  <button @click="activeItemId++">sdsd</button>-->
  <!--  <button @click="activeItemId&#45;&#45;">sdsd</button>-->
  <div v-if="isInit" class="background">
    <div class="layer-text">
      Loading...
    </div>
    <div class="layer">
    </div>
  </div>
  <template v-for="page in pages.image">
    <customImage v-show="page.id === activeItemId" :src="page.src"/>
  </template>
  <template v-for="page in pages.video">
    <customVideo :id="page.id" v-show="page.id === activeItemId" :src="page.src"></customVideo>
  </template>
  <template v-for="page in pages.form">
    <customIframe :itemId="activeItemId" :load="formLoad" v-show="page.id === activeItemId" :src="page.src"></customIframe>
  </template>
</template>


<script>
import customImage from "./components/image.vue";
import customVideo from "./components/video.vue";
import customIframe from "./components/iframe.vue";


export default {
  components: {
    customImage,
    customVideo,
    customIframe,
  },
  data() {
    return {
      list: null,
      now: Date.now(),
      pages: {
        image: [{id: null, src: null}],
        video: [{id: null, src: null}],
        form: [{id: null, src: null}],
        end: [{id: null, src: null}]
      },
      activeItemId: -1,
      isInit: true,
    }
  },
  methods: {
    async get() {
      this.activeItemId = -1;
      let response = await fetch(`http://localhost:3000/event/json`, {});
      this.list = (await response.json()).pages;
    },
    async buildPages() {
      console.log("start")
      for (let i in this.list) {
        let obj = this.list[i];
        console.log(obj)
        obj.id = parseInt(i);
        if (this.pages[obj.type][0].src === null) this.pages[obj.type] = []
        this.pages[obj.type].push(obj);
        if (obj.type === "form" && this.isInit) {
          this.activeItemId = obj.id;
          console.log(this.activeItemId)
          await this.sleep(6000)
          console.log(3000)
        }
      }
    },
    async getPage() {
      if (this.now > (new Date(this.list[this.list.length - 1].time)).getTime()) {
        await this.get();
        await this.buildPages();
      }
      for (let k in this.list){
        var time = (new Date(this.list[k].time)).getTime()
        console.log(this.list[k].time, new Date(this.list[k].time), new Date(), k)
        if (this.now > time) continue;
        return this.list[parseInt(k)-1].id;
      }
    },
    async formLoad(e) {
      return
        var data = e.path[0].dataset;
        if (data.id < 0) return;
        console.log(e.path[0], 213)
    },
    async timer() {
      this.now = Date.now();

      this.activeItemId = await this.getPage();
      // _self.activeItemId++
      // if (_self.list.length - 1 < _self.activeItemId) _self.activeItemId = 0;
      this.emitter.emit('change', this.activeItemId);
    },
    sleep(time) {
      return new Promise((resolve) => setTimeout(resolve, time));
    }
  },
  async mounted() {
    await this.get();
    this.buildPages().then(() => {
      this.isInit = false;
      console.log("then")
      this.list.sort((a, b) => {
        return (new Date(a.time).getTime()) - (new Date(b.time).getTime());
      })
      this.timer();
      setInterval(this.timer, 2000)
    })
  }
}
</script>

