import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "locationSearch", "locationResults", "selectedLocations",
    "selectedAdventures", "adventureResults", "selectedEquipment", "checkbox"
  ];
  static values = {
    locations: Array,
    adventures: Array,
    equipment: Array
  };

  connect() {
    this.selectedLocations = new Set();
    this.selectedAdventures = new Set();
    this.selectedEquipment = new Set();
    this.initializeExistingSelections();
    this.loadSelectedEquipment();
  }

  /*** EQUIPMENT SELECTION & LOADING ***/
  loadSelectedEquipment() {
    const storedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");
    const storedEquipmentIds = new Set(storedEquipment.map(e => e.id)); // Set of stored IDs

    this.checkboxTargets.forEach((checkbox) => {
      const equipmentId = checkbox.dataset.equipmentId;
      checkbox.checked = storedEquipmentIds.has(parseInt(equipmentId)); // ONLY check if stored
    });
  }

  toggleEquipment(event) {
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
  }

  /*** LOCATION & ADVENTURE SELECTION ***/
  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location);
    this.addLocationTag(location);
    this.locationSearchTarget.value = "";
    this.locationResultsTarget.innerHTML = "";
    this.updateEquipment();
  }

  selectAdventure(event) {
    const adventure = JSON.parse(event.currentTarget.dataset.adventure);
    this.addAdventureTag(adventure);
    this.updateEquipment();
  }

  addLocationTag(location) {
    if (this.selectedLocations.has(location.id)) return;

    this.selectedLocations.add(location.id);
    this.selectedLocationsTarget.insertAdjacentHTML("beforeend", `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${location.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeLocation"
                data-location-id="${location.id}"></button>
        <input type="hidden" name="travel_plan[location_ids][]" value="${location.id}">
      </div>
    `);
    this.updateEquipment();
  }

  addAdventureTag(adventure) {
    if (this.selectedAdventures.has(adventure.id)) return;

    this.selectedAdventures.add(adventure.id);
    this.selectedAdventuresTarget.insertAdjacentHTML("beforeend", `
      <div class="badge bg-success p-2 m-1 d-inline-flex align-items-center">
        ${adventure.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeAdventure"
                data-adventure-id="${adventure.id}"></button>
        <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventure.id}">
      </div>
    `);
    this.updateEquipment();
  }

  /*** EQUIPMENT UPDATING BASED ON LOCATIONS & ADVENTURES ***/
  async updateEquipment() {
    const locationIds = Array.from(this.selectedLocations);
    const adventureIds = Array.from(this.selectedAdventures);

    try {
      const response = await fetch(`/travel_plans/equipment_suggestions?location_ids=${locationIds.join(",")}&adventure_ids=${adventureIds.join(",")}`);
      const recommendedEquipment = await response.json();

      const storedEquipment = JSON.parse(localStorage.getItem("selectedEquipment") || "[]");
      const storedEquipmentIds = new Set(storedEquipment.map(e => e.id)); // Set of stored IDs

      this.selectedEquipment.clear();
      this.selectedEquipmentTarget.innerHTML = recommendedEquipment.map(item => `
        <div class="form-check">
          <input type="checkbox" class="form-check-input"
                 id="equipment_${item.id}"
                 data-action="change->travel-plan#toggleEquipment"
                 data-equipment-id="${item.id}"
                 data-equipment-name="${item.name}"
                 ${storedEquipmentIds.has(item.id) ? "checked" : ""}>
          <label for="equipment_${item.id}" class="form-check-label">${item.name}</label>
        </div>
      `).join("");

    } catch (error) {
      console.error("Error fetching equipment suggestions:", error);
    }
  }
}
