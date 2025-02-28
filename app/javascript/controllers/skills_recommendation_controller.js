// app/javascript/controllers/skills_recommendation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["skillsList"]
  static values = {
    travelPlanId: Number,
    selectedSkillIds: Array
  }

  connect() {
    console.log("Skills recommendation controller connected");

    // initialize selectedSkillIds if not set
    if (!this.hasSelectedSkillIdsValue) {
      this.selectedSkillIdsValue = [];
    }

    console.log("Travel plan ID:", this.travelPlanIdValue);
    console.log("Initially selected skills:", this.selectedSkillIdsValue);

    // listen for location or adventure changes from the travel plan controller
    document.addEventListener('locations-adventures-changed', this.updateSkills.bind(this));

    // set initial state
    this.skillsListTarget.innerHTML = `
      <div class="alert alert-info">
        Select locations and adventures to see recommended skills.
      </div>
    `;
  }

  updateSkills(event) {
    console.log("Skills update event received:", event.detail);

    // get location and adventure IDs from the event
    const { locationIds, adventureIds } = event.detail;

    // don't make the request if there are no locations or adventures
    if (!locationIds.length && !adventureIds.length) {
      console.log("No locations or adventures selected, showing default message");
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          Select locations and adventures to see recommended skills.
        </div>
      `;
      return;
    }

    // create params for the API request
    const params = new URLSearchParams();
    if (locationIds.length) params.append('location_ids', locationIds.join(','));
    if (adventureIds.length) params.append('adventure_ids', adventureIds.join(','));

    const url = `/travel_plans/get_recommended_skills?${params}`;
    console.log("Fetching skills from:", url);

    // display loading state
    this.skillsListTarget.innerHTML = `
      <div class="alert alert-info">
        <div class="d-flex align-items-center">
          <div class="spinner-border spinner-border-sm me-2" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          Loading skill recommendations...
        </div>
      </div>
    `;

    // make the API request
    fetch(url)
      .then(response => {
        if (!response.ok) {
          console.error("Skills API error:", response.status, response.statusText);
          throw new Error(`API responded with status: ${response.status}`);
        }
        return response.json();
      })
      .then(skills => {
        console.log("Received skills data:", skills);
        this.renderSkills(skills);
      })
      .catch(error => {
        console.error('Error fetching skills:', error);
        this.skillsListTarget.innerHTML = `
          <div class="alert alert-danger">
            <p>Error loading skill recommendations: ${error.message}</p>
            <p class="small mb-0">Try refreshing the page or selecting different locations/adventures.</p>
          </div>
        `;
      });
  }

  renderSkills(skills) {
    // handle empty or null skills
    if (!skills || !skills.length) {
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          No specific skills recommended for this trip.
        </div>
      `;
      return;
    }

    // group skills by category
    const skillsByCategory = skills.reduce((acc, skill) => {
      const category = skill.category || 'Other';
      if (!acc[category]) acc[category] = [];
      acc[category].push(skill);
      return acc;
    }, {});

    // build HTML
    let html = '';

    Object.entries(skillsByCategory).forEach(([category, categorySkills]) => {
      html += `
        <div class="mb-3">
          <h5 class="text-capitalize">${category}</h5>
          <div class="row g-2">
      `;

      categorySkills.forEach(skill => {
        const safetyCriticalBadge = skill.safety_critical
          ? `<span class="badge bg-warning text-dark ms-1">Safety Critical</span>`
          : '';

        const difficultyBadge = skill.difficulty
          ? `<span class="badge bg-${this.getDifficultyColor(skill.difficulty)}">${skill.difficulty}</span>`
          : '<span class="badge bg-secondary">beginner</span>';

        const isSelected = this.selectedSkillIdsValue.includes(skill.id);
        const buttonClass = isSelected
          ? "btn-success"
          : "btn-outline-success";
        const buttonText = isSelected
          ? '<i class="fas fa-check"></i> Selected'
          : '<i class="fas fa-plus"></i> Add to Plan';

        html += `
          <div class="col-md-6 mb-2">
            <div class="card ${skill.safety_critical ? 'border-warning' : ''}">
              <div class="card-body p-3">
                <h6 class="mb-1">${skill.name} ${safetyCriticalBadge}</h6>
                <p class="small text-muted mb-2">${difficultyBadge}</p>
                <small class="d-block mb-2">${skill.details ? skill.details.substring(0, 100) + (skill.details.length > 100 ? '...' : '') : ''}</small>
                <div class="d-flex justify-content-between align-items-center">
                  <a href="/skills/${skill.id}" class="btn btn-sm btn-outline-primary" target="_blank">Learn More</a>
                  <button type="button"
                    class="btn btn-sm ${buttonClass}"
                    data-action="click->skills-recommendation#toggleSkill"
                    data-skill-id="${skill.id}">
                    ${buttonText}
                  </button>
                </div>
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

    // if on a travel plan edit form, add hidden inputs for selected skills
    if (this.hasTravelPlanIdValue && this.travelPlanIdValue > 0) {
      html += `
        <div class="selected-skills-inputs">
          ${this.selectedSkillIdsValue.map(id =>
            `<input type="hidden" name="travel_plan[skill_ids][]" value="${id}">`
          ).join('')}
        </div>
      `;
    }

    this.skillsListTarget.innerHTML = html;
  }

  toggleSkill(event) {
    const button = event.currentTarget;
    const skillId = parseInt(button.dataset.skillId, 10);

    // for travel plan edit/new forms, just toggle the selection
    if (this.hasTravelPlanIdValue && this.travelPlanIdValue === 0) {
      this.toggleSkillSelection(skillId);
      // refresh the UI
      this.renderSkills(this.lastReceivedSkills);
      return;
    }

    // for existing travel plans, make API call to add/remove
    const isSelected = this.selectedSkillIdsValue.includes(skillId);

    // set UI loading state
    button.disabled = true;
    button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...';

    if (isSelected) {
      // remove skill
      fetch(`/travel_plans/${this.travelPlanIdValue}/remove_skill`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        },
        body: JSON.stringify({ skill_id: skillId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.toggleSkillSelection(skillId);
          // show success message
          this.showToast('Skill removed from travel plan.');
        } else {
          console.error('Error removing skill:', data.error);
          this.showToast('Error removing skill.', 'danger');
        }
        // re-render UI
        this.updateSkills({ detail: this.lastDetail });
      })
      .catch(error => {
        console.error('Error:', error);
        this.showToast('Error removing skill.', 'danger');
        button.disabled = false;
        button.innerHTML = '<i class="fas fa-check"></i> Selected';
      });
    } else {
      // add skill
      fetch(`/travel_plans/${this.travelPlanIdValue}/add_skill`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        },
        body: JSON.stringify({ skill_id: skillId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.toggleSkillSelection(skillId);
          // show success message
          this.showToast('Skill added to travel plan!');
        } else {
          console.error('Error adding skill:', data.errors);
          this.showToast('Error adding skill.', 'danger');
        }
        // re-render UI
        this.updateSkills({ detail: this.lastDetail });
      })
      .catch(error => {
        console.error('Error:', error);
        this.showToast('Error adding skill.', 'danger');
        button.disabled = false;
        button.innerHTML = '<i class="fas fa-plus"></i> Add to Plan';
      });
    }
  }

  toggleSkillSelection(skillId) {
    const currentIds = [...this.selectedSkillIdsValue];
    const index = currentIds.indexOf(skillId);

    if (index > -1) {
      // remove skill
      currentIds.splice(index, 1);
    } else {
      // add skill
      currentIds.push(skillId);
    }

    this.selectedSkillIdsValue = currentIds;

    // update hidden inputs if in a form
    this.updateHiddenInputs();
  }

  updateHiddenInputs() {
    const container = this.element.querySelector('.selected-skills-inputs');
    if (!container) return;

    container.innerHTML = this.selectedSkillIdsValue.map(id =>
      `<input type="hidden" name="travel_plan[skill_ids][]" value="${id}">`
    ).join('');
  }

  getDifficultyColor(difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return 'success';
      case 'intermediate': return 'primary';
      case 'advanced': return 'danger';
      default: return 'secondary';
    }
  }

  getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content;
  }

  showToast(message, type = 'success') {
    // Create toast container if it doesn't exist
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
      toastContainer = document.createElement('div');
      toastContainer.id = 'toast-container';
      toastContainer.className = 'position-fixed bottom-0 end-0 p-3';
      toastContainer.style.zIndex = '11';
      document.body.appendChild(toastContainer);
    }

    // Create toast
    const toastId = `toast-${Date.now()}`;
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type}`;
    toast.role = 'alert';
    toast.ariaLive = 'assertive';
    toast.ariaAtomic = 'true';
    toast.id = toastId;

    toast.innerHTML = `
      <div class="d-flex">
        <div class="toast-body">
          ${message}
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    `;

    toastContainer.appendChild(toast);

    // initialize and show toast
    const bsToast = new bootstrap.Toast(toast, {
      autohide: true,
      delay: 3000
    });
    bsToast.show();

    // remove toast after it's hidden
    toast.addEventListener('hidden.bs.toast', () => {
      toast.remove();
    });
  }
}
