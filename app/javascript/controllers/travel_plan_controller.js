// app/javascript/controllers/travel_plan_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationSearch", "locationResults", "selectedLocations",
    "selectedAdventures", "adventureResults", "equipmentList",
    "startDate", "endDate", "debugButton"]

  static values = {
    locations: Array,
    adventures: Array
  }

  connect() {
    console.log("Travel plan controller connected");
    this.selectedLocations = new Set();
    this.selectedAdventures = new Set();
    this.loadAllAdventures();

    // Initialize tracking for previously seen equipment
    this.previousEquipmentIds = new Set();
    this.showEquipmentNotification = false;

    // Initialize from passed-in values
    if (this.hasLocationsValue && this.locationsValue.length > 0) {
      console.log("Initializing with locations:", this.locationsValue);
      this.locationsValue.forEach(location => {
        if (location && location.id) {
          this.addLocationTag(location);
        }
      });
    }

    if (this.hasAdventuresValue && this.adventuresValue.length > 0) {
      console.log("Initializing with adventures:", this.adventuresValue);
      this.adventuresValue.forEach(adventure => {
        if (adventure && adventure.id) {
          this.addAdventureTag(adventure);
        }
      });
    }

    // Add event listener for equipment updates
    document.addEventListener('equipment-update', () => {
      console.log("Manual equipment update triggered");
      this.updateEquipment();
    });

    // Also check for URL parameters for location_id and adventure_id
    this.loadInitialSelections();

    // Initialize available adventures
    this.updateAvailableAdventures();

    // Only show a message if no locations/adventures are selected
    if (this.selectedLocations.size === 0 && this.selectedAdventures.size === 0) {
      this.showDefaultEquipmentMessage();
    } else {
      // Update equipment if we have selections
      this.updateEquipment();
    }

    // Notify skills controller about current selections
    this.notifyLocationAdventureChange();
  }

  // Helper method to show default message when no selections are made
  showDefaultEquipmentMessage() {
    if (this.hasEquipmentListTarget) {
      this.equipmentListTarget.innerHTML = `
        <div class="alert alert-info">
          <p>Select locations and adventures to see recommended equipment.</p>
        </div>
      `;
    }
  }

  // Helper method to properly handle ID conversions
  convertToId(id) {
    return typeof id === 'string' ? parseInt(id, 10) : id;
  }

  async loadInitialSelections() {
    const urlParams = new URLSearchParams(window.location.search);
    const locationId = urlParams.get('location_id');
    const adventureId = urlParams.get('adventure_id');

    if (locationId) {
      console.log(`Loading location from URL param: ${locationId}`);
      await this.fetchAndAddLocation(locationId);
    }

    if (adventureId) {
      console.log(`Loading adventure from URL param: ${adventureId}`);
      await this.fetchAndAddAdventure(adventureId);
    }
  }

  async fetchAndAddLocation(id) {
    try {
      console.log(`Fetching location: ${id}`);
      const response = await fetch(`/locations/${id}.json`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const location = await response.json();
      console.log("Fetched location:", location);
      this.addLocationTag(location);
    } catch (error) {
      console.error('Error fetching location:', error);
    }
  }

  async fetchAndAddAdventure(id) {
    try {
      console.log(`Fetching adventure: ${id}`);
      const response = await fetch(`/adventures/${id}.json`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const adventure = await response.json();
      console.log("Fetched adventure:", adventure);
      this.addAdventureTag(adventure);
    } catch (error) {
      console.error('Error fetching adventure:', error);
    }
  }

  async updateAvailableAdventures() {
    const locationIds = Array.from(this.selectedLocations).join(',');

    try {
      // If no locations are selected, load all adventures
      if (!locationIds) {
        console.log('No locations selected, loading all adventures');
        return this.loadAllAdventures();
      }

      const queryParams = new URLSearchParams();
      queryParams.append('location_ids', locationIds);

      console.log(`Fetching adventures for locations: ${locationIds}`);
      const response = await fetch(`/adventures.json?${queryParams}`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const adventures = await response.json();
      console.log(`Found ${adventures.length} adventures`);
      this.renderAdventureResults(adventures);
    } catch (error) {
      console.error('Error updating adventures:', error);
      if (this.hasAdventureResultsTarget) {
        this.adventureResultsTarget.innerHTML = `<div class="alert alert-danger">Error loading adventures: ${error.message}</div>`;
      }
    }
  }

  async searchLocations(event) {
    const query = event.target.value.trim();

    if (!this.hasLocationResultsTarget) {
      console.error("Missing locationResults target");
      return;
    }

    this.locationResultsTarget.innerHTML = '';

    if (query.length < 2) return;

    try {
      console.log(`Searching locations with query: ${query}`);
      const response = await fetch(`/locations.json?query=${encodeURIComponent(query)}`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const locations = await response.json();
      console.log(`Found ${locations.length} locations`);
      this.renderLocationResults(locations);
    } catch (error) {
      console.error('Error searching locations:', error);
      this.locationResultsTarget.innerHTML = `<div class="alert alert-danger">Error searching locations: ${error.message}</div>`;
    }
  }

  renderLocationResults(locations) {
    if (!this.hasLocationResultsTarget) {
      console.error("Missing locationResults target");
      return;
    }

    if (locations.length === 0) {
      this.locationResultsTarget.innerHTML = '<div class="list-group-item">No locations found</div>';
      return;
    }

    this.locationResultsTarget.innerHTML = locations.map(location => {
      // Safely encode the location data
      const locationData = JSON.stringify(location).replace(/"/g, '&quot;');

      return `
        <div class="list-group-item" data-action="click->travel-plan#selectLocation"
             data-location="${locationData}">
          ${location.name} - ${location.city || ''}, ${location.prefecture || ''}
        </div>
      `;
    }).join('');
  }

  renderAdventureResults(adventures) {
    if (!this.hasAdventureResultsTarget) {
      console.error("Missing adventureResults target");
      return;
    }

    if (adventures.length === 0) {
      this.adventureResultsTarget.innerHTML = '<div class="list-group-item">No adventures available</div>';
      return;
    }

    this.adventureResultsTarget.innerHTML = adventures.map(adventure => {
      // Safely encode the adventure data
      const adventureData = JSON.stringify(adventure).replace(/"/g, '&quot;');

      return `
        <div class="list-group-item d-flex justify-content-between align-items-center">
          ${adventure.name}
          <button type="button"
                  class="btn btn-sm btn-outline-primary add-adventure-btn"
                  data-action="click->travel-plan#selectAdventure"
                  data-adventure="${adventureData}">
            <i class="fas fa-plus"></i>
          </button>
        </div>
      `;
    }).join('');
  }

  selectLocation(event) {
    try {
      const locationStr = event.currentTarget.getAttribute('data-location');
      const location = JSON.parse(locationStr);

      if (!location || !location.id) {
        console.error("Invalid location data:", locationStr);
        return;
      }

      this.addLocationTag(location);

      if (this.hasLocationSearchTarget) {
        this.locationSearchTarget.value = '';
      }

      if (this.hasLocationResultsTarget) {
        this.locationResultsTarget.innerHTML = '';
      }

      this.updateAvailableAdventures();
    } catch (error) {
      console.error('Error in selectLocation:', error);
    }
  }

  selectAdventure(event) {
    event.preventDefault();
    event.stopPropagation();

    try {
      const adventureData = event.currentTarget.getAttribute('data-adventure');
      const adventure = JSON.parse(adventureData);

      if (!adventure || !adventure.id) {
        console.error("Invalid adventure data:", adventureData);
        return;
      }

      this.addAdventureTag(adventure);
    } catch (error) {
      console.error('Error in selectAdventure:', error);
      console.log('Raw adventure data:', event.currentTarget.dataset.adventure);
    }
  }

  async updateEquipment() {
    const locationIds = Array.from(this.selectedLocations).join(',');
    const adventureIds = Array.from(this.selectedAdventures).join(',');
    const startDate = this.hasStartDateTarget ? this.startDateTarget.value : null;

    // Log variables to help with debugging
    console.log('Updating equipment with:', {
      locationIds,
      adventureIds,
      startDate,
      locationCount: this.selectedLocations.size,
      adventureCount: this.selectedAdventures.size
    });

    // Flag to show notification about new items
    this.showEquipmentNotification = true;

    // If no locations or adventures selected, show default message
    if (!locationIds && !adventureIds) {
      this.showDefaultEquipmentMessage();
      return;
    }

    try {
      // Show loading spinner
      if (this.hasEquipmentListTarget) {
        this.equipmentListTarget.innerHTML = `
          <div class="loading-indicator alert alert-info">
            <div class="d-flex align-items-center">
              <div class="spinner-border spinner-border-sm me-2" role="status">
                <span class="visually-hidden">Loading...</span>
              </div>
              <div>Analyzing your selections and finding the right equipment...</div>
            </div>
          </div>
        `;
      } else {
        console.error("Missing equipmentList target");
        return;
      }

      const params = new URLSearchParams();
      if (locationIds) params.append('location_ids', locationIds);
      if (adventureIds) params.append('adventure_ids', adventureIds);
      if (startDate) params.append('start_date', startDate);

      const url = `/travel_plans/get_recommended_equipment?${params}`;
      console.log('Fetching equipment from:', url);

      const response = await fetch(url);

      // Log response status to help with debugging
      console.log('Response status:', response.status, response.statusText);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const equipment = await response.json();

      // Add a small delay to show the loading state for better UX
      setTimeout(() => {
        this.renderEquipmentList(equipment);
      }, 1200);
    } catch (error) {
      console.error('Error updating equipment:', error);
      if (this.hasEquipmentListTarget) {
        this.equipmentListTarget.innerHTML =
          `<div class="alert alert-danger">Error loading equipment: ${error.message}</div>`;
      }
    }
  }

  renderEquipmentList(equipment) {
    if (!this.hasEquipmentListTarget) {
      console.error("Missing equipmentList target");
      return;
    }

    console.log('🧰 Rendering equipment list with', equipment.length, 'items');

    if (!Array.isArray(equipment) || equipment.length === 0) {
      this.equipmentListTarget.innerHTML = '<p class="text-muted">No specific equipment recommendations found.</p>';
      return;
    }

    // Check for new equipment items
    const currentEquipmentIds = new Set(equipment.map(item => item.id));
    const newEquipmentIds = new Set([...currentEquipmentIds].filter(id => !this.previousEquipmentIds.has(id)));
    const hasNewEquipment = newEquipmentIds.size > 0 && this.previousEquipmentIds.size > 0;

    // Update the tracking set
    this.previousEquipmentIds = currentEquipmentIds;

    // Group equipment by category
    const equipmentByCategory = equipment.reduce((acc, item) => {
      if (!acc[item.category]) {
        acc[item.category] = [];
      }
      acc[item.category].push(item);
      return acc;
    }, {});

    // Generate notification for new equipment
    let notificationHtml = '';
    if (hasNewEquipment && this.showEquipmentNotification) {
      notificationHtml = `
        <div class="notification-alert alert alert-success alert-dismissible fade show mb-3">
          <div class="d-flex align-items-center">
            <div class="me-2">
              <i class="fas fa-info-circle"></i>
            </div>
            <div>
              <strong>New equipment added!</strong> ${newEquipmentIds.size} new items recommended based on your selection.
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      `;
    }

    // Generate HTML
    let html = notificationHtml;

    Object.entries(equipmentByCategory).forEach(([category, items]) => {
      html += `
        <div class="col-12 mb-3">
          <h6 class="text-capitalize">${category}</h6>
          <div class="row">
      `;

      items.forEach(item => {
        const isChecked = this.isEquipmentSelected(item.id);
        const isEssential = item.is_essential === true;
        const isNew = newEquipmentIds.has(item.id) && this.showEquipmentNotification;

        // Different styling based on whether user already owns the item
        const cardClasses = item.user_owned
          ? 'border-success bg-success bg-opacity-10'
          : 'border-primary';

        // Add highlight class for new items
        const highlightClass = isNew ? 'new-item border-warning' : '';

        const ownedBadge = item.user_owned
          ? '<span class="badge bg-success ms-2">You own this</span>'
          : '';

        const essentialBadge = isEssential
          ? '<span class="badge bg-danger ms-2">Essential</span>'
          : '';

        const newBadge = isNew
          ? '<span class="badge bg-warning text-dark ms-2 new-badge">New</span>'
          : '';

        // Get the source details for display
        let sourceBadges = '';
        if (item.sources && item.sources.length > 0) {
          sourceBadges = item.sources.map(source => {
            let badgeClass = 'bg-secondary';
            let sourceText = source;

            // If it's from a specific adventure or location
            if (source === 'Adventure' && item.adventure_name) {
              sourceText = this.getShortName(item.adventure_name);
              badgeClass = 'bg-primary';
            } else if (source === 'Location' && item.location_name) {
              sourceText = this.getShortName(item.location_name);
              badgeClass = 'bg-info';
            } else if (source === 'Season') {
              badgeClass = 'bg-success';
            } else if (source === 'Basic') {
              badgeClass = 'bg-dark';
            }

            return `<span class="badge ${badgeClass} me-1">${sourceText}</span>`;
          }).join('');
        }

        html += `
          <div class="col-md-12 mb-2">
            <div class="card ${cardClasses} ${highlightClass}" style="position: relative;">
              ${isNew ? '<span class="notification-badge">NEW</span>' : ''}
              <div class="card-body p-3">
                <div class="form-check">
                  <input type="checkbox"
                         id="equipment_${item.id}"
                         name="travel_plan[equipment_ids][]"
                         value="${item.id}"
                         class="form-check-input me-2"
                         ${isChecked || isEssential ? 'checked' : ''}
                         ${isEssential ? 'disabled' : ''}>
                  <label class="form-check-label" for="equipment_${item.id}">
                    ${item.name} ${ownedBadge} ${essentialBadge} ${newBadge}
                  </label>
                  ${sourceBadges ? `<div class="mt-1">${sourceBadges}</div>` : ''}
                  <small class="d-block text-muted">${item.description || ''}</small>
                </div>
                ${isEssential ? `<input type="hidden" name="travel_plan[equipment_ids][]" value="${item.id}">` : ''}
              </div>
            </div>
          </div>
        `;
      });

      html += `
          </div>
        </div>
      `;
    });

    this.equipmentListTarget.innerHTML = html;

    // Add event listener to clear highlight on scroll or hover
    if (hasNewEquipment) {
      const newItems = this.equipmentListTarget.querySelectorAll('.new-item');
      const clearHighlight = () => {
        newItems.forEach(item => {
          item.classList.remove('new-item', 'border-warning');
          const badge = item.querySelector('.notification-badge');
          if (badge) badge.remove();
        });
        // Remove the event listeners after first trigger
        this.equipmentListTarget.removeEventListener('mouseover', clearHighlight);
        this.equipmentListTarget.removeEventListener('scroll', clearHighlight);
      };

      this.equipmentListTarget.addEventListener('mouseover', clearHighlight);
      this.equipmentListTarget.addEventListener('scroll', clearHighlight);

      // Auto-dismiss notification after a few seconds
      setTimeout(() => {
        const notification = this.equipmentListTarget.querySelector('.notification-alert');
        if (notification) {
          notification.classList.remove('show');
          setTimeout(() => notification.remove(), 300);
        }
      }, 5000);
    }

    // Reset notification flag after rendering
    this.showEquipmentNotification = false;
  }

  // Helper to convert a full name to a short version (first 1-2 words)
  getShortName(fullName) {
    if (!fullName) return '';

    const words = fullName.split(' ');
    if (words.length === 1) return words[0];
    if (words.length === 2) return `${words[0]} ${words[1]}`;

    // For longer names, check if first word is very short (like "Mt.")
    if (words[0].length <= 2 && words.length >= 3) {
      return `${words[0]} ${words[1]} ${words[2]}`;
    }

    return `${words[0]} ${words[1]}`;
  }

  isEquipmentSelected(equipmentId) {
    return this.element.querySelector(`input[name="travel_plan[equipment_ids][]"][value="${equipmentId}"]`)?.checked || false;
  }

  addLocationTag(location) {
    if (!location || !location.id) {
      console.error("Invalid location:", location);
      return;
    }

    const locationId = this.convertToId(location.id);

    if (this.selectedLocations.has(locationId)) {
      console.log(`Location ${locationId} already selected`);
      return;
    }

    console.log('Adding location:', locationId, location.name);
    this.selectedLocations.add(locationId);

    if (!this.hasSelectedLocationsTarget) {
      console.error("Missing selectedLocations target");
      return;
    }

    this.selectedLocationsTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${location.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeLocation"
                data-location-id="${locationId}"></button>
        <input type="hidden" name="travel_plan[location_ids][]" value="${locationId}">
      </div>
    `);

    // Call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);

    // Updated for skills recommendation
    this.notifyLocationAdventureChange();
  }

  addAdventureTag(adventure) {
    // Skip if adventure is null, undefined, or doesn't have an id
    if (!adventure || !adventure.id || !adventure.name) {
      console.log('Skipping invalid adventure:', adventure);
      return;
    }

    const adventureId = this.convertToId(adventure.id);

    if (this.selectedAdventures.has(adventureId)) {
      console.log(`Adventure ${adventureId} already selected`);
      return;
    }

    console.log('Adding adventure:', adventureId, adventure.name);
    this.selectedAdventures.add(adventureId);

    if (!this.hasSelectedAdventuresTarget) {
      console.error("Missing selectedAdventures target");
      return;
    }

    this.selectedAdventuresTarget.insertAdjacentHTML('beforeend', `
      <div class="badge bg-primary p-2 m-1 d-inline-flex align-items-center">
        ${adventure.name}
        <button type="button" class="btn-close ms-2"
                data-action="click->travel-plan#removeAdventure"
                data-adventure-id="${adventureId}"></button>
        <input type="hidden" name="travel_plan[adventure_ids][]" value="${adventureId}">
      </div>
    `);

    // Call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);

    // Update for skills recs
    this.notifyLocationAdventureChange();
  }


  removeLocation(event) {
    const locationId = parseInt(event.currentTarget.dataset.locationId, 10);
    console.log('ℹ️ REMOVING LOCATION:', locationId);
    console.log('📋 Current locations BEFORE:', Array.from(this.selectedLocations));

    // Delete as the same type as was added
    this.selectedLocations.delete(locationId);

    // Log after removal to verify
    console.log('📋 Current locations AFTER:', Array.from(this.selectedLocations));

    event.currentTarget.closest('.badge').remove();

    // Force refresh of both adventures and equipment
    console.log('🔄 Forcing full refresh...');
    this.updateAvailableAdventures();
    setTimeout(() => this.updateEquipment(), 100);

    // Update for skills recs
    this.notifyLocationAdventureChange();
  }

  removeAdventure(event) {
    const adventureId = parseInt(event.currentTarget.dataset.adventureId, 10);
    console.log('Removing adventure:', adventureId);
    this.selectedAdventures.delete(adventureId);
    event.currentTarget.closest('.badge').remove();

    // Call updateEquipment after DOM is updated
    setTimeout(() => this.updateEquipment(), 50);

    // Update for skills recs
    this.notifyLocationAdventureChange();
  }

  notifyLocationAdventureChange() {
    console.log("Notifying location/adventure change");
    console.log("Location IDs:", Array.from(this.selectedLocations));
    console.log("Adventure IDs:", Array.from(this.selectedAdventures));

    // Create an event to notify other controllers about the change
    const event = new CustomEvent('locations-adventures-changed', {
      detail: {
        locationIds: Array.from(this.selectedLocations),
        adventureIds: Array.from(this.selectedAdventures)
      }
    });

    // Dispatch the event
    document.dispatchEvent(event);
  }

  loadAllAdventures() {
    console.log("Loading all adventures");
    fetch('/adventures.json')
      .then(response => {
        if (!response.ok) {
          throw new Error('Failed to fetch adventures');
        }
        return response.json();
      })
      .then(adventures => {
        console.log(`Loaded ${adventures.length} adventures`);
        this.renderAdventureResults(adventures);
      })
      .catch(error => {
        console.error('Error loading adventures:', error);
        if (this.hasAdventureResultsTarget) {
          this.adventureResultsTarget.innerHTML =
            `<div class="alert alert-danger">Error loading adventures: ${error.message}</div>`;
        }
      });
  }

  formSubmit(event) {
    console.log("Form submit detected");

    // Don't prevent default event behavior unless there's a specific reason
    // event.preventDefault(); // Remove this if it exists

    // Get all skill inputs
    const skillInputs = document.querySelectorAll('input[name="travel_plan[skill_ids][]"]');
    console.log(`Found ${skillInputs.length} skill ID inputs`);

    // Log their values for debugging
    if (skillInputs.length > 0) {
      const skillIds = Array.from(skillInputs).map(input => input.value);
      console.log("Skill IDs being submitted:", skillIds);
    } else {
      console.warn("No skill IDs found in the form submission");

      // Get selected skill IDs from skills recommendation controller
      const skillsController = this.application.getControllerForElementAndIdentifier(
        document.querySelector('[data-controller="skills-recommendation"]'),
        'skills-recommendation'
      );

      if (skillsController && skillsController.selectedSkillIdsValue && skillsController.selectedSkillIdsValue.length > 0) {
        console.log("Found skills recommendation controller");
        console.log("Selected skill IDs:", skillsController.selectedSkillIdsValue);

        // Add hidden inputs for the selected skills
        const formElement = this.element.querySelector('form');
        if (formElement) {
          skillsController.selectedSkillIdsValue.forEach(skillId => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'travel_plan[skill_ids][]';
            input.value = skillId;
            formElement.appendChild(input);
          });
          console.log("Added missing skill IDs to the form");
        }
      }
    }

    // Continue with form submission (the default behavior)
    return true;
  }
}
