import { createApp } from 'vue'

// --- CAST ---

import mitt from 'mitt';
import '../../public/css/style.css'
import App from './App.vue'

const emitter = mitt();
const app = createApp(App);
app.config.globalProperties.emitter = emitter;
app.mount('#castForm');

// --- VKLADKAS ---

import Events from './components/Events.vue'
import Moders from './components/Moder.vue'

import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap"

    // Вкладка модератора
createApp(Moders).mount('#moderationForm')

    // Вкладка редактора
createApp(Events).mount('#eventsForm')

