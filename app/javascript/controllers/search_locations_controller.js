// app/javascript/controllers/search_locations_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 connect() {
   this.element.addEventListener("input", this.search.bind(this))
 }

 search(event) {
   clearTimeout(this.timeout)
   this.timeout = setTimeout(() => {
     this.element.requestSubmit()
   }, 300)
 }
}
