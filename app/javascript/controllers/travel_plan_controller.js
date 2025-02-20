// travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
                    "selectedAdventures", "adventureResults", "selectedEquipment"]
  static values = {
    locations: Array,
    adventures: Array,
    equipment: Array
  }

  connect() {
    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()
    this.selectedEquipment = new Set()
    this.initializeExistingSelections()
    this.loadSelectedEquipment()
  }

  loadSelectedEquipment() {
    const selectedEquipment = JSON.parse(sessionStorage.getItem('selectedEquipment') || '[]')
    selectedEquipment.forEach(equipment => {
      const checkbox = document.getElementById(`equipment_${equipment.id}`)
      if (checkbox) {
        checkbox.checked = true
        this.selectedEquipment.add(equipment.id)
      }
    })
  }

  async searchLocations(event) {
    const query = event.target.value.trim()
    if (query.length < 2) {
      this.locationResultsTarget.innerHTML = ''
      return
    }

    try {
      const response = await fetch(`/locations.json?query=${encodeURIComponent(query)}`)
      const locations = await response.json()
      this.renderLocationResults(locations)
    } catch (error) {
      console.error('Error searching locations:', error)
    }
  }

  renderLocationResults(locations) {
    this.locationResultsTarget.innerHTML = locations
      .filter(location => !this.selectedLocations.has(location.id))
      .map(location => `
        <div class="list-group-item" data-action="click->travel-plan#selectLocation"
             data-location='${JSON.stringify(location)}'>
          ${location.name} - ${location.city}, ${location.prefecture}
        </div>
      `).join('')
  }

  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location)
    this.addLocationTag(location)
    this.locationSearchTarget.value = ''
    this.locationResultsTarget.innerHTML = ''
  }

  addLocationTag(location) {
    if (this.selectedLocations.has(location.id)) return

    this.selectedLocations.add(location.id)
    this.selectedLocationsTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${location.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeLocation"
                data-location-id="${location.id}"></button>
        <input type="hidden" name="travel_plan[location_ids][]" value="${location.id}">
      </div>
    `)
  }

  removeLocation(event) {
    const locationId = event.currentTarget.dataset.locationId
    this.selectedLocations.delete(locationId)
    event.currentTarget.closest('.badge').remove()
  }
}

  removeAdventure(event) {
    const adventureId = event.currentTarget.dataset.adventureId
    this.selectedAdventures.delete(adventureId)
    event.currentTarget.closest('.badge').remove()
  }
}
