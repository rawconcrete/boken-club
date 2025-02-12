// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations", "selectedAdventures", "adventureSearch", "adventureResults"]

  connect() {
    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()
    this.loadInitialSelections()
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

    const response = await fetch(`/adventures.json?query=${encodeURIComponent(query)}`)
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
    this.adventureResultsTarget.innerHTML = adventures.map(adventure => `
      <div class="list-group-item" data-action="click->travel-plan#selectAdventure"
           data-adventure='${JSON.stringify(adventure)}'>
        ${adventure.name}
      </div>
    `).join('')
  }

  updateAvailableAdventures() {
    const locationIds = Array.from(this.selectedLocations).join(',')
    const query = locationIds ? `?location_ids=${locationIds}` : ''

    Promise.all([fetch(`/adventures.json${query}`), fetch('/locations.json')])
      .then(([adventuresRes, locationsRes]) => Promise.all([adventuresRes.json(), locationsRes.json()]))
      .then(([adventures, locations]) => {
        const selectedLocations = new Map(
          locations.filter(l => this.selectedLocations.has(l.id))
            .map(l => [l.id, l])
        )

        const availableHTML = adventures.map(adventure => {
          const unavailableLocations = Array.from(selectedLocations.values())
            .filter(location => !adventure.available_locations?.includes(location.id))
            .map(l => l.name)
            .join(', ')

          return `
            <div class="list-group-item">
              ${adventure.name}
              ${unavailableLocations ?
                `<div class="mt-2">
                  <small class="text-muted">Not available at: ${unavailableLocations}</small>
                  <button type="button"
                          class="btn btn-sm btn-outline-primary float-end"
                          data-action="click->travel-plan#selectAdventure"
                          data-adventure='${JSON.stringify(adventure)}'>
                    Add Anyway
                  </button>
                 </div>` :
                `<button type="button"
                         class="btn btn-sm btn-primary float-end"
                         data-action="click->travel-plan#selectAdventure"
                         data-adventure='${JSON.stringify(adventure)}'>
                   Add
                 </button>`
              }
            </div>
          `
        }).join('')

        this.adventureResultsTarget.innerHTML = availableHTML
      })
  }

  async fetchAndAddLocation(id) {
    const response = await fetch(`/locations/${id}.json`)
    const location = await response.json()
    this.addLocationTag(location)
    this.updateAvailableAdventures()
  }

  async fetchAndAddAdventure(id) {
    const response = await fetch(`/adventures/${id}.json`)
    const adventure = await response.json()
    this.addAdventureTag(adventure)
  }

  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location)
    this.addLocationTag(location)
    this.updateAvailableAdventures()
  }

  selectAdventure(event) {
    const adventure = JSON.parse(event.currentTarget.dataset.adventure)
    this.addAdventureTag(adventure)
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
    this.updateAvailableAdventures()
  }

  removeAdventure(event) {
    const adventureId = event.currentTarget.dataset.adventureId
    this.selectedAdventures.delete(adventureId)
    event.currentTarget.closest('.badge').remove()
  }
}
