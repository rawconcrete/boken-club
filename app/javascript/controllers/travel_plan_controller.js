// travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
                    "selectedAdventures", "adventureResults"]
  static values = {
    locations: Array,
    adventures: Array
  }

  connect() {
    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()
    this.initializeExistingSelections()
    this.loadInitialSelections()
    this.updateAvailableAdventures()
    this.loadSelectedEquipment()
    const selectedEquipment = JSON.parse(sessionStorage.getItem('selectedEquipment') || '[]')
    selectedEquipment.forEach(equipment => {
      const checkbox = document.getElementById(`equipment_${equipment.id}`)
      if (checkbox) checkbox.checked = true
    })
  }

  loadSelectedEquipment() {
    const selectedEquipment = JSON.parse(localStorage.getItem('selectedEquipment') || '[]')
    selectedEquipment.forEach(equipment => {
      this.addEquipmentTag(equipment)
    })
    localStorage.removeItem('selectedEquipment') // Clear after loading
  }

  // add equipment handling
  async searchEquipment(event) {
    const query = event.target.value.trim()
    this.equipmentResultsTarget.innerHTML = ''

    if (query.length < 2) return

    const response = await fetch(`/equipment.json?query=${encodeURIComponent(query)}`)
    const equipment = await response.json()
    this.renderEquipmentResults(equipment)
  }

  renderEquipmentResults(equipment) {
    this.equipmentResultsTarget.innerHTML = equipment.map(item => `
      <div class="list-group-item" data-action="click->travel-plan#selectEquipment"
           data-equipment='${JSON.stringify(item)}'>
        ${item.name} - ${item.category}
      </div>
    `).join('')
  }

  selectEquipment(event) {
    const equipment = JSON.parse(event.currentTarget.dataset.equipment)
    this.addEquipmentTag(equipment)
    this.equipmentSearchTarget.value = ''
    this.equipmentResultsTarget.innerHTML = ''
  }

  addEquipmentTag(equipment) {
    if (this.selectedEquipment.has(equipment.id)) return

    this.selectedEquipment.add(equipment.id)
    this.selectedEquipmentTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${equipment.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeEquipment"
                data-equipment-id="${equipment.id}"></button>
        <input type="hidden" name="travel_plan[equipment_ids][]" value="${equipment.id}">
      </div>
    `)
  }

  removeEquipment(event) {
    const equipmentId = event.currentTarget.dataset.equipmentId
    this.selectedEquipment.delete(equipmentId)
    event.currentTarget.closest('.badge').remove()
  }

  // end of equipment handling

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

  async fetchAndAddLocation(id) {
    try {
      const response = await fetch(`/locations/${id}.json`)
      const location = await response.json()
      this.addLocationTag(location)
    } catch (error) {
      console.error('Error fetching location:', error)
    }
  }

  async fetchAndAddAdventure(id) {
    try {
      const response = await fetch(`/adventures/${id}.json`)
      const adventure = await response.json()
      this.addAdventureTag(adventure)
    } catch (error) {
      console.error('Error fetching adventure:', error)
    }
  }

  async updateAvailableAdventures() {
    const locationIds = Array.from(this.selectedLocations).join(',')
    const queryParams = new URLSearchParams()
    if (locationIds) {
      queryParams.append('location_ids', locationIds)
    }

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
      const adventureJson = JSON.stringify(adventure).replace(/"/g, '&quot;')

      return `
        <div class="list-group-item d-flex justify-content-between align-items-center">
          ${adventure.name}
          <button type="button"
                  class="btn btn-sm btn-primary"
                  data-action="click->travel-plan#selectAdventure"
                  data-adventure="${adventureJson}">
            Add
          </button>
        </div>
      `
    }).join('')
  }

  selectLocation(event) {
    const location = JSON.parse(event.currentTarget.dataset.location)
    this.addLocationTag(location)
    this.locationSearchTarget.value = ''
    this.locationResultsTarget.innerHTML = ''
    this.updateAvailableAdventures()
  }

  selectAdventure(event) {
    event.preventDefault()
    event.stopPropagation()

    console.log('Select adventure clicked')

    try {
      const adventureData = JSON.parse(event.currentTarget.dataset.adventure)
      console.log('Adventure data:', adventureData)
      this.addAdventureTag(adventureData)
    } catch (error) {
      console.error('Error parsing adventure data:', error)
      console.log('Raw adventure data:', event.currentTarget.dataset.adventure)
    }
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

    console.log('Adding adventure:', adventure)

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
