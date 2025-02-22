// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
                    "selectedAdventures", "adventureResults", "equipmentList",
                    "startDate", "endDate"]

  static values = {
    locations: Array,
    adventures: Array
  }

  connect() {
    this.selectedLocations = new Set()
    this.selectedAdventures = new Set()

    if (this.hasLocationsValue) {
      this.locationsValue.forEach(location => this.addLocationTag(location))
    }
    if (this.hasAdventuresValue) {
      this.adventuresValue.forEach(adventure => this.addAdventureTag(adventure))
    }

    this.loadInitialSelections()
    this.updateAvailableAdventures()
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

    try {
      const adventureData = JSON.parse(event.currentTarget.dataset.adventure)
      this.addAdventureTag(adventureData)
    } catch (error) {
      console.error('Error parsing adventure data:', error)
      console.log('Raw adventure data:', event.currentTarget.dataset.adventure)
    }
  }

  async updateEquipment() {
    const locationIds = Array.from(this.selectedLocations).join(',');
    const adventureIds = Array.from(this.selectedAdventures).join(',');
    const startDate = this.hasStartDateTarget ? this.startDateTarget.value : null;

    try {
      const params = new URLSearchParams();
      if (locationIds) params.append('location_ids', locationIds);
      if (adventureIds) params.append('adventure_ids', adventureIds);
      if (startDate) params.append('start_date', startDate);

      const response = await fetch(`/travel_plans/get_recommended_equipment?${params}`);
      if (!response.ok) throw new Error('Failed to fetch equipment');

      const equipment = await response.json();
      console.log('Received equipment:', equipment); // Debug log
      this.renderEquipmentList(equipment);
    } catch (error) {
      console.error('Error updating equipment:', error);
    }
  }

  renderEquipmentList(equipment) {
    if (!this.hasEquipmentListTarget) return;

    if (!Array.isArray(equipment) || equipment.length === 0) {
      this.equipmentListTarget.innerHTML = '<p class="text-muted">No specific equipment recommendations found.</p>';
      return;
    }

    this.equipmentListTarget.innerHTML = equipment.map(item => `
      <div class="col-md-6 mb-2">
        <div class="form-check">
          <input type="checkbox"
                 id="equipment_${item.id}"
                 name="travel_plan[equipment_ids][]"
                 value="${item.id}"
                 class="form-check-input"
                 ${this.isEquipmentSelected(item.id) ? 'checked' : ''}>
          <label class="form-check-label" for="equipment_${item.id}">
            ${item.name}
          </label>
          <small class="d-block text-muted">${item.description || ''}</small>
        </div>
      </div>
    `).join('');
  }

  isEquipmentSelected(equipmentId) {
    return this.element.querySelector(`input[name="travel_plan[equipment_ids][]"][value="${equipmentId}"]`)?.checked || false
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
    this.updateEquipment()
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
    this.updateEquipment()
  }

  removeLocation(event) {
    const locationId = event.currentTarget.dataset.locationId
    this.selectedLocations.delete(locationId)
    event.currentTarget.closest('.badge').remove()
    this.updateAvailableAdventures()
    this.updateEquipment()
  }

  removeAdventure(event) {
    const adventureId = event.currentTarget.dataset.adventureId
    this.selectedAdventures.delete(adventureId)
    event.currentTarget.closest('.badge').remove()
    this.updateEquipment()
  }
}
