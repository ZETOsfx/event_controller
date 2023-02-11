import { createApp } from 'vue'
import App from './App.vue'
import Events from './components/Events.vue'
import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap"

// createApp(App).mount('#editorForm')
createApp(Events).mount('#eventsForm')

