// app/javascript/equipment_selection_controller.js
export default class extends Controller {
  static targets = ["checkbox", "planButton"]

  connect() {
    this.loadSelectedEquipment()
    this.updatePlanButtonUrl()
  }

  toggle(event) {
    const checkbox = event.target
    const equipmentId = checkbox.dataset.equipmentId
    const equipmentName = checkbox.dataset.equipmentName

    let selectedEquipment = this.getSelectedEquipment()

    if (checkbox.checked) {
      selectedEquipment.push({ id: equipmentId, name: equipmentName })
      this.addEquipmentToForm(equipmentId, equipmentName)
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id !== equipmentId)
      this.removeEquipmentFromForm(equipmentId)
    }

    localStorage.setItem('selectedEquipment', JSON.stringify(selectedEquipment))
    this.updatePlanButtonUrl()
  }

  addEquipmentToForm(equipmentId, equipmentName) {
    // Ensure equipment is added to the travel plan form dynamically
    const selectedEquipmentDiv = document.querySelector("[data-travel-plan-target='selectedEquipment']")
    if (!selectedEquipmentDiv) return

    const existingItem = selectedEquipmentDiv.querySelector(`[data-equipment-id='${equipmentId}']`)
    if (existingItem) return // Prevent duplicates

    selectedEquipmentDiv.insertAdjacentHTML("beforeend", `
      <div class="badge bg-info p-2 m-1 d-inline-flex align-items-center" data-equipment-id="${equipmentId}">
        ${equipmentName}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeEquipment"
                data-equipment-id="${equipmentId}"></button>
        <input type="hidden" name="travel_plan[equipment_ids][]" value="${equipmentId}">
      </div>
    `)
  }

  removeEquipmentFromForm(equipmentId) {
    const selectedEquipmentDiv = document.querySelector("[data-travel-plan-target='selectedEquipment']")
    if (!selectedEquipmentDiv) return

    const item = selectedEquipmentDiv.querySelector(`[data-equipment-id='${equipmentId}']`)
    if (item) item.remove()
  }

  updatePlanButtonUrl() {
    if (this.hasPlanButtonTarget) {
      const button = this.planButtonTarget
      const url = new URL(button.href)
      const selectedIds = this.getSelectedEquipment().map(e => e.id)
      url.searchParams.set('equipment_ids', selectedIds.join(','))
      button.href = url.toString()
    }
  }

  getSelectedEquipment() {
    return JSON.parse(localStorage.getItem('selectedEquipment') || '[]')
  }
}
