// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
    "selectedAdventures", "adventureResults", "equipmentList",
    "startDate", "endDate", "debugButton"]

  debugForceUpdate(event) {
    console.log("Debug force update called");
    this.updateEquipment();
  }

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

    // Add this event listener
    document.addEventListener('equipment-update', () => {
      console.log("Manual equipment update triggered");
      this.updateEquipment();
    });

    this.loadInitialSelections()
    this.updateAvailableAdventures()
  }

  // helper method to properly handle ID conversions
  convertToId(id) {
    return typeof id === 'string' ? parseInt(id, 10) : id;
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

    console.log('Updating equipment with:', {
      locationIds,
      adventureIds,
      startDate,
      locationCount: this.selectedLocations.size,
      adventureCount: this.selectedAdventures.size
    });

    try {
      // clear existing equipment while loading
      if (this.hasEquipmentListTarget) {
        this.equipmentListTarget.innerHTML = '<p class="text-center"><em>Loading equipment recommendations...</em></p>';
      }

      const params = new URLSearchParams();
      if (locationIds) params.append('location_ids', locationIds);
      if (adventureIds) params.append('adventure_ids', adventureIds);
      if (startDate) params.append('start_date', startDate);

      const url = `/travel_plans/get_recommended_equipment?${params}`;
      console.log('Fetching equipment from:', url);

      const response = await fetch(url);
      if (!response.ok) {
        console.error('Error response:', response.status, response.statusText);
        throw new Error('Failed to fetch equipment');
      }

      const equipment = await response.json();
      console.log('Received equipment:', equipment);

      // force a small delay to ensure DOM updates
      setTimeout(() => {
        this.renderEquipmentList(equipment);
      }, 50);
    } catch (error) {
      console.error('Error updating equipment:', error);
      if (this.hasEquipmentListTarget) {
        this.equipmentListTarget.innerHTML =
          `<div class="alert alert-danger">Error loading equipment: ${error.message}</div>`;
      }
    }
  }

  renderEquipmentList(equipment) {
    if (!this.hasEquipmentListTarget) return;

    console.log('🧰 Rendering equipment list with', equipment.length, 'items');

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
          ${item.sources ? `<div><small class="badge bg-info">${item.sources.join(', ')}</small></div>` : ''}
          <small class="d-block text-muted">${item.description || ''}</small>
        </div>
      </div>
    `).join('');
  }

  isEquipmentSelected(equipmentId) {
    return this.element.querySelector(`input[name="travel_plan[equipment_ids][]"][value="${equipmentId}"]`)?.checked || false
  }

  addLocationTag(location) {
    const locationId = this.convertToId(location.id);
    if (this.selectedLocations.has(locationId)) return;

    console.log('Adding location:', locationId, location.name);
    this.selectedLocations.add(locationId);

    this.selectedLocationsTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${location.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeLocation"
                data-location-id="${locationId}"></button>
        <input type="hidden" name="travel_plan[location_ids][]" value="${locationId}">
      </div>
    `);

    // call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);
  }

  addAdventureTag(adventure) {
    const adventureId = this.convertToId(adventure.id);
    if (this.selectedAdventures.has(adventureId)) return;

    console.log('Adding adventure:', adventureId, adventure.name);
    this.selectedAdventures.add(adventureId);

    this.selectedAdventuresTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${adventure.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeAdventure"
                data-adventure-id="${adventureId}"></button>
        <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventureId}">
      </div>
    `);

    // call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);
  }


  removeLocation(event) {
    const locationId = parseInt(event.currentTarget.dataset.locationId, 10);
    console.log('ℹ️ REMOVING LOCATION:', locationId);
    console.log('📋 Current locations BEFORE:', Array.from(this.selectedLocations));

    // Make sure we delete it as the same type it was added
    this.selectedLocations.delete(locationId);

    // Log after removal to verify
    console.log('📋 Current locations AFTER:', Array.from(this.selectedLocations));

    event.currentTarget.closest('.badge').remove();

    // Force refresh of both adventures and equipment
    console.log('🔄 Forcing full refresh...');
    this.updateAvailableAdventures();
    setTimeout(() => this.updateEquipment(), 100);
  }

  removeAdventure(event) {
    const adventureId = parseInt(event.currentTarget.dataset.adventureId, 10);
    console.log('Removing adventure:', adventureId);
    this.selectedAdventures.delete(adventureId);
    event.currentTarget.closest('.badge').remove();

    // call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);
  }
}
