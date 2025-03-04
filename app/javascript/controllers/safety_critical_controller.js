// app/javascript/controllers/safety_critical_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "form"]

  connect() {
    console.log("Safety critical controller connected")
  }

  toggle(event) {
    // Get the current URL and create a new URL object
    const url = new URL(window.location.href)

    // Set or remove the safety_critical parameter based on checkbox state
    if (this.checkboxTarget.checked) {
      url.searchParams.set('safety_critical', 'true')
    } else {
      url.searchParams.delete('safety_critical')
    }

    // Preserve other query parameters
    const query = this.element.querySelector('input[name="query"]')?.value
    const difficulty = this.element.querySelector('select[name="difficulty"]')?.value
    const category = this.element.querySelector('select[name="category"]')?.value

    if (query) url.searchParams.set('query', query)
    if (difficulty) url.searchParams.set('difficulty', difficulty)
    if (category) url.searchParams.set('category', category)

    // Navigate to the new URL
    window.location.href = url.toString()
  }
}
