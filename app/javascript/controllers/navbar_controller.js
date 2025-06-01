// app/javascript/controllers/navbar_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
    const dropdownEl = this.element.querySelector('.dropdown-toggle');
    if (dropdownEl) {
      this.dropdown = new bootstrap.Dropdown(dropdownEl);
    }
  }
}
