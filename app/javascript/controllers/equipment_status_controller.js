// app/javascript/controllers/equipment_status_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    console.log("Equipment status controller connected")
  }

  toggle(event) {
    const checkbox = event.currentTarget
    const equipmentId = checkbox.dataset.equipmentId
    const travelPlanId = checkbox.dataset.travelPlanId
    const checked = checkbox.checked

    // Prevent the default behavior to maintain the checked state
    event.preventDefault()

    // Update the status of the equipment in the travel plan
    fetch(`/travel_plans/${travelPlanId}/equipment/${equipmentId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ checked })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log('Equipment status updated:', data);
      // Manually update the checkbox state after successful response
      checkbox.checked = checked;
    })
    .catch(error => {
      console.error('Error updating equipment status:', error);
      // Revert checkbox state if there was an error
      checkbox.checked = !checked;
    });
  }

  markPurchased(event) {
    event.preventDefault();

    const button = event.currentTarget;
    const equipmentId = button.dataset.equipmentId;
    const travelPlanId = button.dataset.travelPlanId;

    // Get CSRF token from meta tag
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;

    if (!csrfToken) {
      console.error('CSRF token not found');
      return;
    }

    // Send request to mark equipment as purchased
    fetch(`/travel_plans/${travelPlanId}/mark_equipment_purchased`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      body: JSON.stringify({ equipment_id: equipmentId })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log('Equipment marked as purchased:', data);
      // Reload the page to reflect the changes
      window.location.reload();
    })
    .catch(error => {
      console.error('Error marking equipment as purchased:', error);
    });
  }
}
