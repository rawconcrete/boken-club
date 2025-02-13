import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // temporarily remove Bootstrap to isolate issue
    console.log("Navbar controller connected")
  }
}
