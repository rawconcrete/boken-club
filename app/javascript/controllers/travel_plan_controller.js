import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
                    "selectedAdventures", "adventureResults"];
  static values = { locations: Array, adventures: Array };

  connect() {
    console.log("Stimulus travel plan controller connected.");
  }

  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location);
    this.addLocationTag(location);
    this.locationSearchTarget.value = "";
    this.locationResultsTarget.innerHTML = "";
  }

  selectAdventure(event) {
    const adventure = JSON.parse(event.currentTarget.dataset.adventure);
    this.addAdventureTag(adventure);
  }

  addLocationTag(location) {
    if (!this.selectedLocationsTarget.querySelector(`[data-location-id="${location.id}"]`)) {
      this.selectedLocationsTarget.insertAdjacentHTML("beforeend", `
        <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
          ${location.name}
          <button type="button" class="btn-close ms-2"
                  data-action="click->travel-plan#removeLocation"
                  data-location-id="${location.id}"></button>
          <input type="hidden" name="travel_plan[location_ids][]" value="${location.id}">
        </div>
      `);
    }
  }

  addAdventureTag(adventure) {
    if (!this.selectedAdventuresTarget.querySelector(`[data-adventure-id="${adventure.id}"]`)) {
      this.selectedAdventuresTarget.insertAdjacentHTML("beforeend", `
        <div class="badge bg-success p-2 m-1 d-inline-flex align-items-center">
          ${adventure.name}
          <button type="button" class="btn-close ms-2"
                  data-action="click->travel-plan#removeAdventure"
                  data-adventure-id="${adventure.id}"></button>
          <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventure.id}">
        </div>
      `);
    }
  }
}
