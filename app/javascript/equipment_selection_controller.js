// app/javascript/equipment_selection_controller.js
export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.loadSelectedEquipment()
  }

  loadSelectedEquipment() {
    const selectedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]")

    this.checkboxTargets.forEach((checkbox) => {
      const equipmentId = checkbox.dataset.equipmentId
      checkbox.checked = selectedEquipment.some(e => e.id == equipmentId)
    })
  }

  toggle(event) {
    const checkbox = event.target
    const equipmentId = checkbox.dataset.equipmentId
    const equipmentName = checkbox.dataset.equipmentName

    let selectedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]")

    if (checkbox.checked) {
      selectedEquipment.push({ id: equipmentId, name: equipmentName })
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id != equipmentId)
    }

    localStorage.setItem("selectedEquipment", JSON.stringify(selectedEquipment))
  }
}
