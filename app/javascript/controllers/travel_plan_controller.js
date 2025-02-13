// travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations", "selectedAdventures", "adventureSearch", "adventureResults"]
  static values = {
    locations: Array,
    adventures: Array
  }

  connect() {
    console.log("Travel plan controller connected - VERSION 2")
    console.log("Controller element:", this.element)
    console.log("Available targets:", {
      locationSearch: this.hasLocationSearchTarget,
      locationResults: this.hasLocationResultsTarget,
      selectedLocations: this.hasSelectedLocationsTarget,
      selectedAdventures: this.hasSelectedAdventuresTarget,
      adventureSearch: this.hasAdventureSearchTarget,
      adventureResults: this.hasAdventureResultsTarget
    })

    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()
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

    this.updateAvailableAdventures()
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
           data-location-id="${location.id}">
        ${location.name} - ${location.city}, ${location.prefecture}
      </div>
    `).join('')
  }

  renderAdventureResults(adventures) {
    this.adventureResultsTarget.innerHTML = adventures.map(adventure => `
      <div class="list-group-item" data-action="click->travel-plan#selectAdventure"
           data-adventure-id="${adventure.id}">
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
        console.log("Fetched adventures:", adventures)
        const selectedLocations = new Map(
          locations.filter(l => this.selectedLocations.has(l.id))
            .map(l => [l.id, l])
        )

        const availableHTML = adventures.map(adventure => {
          console.log("Processing adventure:", adventure)
          const unavailableLocations = Array.from(selectedLocations.values())
            .filter(location => !adventure.available_locations?.includes(location.id))
            .map(l => l.name)
            .join(', ')

          // Note: Using just the ID, not the whole adventure object
          const buttonHtml = `<button type="button"
                    class="btn btn-sm ${unavailableLocations ? 'btn-outline-primary' : 'btn-primary'} float-end"
                    data-action="click->travel-plan#addAnyway"
                    data-adventure-id="${adventure.id}">
              ${unavailableLocations ? 'Add Anyway' : 'Add'}
            </button>`

          console.log("Generated button HTML:", buttonHtml)

          return `
            <div class="list-group-item">
              ${adventure.name}
              ${unavailableLocations ?
                `<div class="mt-2">
                  <small class="text-muted">Not available at: ${unavailableLocations}</small>
                </div>` : ''}
              ${buttonHtml}
            </div>`
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

  async selectLocation(event) {
    const locationId = event.currentTarget.dataset.locationId
    const response = await fetch(`/locations/${locationId}.json`)
    const location = await response.json()
    this.addLocationTag(location)
    this.updateAvailableAdventures()
  }

  async selectAdventure(event) {
    event.stopPropagation()
    const adventureId = event.currentTarget.dataset.adventureId
    await this.fetchAndAddAdventure(adventureId)
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
    console.log("Adding adventure tag:", adventure)
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

  async addAnyway(event) {
    console.log("addAnyway called - VERSION 2")
    console.log("Event target:", event.currentTarget)
    console.log("All data attributes:", event.currentTarget.dataset)
    console.log("HTML of button:", event.currentTarget.outerHTML)

    const adventureId = event.currentTarget.dataset.adventureId
    if (!adventureId) {
      console.error("No adventure ID found in button data attributes")
      console.error("Available data attributes:", Object.keys(event.currentTarget.dataset))
      return
    }

    try {
      console.log("Fetching adventure with ID:", adventureId)
      await this.fetchAndAddAdventure(adventureId)
    } catch (error) {
      console.error("Error fetching adventure:", error)
    }
  }
}
