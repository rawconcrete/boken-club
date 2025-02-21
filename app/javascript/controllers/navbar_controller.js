import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap"; // Import all Bootstrap components

export default class extends Controller {
  connect() {
    console.log("Navbar controller connected.");
    this.dropdown = new bootstrap.Dropdown(this.element.querySelector(".dropdown-toggle"));
  }
}
