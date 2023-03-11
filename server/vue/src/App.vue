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

import io from "socket.io-client";

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
      socket: {},
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
    connect() {
        // server URL
      this.socket = io('http://localhost:3000/');

      this.socket.on('active:upd', () => {
        window.location.reload();
      });
    },
    async get() {
      this.activeItemId = -1;
      // http://eventcontroller.ru/event/json
      // http://localhost:3000/event/json
      let response = await fetch(`${ process.env.API_URL }/event/json`, {});
      this.list = (await response.json()).pages;



      function refreshAt(hours, minutes, seconds) {
        var now = new Date();
        var then = new Date();

        if (now.getHours() > hours || (now.getHours() === hours && now.getMinutes() > minutes) ||
            now.getHours() === hours && now.getMinutes() === minutes && now.getSeconds() >= seconds) {
            then.setDate(now.getDate() + 1);
        }

        then.setHours(hours);
        then.setMinutes(minutes);
        then.setSeconds(seconds);

        var timeout = (then.getTime() - now.getTime());
        setTimeout(function() { window.location.reload() }, timeout);
      }

      refreshAt(8,20,3);
      refreshAt(8,40,3);
      refreshAt(10,15,3);
      refreshAt(10,25,3);
      refreshAt(12,0,3);
      refreshAt(12,50,3);
      refreshAt(14,25,3);
      refreshAt(14,35,3);
      refreshAt(16,10,3);
      refreshAt(16,20,3);
      refreshAt(17,55,3);
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
        let time = (new Date(this.list[k].time)).getTime()
        console.log(this.list[k].time, new Date(this.list[k].time), new Date(), k)
        if (this.now > time) continue;
        return this.list[parseInt(k)-1].id;
      }
    },
    async formLoad(e) {
      return
        // let data = e.path[0].dataset;
        // if (data.id < 0) return;
        // console.log(e.path[0], 213)
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
    this.connect();
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

