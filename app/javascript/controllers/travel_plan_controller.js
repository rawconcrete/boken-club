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
    console.log("TravelPlan Controller Connected ✅");
    this.selectedLocations = new Set();
    this.selectedAdventures = new Set();
    this.initializeExistingSelections();
    this.loadInitialSelections();
  }

  addAdventureAnyway(event) {
    console.log("✅ Add Anyway button clicked");

    const adventureData = event.currentTarget.dataset.adventure; // Use `currentTarget`
    if (!adventureData) {
      console.error("❌ No adventure data found on button");
      return;
    }

    const adventure = JSON.parse(adventureData);
    console.log("✅ Parsed Adventure:", adventure);

    if (this.selectedAdventures.has(adventure.id)) {
      console.warn("❗ Adventure already added:", adventure.id);
      return;
    }

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
      </div>
    `
    );

    this.dispatch("refresh"); // Helps Stimulus detect new elements
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
          <button class="btn btn-warning btn-sm float-end"
                  data-action="click->travel-plan#addAdventureAnyway"
                  data-adventure='${JSON.stringify(adventure)}'>
            Add Anyway
          </button>
        </div>`;
      })
      .join("");

    this.refreshStimulus(); // Re-bind events
  }

  refreshStimulus() {
    setTimeout(() => {
      this.element
        .querySelectorAll('[data-action="click->travel-plan#addAdventureAnyway"]')
        .forEach((btn) => {
          btn.addEventListener("click", (event) => this.addAdventureAnyway(event));
        });
      console.log("✅ Rebound Stimulus Events");
    }, 50);
  }
}
