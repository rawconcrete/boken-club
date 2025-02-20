import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "locationSearch", "locationResults", "selectedLocations",
    "selectedAdventures", "adventureResults", "selectedEquipment"
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

  loadSelectedEquipment() {
    const selectedEquipment = JSON.parse(sessionStorage.getItem('selectedEquipment') || '[]');
    selectedEquipment.forEach(equipment => {
      this.addEquipmentTag(equipment);
    });
  }

  addEquipmentTag(equipment) {
    if (this.selectedEquipment.has(equipment.id)) return;

    this.selectedEquipment.add(equipment.id);
    this.selectedEquipmentTarget.insertAdjacentHTML("beforeend", `
      <div class="badge bg-info p-2 m-1 d-inline-flex align-items-center">
        ${equipment.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeEquipment"
                data-equipment-id="${equipment.id}"></button>
        <input type="hidden" name="travel_plan[equipment_ids][]" value="${equipment.id}">
      </div>
    `);
  }


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

  async updateEquipment() {
    const locationIds = Array.from(this.selectedLocations);
    const adventureIds = Array.from(this.selectedAdventures);

    try {
      const response = await fetch(`/travel_plans/equipment_suggestions?location_ids=${locationIds.join(",")}&adventure_ids=${adventureIds.join(",")}`);
      const equipment = await response.json();

      this.selectedEquipment.clear();
      this.selectedEquipmentTarget.innerHTML = equipment.map(item => `
        <div class="badge bg-info p-2 m-1 d-inline-flex align-items-center">
          ${item.name}
          <input type="hidden" name="travel_plan[equipment_ids][]" value="${item.id}">
        </div>
      `).join("");
    } catch (error) {
      console.error("Error fetching equipment suggestions:", error);
    }
  }
}
