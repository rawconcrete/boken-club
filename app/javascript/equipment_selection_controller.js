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
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id !== equipmentId)
    }

    localStorage.setItem('selectedEquipment', JSON.stringify(selectedEquipment))
    this.updatePlanButtonUrl()
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
}
