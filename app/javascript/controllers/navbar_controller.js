// app/javascript/controllers/navbar_controller.js
import { Controller } from "@hotwired/stimulus"
import { Dropdown } from "bootstrap"

export default class extends Controller {
  connect() {
    this.dropdown = new Dropdown(this.element.querySelector('.dropdown-toggle'))
  }
}
