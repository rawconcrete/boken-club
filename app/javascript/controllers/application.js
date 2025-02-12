// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// configure stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
