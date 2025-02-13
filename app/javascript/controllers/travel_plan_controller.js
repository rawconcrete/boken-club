// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "locationSearch",
    "locationResults",
    "selectedLocations",
    "selectedAdventures",
    "adventureSearch",
    "adventureResults"
  ];
  static values = {
    locations: Array,
    adventures: Array
  };

  connect() {
    console.log("TravelPlan Controller Connected");
    this.selectedLocations = new Set();
    this.selectedAdventures = new Set();
    this.initializeExistingSelections();
    this.loadInitialSelections();
  }

  initializeExistingSelections() {
    if (this.hasLocationsValue) {
      this.locationsValue.forEach((location) => this.addLocationTag(location));
    }

    if (this.hasAdventuresValue) {
      this.adventuresValue.forEach((adventure) =>
        this.addAdventureTag(adventure)
      );
    }

    this.updateAvailableAdventures();
  }

  addAdventureAnyway(event) {
    console.log("Add Anyway button clicked");

    const adventureData = event.target.dataset.adventure;
    console.log("Adventure Data:", adventureData);

    if (!adventureData) {
      console.error("No adventure data found on button");
      return;
    }

    const adventure = JSON.parse(adventureData);
    console.log("Parsed Adventure:", adventure);

    const disclaimer = `Note: ${adventure.name} is not typically available at selected locations`;

    this.selectedAdventures.add(adventure.id);

    this.selectedAdventuresTarget.insertAdjacentHTML(
      "beforeend",
      `
      <div class="badge bg-warning p-2 m-1 d-inline-flex align-items-center">
        ${adventure.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeAdventure"
                data-adventure-id="${adventure.id}"></button>
        <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventure.id}">
        <input type="hidden" name="travel_plan[adventure_disclaimers][${adventure.id}]" value="${disclaimer}">
      </div>
    `
    );
  }

  renderAdventureResults(adventures) {
    console.log("Rendering Adventures:", adventures);

    this.adventureResultsTarget.innerHTML = adventures
      .map((adventure) => {
        const unavailableLocations = Array.from(this.selectedLocations)
          .map((locationId) => {
            const location = this.locationsValue.find(
              (l) => l.id === parseInt(locationId)
            );
            return location ? location.name : "";
          })
          .filter(Boolean)
          .join(", ");

        const buttonHtml = unavailableLocations
          ? `<button class="btn btn-warning btn-sm float-end"
                  click->travel-plan#addAdventureAnyway
                  data-adventure='${JSON.stringify(adventure)}'>
            Add Anyway
          </button>`
          : `<button class="btn btn-primary btn-sm float-end"
                  data-action="click->travel-plan#selectAdventure"
                  data-adventure='${JSON.stringify(adventure)}'>
            Add
          </button>`;

        return `
        <div class="list-group-item">
          ${adventure.name}
          ${
            unavailableLocations
              ? `<div class="mt-2">
                <small class="text-muted">Not available at: ${unavailableLocations}</small>
              </div>`
              : ""
          }
          ${buttonHtml}
        </div>`;
      })
      .join("");
  }
}
