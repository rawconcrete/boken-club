import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "hiddenInput"];

  connect() {
    // load selected equipment when controller connects
    this.loadSelectedEquipment();

    // add event listener for form submission
    const form = this.element.closest('form');
    if (form) {
      form.addEventListener('submit', this.handleFormSubmit.bind(this));
    }
  }

  loadSelectedEquipment() {
    const storedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");
    const storedIds = new Set(storedEquipment.map(e => parseInt(e.id)));

    this.checkboxTargets.forEach((checkbox) => {
      const equipmentId = parseInt(checkbox.dataset.equipmentId);
      checkbox.checked = storedIds.has(equipmentId);
    });
  }

  toggle(event) {
    const checkbox = event.target;
    const equipmentId = parseInt(checkbox.dataset.equipmentId);
    const equipmentName = checkbox.dataset.equipmentName;

    let selectedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");

    if (checkbox.checked) {
      if (!selectedEquipment.some(e => e.id === equipmentId)) {
        selectedEquipment.push({ id: equipmentId, name: equipmentName });
      }
    } else {
      selectedEquipment = selectedEquipment.filter(e => e.id !== equipmentId);
    }

    localStorage.setItem("selectedEquipment", JSON.stringify(selectedEquipment));

    // update hidden form inputs if they exist
    this.updateHiddenInputs(selectedEquipment);
  }

  updateHiddenInputs(selectedEquipment) {
    const formContainer = this.element.closest('form');
    if (!formContainer) return;

    // remove existing equipment hidden inputs
    const existingInputs = formContainer.querySelectorAll('input[name="travel_plan[equipment_ids][]"]');
    existingInputs.forEach(input => input.remove());

    // add new hidden inputs for each selected equipment
    selectedEquipment.forEach(equipment => {
      const hiddenInput = document.createElement('input');
      hiddenInput.type = 'hidden';
      hiddenInput.name = 'travel_plan[equipment_ids][]';
      hiddenInput.value = equipment.id;
      formContainer.appendChild(hiddenInput);
    });
  }

  handleFormSubmit(event) {
    const selectedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");
    this.updateHiddenInputs(selectedEquipment);
  }
}
