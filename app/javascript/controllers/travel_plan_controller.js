// travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations", "selectedAdventures", "adventureSearch", "adventureResults"]
  static values = {
    locations: Array,
    adventures: Array
  }

  connect() {
    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()
    // clear any existing adventure results
    if (this.hasAdventureResultsTarget) {
      this.adventureResultsTarget.innerHTML = ''
    }
    this.initializeExistingSelections()
    this.loadInitialSelections()
  }

  initializeExistingSelections() {
    if (this.hasLocationsValue) {
      this.locationsValue.forEach(location => this.addLocationTag(location))
    }

    if (this.hasAdventuresValue) {
      this.adventuresValue.forEach(adventure => this.addAdventureTag(adventure))
    }
  }

  async loadInitialSelections() {
    const urlParams = new URLSearchParams(window.location.search)
    const locationId = urlParams.get('location_id')
    const adventureId = urlParams.get('adventure_id')

    if (locationId) await this.fetchAndAddLocation(locationId)
    if (adventureId) await this.fetchAndAddAdventure(adventureId)
  }

  async searchAdventures(event) {
    const query = event.target.value.trim()
    this.adventureResultsTarget.innerHTML = ''

    if (query.length < 2) return

    const locationIds = Array.from(this.selectedLocations).join(',')
    const queryParams = new URLSearchParams({
      query: query,
      ...(locationIds && { location_ids: locationIds })
    })

    const response = await fetch(`/adventures.json?${queryParams}`)
    const adventures = await response.json()
    this.renderAdventureResults(adventures)
  }

  async searchLocations(event) {
    const query = event.target.value.trim()
    this.locationResultsTarget.innerHTML = ''

    if (query.length < 2) return

    const response = await fetch(`/locations.json?query=${encodeURIComponent(query)}`)
    const locations = await response.json()
    this.renderLocationResults(locations)
  }

  renderLocationResults(locations) {
    this.locationResultsTarget.innerHTML = locations.map(location => `
      <div class="list-group-item" data-action="click->travel-plan#selectLocation"
           data-location='${JSON.stringify(location)}'>
        ${location.name} - ${location.city}, ${location.prefecture}
      </div>
    `).join('')
  }

  renderAdventureResults(adventures) {
    this.adventureResultsTarget.innerHTML = adventures.map(adventure => {
      const unavailableLocations = Array.from(this.selectedLocations).length > 0
        ? this.getUnavailableLocations(adventure)
        : []

      const buttonHtml = unavailableLocations.length > 0
        ? `<button type="button"
                class="btn btn-sm btn-outline-primary float-end add-anyway-btn"
                data-action="click->travel-plan#selectAdventure"
                data-adventure='${JSON.stringify(adventure)}'>
            Add Anyway
          </button>`
        : `<button type="button"
                class="btn btn-sm btn-primary float-end add-btn"
                data-action="click->travel-plan#selectAdventure"
                data-adventure='${JSON.stringify(adventure)}'>
            Add
          </button>`

      return `
        <div class="list-group-item">
          ${adventure.name}
          ${unavailableLocations.length > 0
            ? `<div class="mt-2">
                <small class="text-muted">Not available at: ${unavailableLocations.join(', ')}</small>
                ${buttonHtml}
               </div>`
            : buttonHtml
          }
        </div>`
    }).join('')
  }

  getUnavailableLocations(adventure) {
    return Array.from(this.selectedLocations)
      .filter(locationId => !adventure.available_locations?.includes(parseInt(locationId)))
      .map(locationId => {
        const location = this.locationsValue.find(l => l.id === parseInt(locationId))
        return location ? location.name : ''
      })
      .filter(name => name)
  }

  async fetchAndAddLocation(id) {
    const response = await fetch(`/locations/${id}.json`)
    const location = await response.json()
    this.addLocationTag(location)
    // Clear adventure results when a new location is added
    this.adventureResultsTarget.innerHTML = ''
    this.adventureSearchTarget.value = ''
  }

  async fetchAndAddAdventure(id) {
    const response = await fetch(`/adventures/${id}.json`)
    const adventure = await response.json()
    this.addAdventureTag(adventure)
  }

  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location)
    this.addLocationTag(location)
    // Clear adventure results when a new location is selected
    this.adventureResultsTarget.innerHTML = ''
    this.adventureSearchTarget.value = ''
    this.locationSearchTarget.value = ''
    this.locationResultsTarget.innerHTML = ''
  }

  selectAdventure(event) {
    event.stopPropagation()
    const adventure = JSON.parse(event.currentTarget.dataset.adventure)
    this.addAdventureTag(adventure)
    // Clear search after selection
    this.adventureSearchTarget.value = ''
    this.adventureResultsTarget.innerHTML = ''
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

  addAdventureTag(adventure) {
    if (this.selectedAdventures.has(adventure.id)) return

    this.selectedAdventures.add(adventure.id)
    this.selectedAdventuresTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${adventure.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeAdventure"
                data-adventure-id="${adventure.id}"></button>
        <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventure.id}">
      </div>
    `)
  }

  removeLocation(event) {
    const locationId = event.currentTarget.dataset.locationId
    this.selectedLocations.delete(locationId)
    event.currentTarget.closest('.badge').remove()
    // Clear adventure results when a location is removed
    this.adventureResultsTarget.innerHTML = ''
    this.adventureSearchTarget.value = ''
  }

  removeAdventure(event) {
    const adventureId = event.currentTarget.dataset.adventureId
    this.selectedAdventures.delete(adventureId)
    event.currentTarget.closest('.badge').remove()
  }
}
