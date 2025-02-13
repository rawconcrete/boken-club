// app/javascript/controllers/navbar_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
    this.dropdown = new bootstrap.Dropdown(this.element.querySelector('.dropdown-toggle'))
  }
}
