// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "locationSearch", "locationResults", "selectedLocation", "locationId",
    "adventureSearch", "adventureResults", "selectedAdventure", "adventureId",
    "relatedInfo"
  ]

  connect() {
    this.loadInitialData()
  }

  async loadInitialData() {
    // Load initial tips and warnings if location/adventure is pre-selected
    if (this.hasLocationIdTarget && this.locationIdTarget.value) {
      await this.fetchLocationInfo(this.locationIdTarget.value)
    }
    if (this.hasAdventureIdTarget && this.adventureIdTarget.value) {
      await this.fetchAdventureInfo(this.adventureIdTarget.value)
    }
  }

  async searchLocations(event) {
    const query = event.target.value
    if (query.length < 2) {
      this.locationResultsTarget.classList.add('hidden')
      return
    }

    const response = await fetch(`/locations/search?query=${encodeURIComponent(query)}`)
    const locations = await response.json()

    this.locationResultsTarget.innerHTML = locations.map(location => `
      <div class="p-3 hover:bg-gray-50 cursor-pointer" data-action="click->travel-plan#selectLocation" data-location-id="${location.id}">
        <p class="font-medium">${location.name}</p>
        <p class="text-sm text-gray-600">${location.city}, ${location.prefecture}</p>
      </div>
    `).join('')

    this.locationResultsTarget.classList.remove('hidden')
  }

  async searchAdventures(event) {
    const query = event.target.value
    if (query.length < 2) {
      this.adventureResultsTarget.classList.add('hidden')
      return
    }

    const response = await fetch(`/adventures/search?query=${encodeURIComponent(query)}`)
    const adventures = await response.json()

    this.adventureResultsTarget.innerHTML = adventures.map(adventure => `
      <div class="p-3 hover:bg-gray-50 cursor-pointer" data-action="click->travel-plan#selectAdventure" data-adventure-id="${adventure.id}">
        <p class="font-medium">${adventure.name}</p>
        <p class="text-sm text-gray-600">${adventure.details}</p>
      </div>
    `).join('')

    this.adventureResultsTarget.classList.remove('hidden')
  }

  async selectLocation(event) {
    const locationId = event.currentTarget.dataset.locationId
    await this.fetchLocationInfo(locationId)
    this.locationResultsTarget.classList.add('hidden')
    this.locationSearchTarget.value = ''
  }

  async selectAdventure(event) {
    const adventureId = event.currentTarget.dataset.adventureId
    await this.fetchAdventureInfo(adventureId)
    this.adventureResultsTarget.classList.add('hidden')
    this.adventureSearchTarget.value = ''
  }

  async fetchLocationInfo(locationId) {
    const response = await fetch(`/locations/${locationId}`)
    const location = await response.json()

    this.locationIdTarget.value = location.id
    this.updateSelectedLocation(location)
    this.updateRelatedInfo()
  }

  async fetchAdventureInfo(adventureId) {
    const response = await fetch(`/adventures/${adventureId}`)
    const adventure = await response.json()

    this.adventureIdTarget.value = adventure.id
    this.updateSelectedAdventure(adventure)
    this.updateRelatedInfo()
  }

  updateSelectedLocation(location) {
    if (this.hasSelectedLocationTarget) {
      this.selectedLocationTarget.innerHTML = `
        <button type="button" class="absolute top-2 right-2 text-gray-400 hover:text-red-500"
                data-action="click->travel-plan#removeLocation">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <p class="font-medium text-blue-900">${location.name}</p>
        <p class="text-sm text-blue-700">${location.city}, ${location.prefecture}</p>
      `
    }
  }

  updateSelectedAdventure(adventure) {
    if (this.hasSelectedAdventureTarget) {
      this.selectedAdventureTarget.innerHTML = `
        <button type="button" class="absolute top-2 right-2 text-gray-400 hover:text-red-500"
                data-action="click->travel-plan#removeAdventure">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <p class="font-medium text-green-900">${adventure.name}</p>
        <p class="text-sm text-green-700">${adventure.details}</p>
      `
    }
  }

  removeLocation() {
    this.locationIdTarget.value = ''
    if (this.hasSelectedLocationTarget) {
      this.selectedLocationTarget.innerHTML = ''
    }
    this.updateRelatedInfo()
  }

  removeAdventure() {
    this.adventureIdTarget.value = ''
    if (this.hasSelectedAdventureTarget) {
      this.selectedAdventureTarget.innerHTML = ''
    }
    this.updateRelatedInfo()
  }

  async updateRelatedInfo() {
    const locationId = this.locationIdTarget.value
    const adventureId = this.adventureIdTarget.value

    if (!locationId && !adventureId) {
      this.relatedInfoTarget.innerHTML = ''
      return
    }

    const tips = []
    const warnings
