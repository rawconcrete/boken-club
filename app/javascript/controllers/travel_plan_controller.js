import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectedEquipment", "checkbox"];
  static values = { equipment: Array };

  connect() {
    console.log("Stimulus travel plan controller connected.");
    this.loadSelectedEquipment();
  }

  /*** Load from LocalStorage ONLY (ignore defaults) ***/
  loadSelectedEquipment() {
    const storedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");
    const storedEquipmentIds = new Set(storedEquipment.map(e => parseInt(e.id)));

    this.checkboxTargets.forEach((checkbox) => {
      const equipmentId = parseInt(checkbox.dataset.equipmentId);
      checkbox.checked = storedEquipmentIds.has(equipmentId); // Only check if in localStorage
    });
  }

  /*** Store Checked Equipment in LocalStorage ***/
  toggle(event) {
    const checkbox = event.target;
    const equipmentId = parseInt(checkbox.dataset.equipmentId);
    const equipmentName = checkbox.dataset.equipmentName;

    console.log(`Toggling: ${equipmentName} (ID: ${equipmentId})`);

    let selectedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");

    if (checkbox.checked) {
      if (!selectedEquipment.some(e => e.id === equipmentId)) {
        selectedEquipment.push({ id: equipmentId, name: equipmentName });
      }
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id !== equipmentId);
    }

    localStorage.setItem("selectedEquipment", JSON.stringify(selectedEquipment));
    console.log("Updated localStorage:", localStorage.getItem("selectedEquipment"));
  }


}
