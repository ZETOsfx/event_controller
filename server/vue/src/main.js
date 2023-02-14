import { createApp } from 'vue'
import App from './App.vue'

import Events from './components/Events.vue'
import Moders from './components/Moder.vue'

import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap"

    // Вкладка модератора
createApp(Moders).mount('#moderationForm')

    // Вкладка редактора
createApp(Events).mount('#eventsForm')

