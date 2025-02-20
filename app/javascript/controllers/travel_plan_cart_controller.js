// app/javascript/controllers/travel_plan_cart_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cartIndicator"]
  static values = {
    count: Number,
    planId: Number
  }

  connect() {
    this.updateCart()
  }

  async addItem(event) {
    event.preventDefault()
    const button = event.currentTarget
    const itemType = button.dataset.itemType
    const itemId = button.dataset.itemId

    try {
      const response = await fetch(`/travel_plans/${this.planIdValue}/add_item`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ item_type: itemType, item_id: itemId })
      })

      if (response.ok) {
        button.disabled = true
        button.textContent = "✓ Added"
        button.classList.remove("btn-primary")
        button.classList.add("btn-success")
        this.countValue++
        this.updateCart()
      }
    } catch (error) {
      console.error("Error adding item:", error)
    }
  }

  updateCart() {
    if (this.hasCartIndicatorTarget) {
      this.cartIndicatorTarget.textContent = this.countValue
    }
  }
}
