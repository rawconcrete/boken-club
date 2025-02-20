// app/javascript/controllers/equipment_selection_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.loadSelectedEquipment()
  }

  toggle(event) {
    const checkbox = event.target
    const equipmentId = checkbox.dataset.equipmentId
    const equipmentName = checkbox.dataset.equipmentName

    let selectedEquipment = this.getSelectedEquipment()

    if (checkbox.checked) {
      selectedEquipment.push({ id: equipmentId, name: equipmentName })
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id !== equipmentId)
    }

    localStorage.setItem('selectedEquipment', JSON.stringify(selectedEquipment))
  }

  loadSelectedEquipment() {
    const selectedEquipment = this.getSelectedEquipment()
    this.checkboxTargets.forEach(checkbox => {
      const equipmentId = checkbox.dataset.equipmentId
      checkbox.checked = selectedEquipment.some(e => e.id === equipmentId)
    })
  }

  getSelectedEquipment() {
    return JSON.parse(localStorage.getItem('selectedEquipment') || '[]')
  }
}
