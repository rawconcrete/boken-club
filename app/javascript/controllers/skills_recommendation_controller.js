// app/javascript/controllers/skills_recommendation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["skillsList", "selectedSkillsContainer"]
  static values = {
    travelPlanId: Number,
    selectedSkillIds: Array
  }

  connect() {
    console.log("Skills recommendation controller connected");

    // Initialize selectedSkillIds if not set
    if (!this.hasSelectedSkillIdsValue) {
      this.selectedSkillIdsValue = [];
    } else {
      // Convert string IDs to numbers for consistency
      this.selectedSkillIdsValue = this.selectedSkillIdsValue.map(id => Number(id));
    }

    console.log("Travel plan ID:", this.travelPlanIdValue);
    console.log("Initially selected skills:", this.selectedSkillIdsValue);

    // Store for later reference
    this.lastReceivedSkills = [];

    // Listen for location or adventure changes from the travel plan controller
    document.addEventListener('locations-adventures-changed', this.updateSkills.bind(this));

    // Render initial input fields for selected skills
    this.updateHiddenInputs();

    // Set initial state
    let word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills"
    let string = `<p>You have ${this.selectedSkillIdsValue.length} ${word} already selected.</p>`

    this.skillsListTarget.innerHTML = `
      <div class="alert alert-info">
        <p>Select locations and adventures to see recommended skills.</p>
        ${string}
      </div>
    `;
  }

  updateSkills(event) {
    console.log("Skills update event received:", event.detail);

    // Store the event detail for potential re-renders
    this.lastDetail = event.detail;

    // Get location and adventure IDs from the event
    const { locationIds, adventureIds } = event.detail;

    // Don't make the request if there are no locations or adventures
    let word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills"
    let string = `<p>You have ${this.selectedSkillIdsValue.length} ${word} already selected.</p>`

    if (!locationIds.length && !adventureIds.length) {
      console.log("No locations or adventures selected, showing default message");
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          <p>Select locations and adventures to see recommended skills.</p>
          ${string}
        </div>
      `;
      return;
    }

    // Create params for the API request
    const params = new URLSearchParams();
    if (locationIds.length) params.append('location_ids', locationIds.join(','));
    if (adventureIds.length) params.append('adventure_ids', adventureIds.join(','));

    const url = `/travel_plans/get_recommended_skills?${params}`;
    console.log("Fetching skills from:", url);

    // Display loading state
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

    // Make the API request
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
        this.lastReceivedSkills = skills; // Store for later re-renders
        this.renderSkills(skills);
      })
      .catch(error => {
        console.error('Error fetching skills:', error);
        this.skillsListTarget.innerHTML = `
          <div class="alert alert-yellow alert-danger">
            <p>Error loading skill recommendations: ${error.message}</p>
            <p class="small mb-0">Try refreshing the page or selecting different locations/adventures.</p>
          </div>
        `;
      });
  }

  renderSkills(skills) {
    // Handle empty or null skills
    let word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills"
    let string = `<p>You have ${this.selectedSkillIdsValue.length} ${word} already selected.</p>`

    if (!skills || !skills.length) {
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          <p>No specific skills recommended for this trip.</p>
          ${string}
        </div>
      `;
      return;
    }

    // Group skills by category
    const skillsByCategory = skills.reduce((acc, skill) => {
      const category = skill.category || 'Other';
      if (!acc[category]) acc[category] = [];
      acc[category].push(skill);
      return acc;
    }, {});

    // Build HTML
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

        const isSelected = this.selectedSkillIdsValue.includes(Number(skill.id));
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

    this.skillsListTarget.innerHTML = html;
  }

  toggleSkill(event) {
    event.preventDefault(); // Prevent form submission

    const button = event.currentTarget;
    const skillId = parseInt(button.dataset.skillId, 10);

    console.log(`Toggling skill ${skillId}`);

    // For existing travel plans, make API call to add/remove
    if (this.hasTravelPlanIdValue && this.travelPlanIdValue > 0) {
      const isSelected = this.selectedSkillIdsValue.includes(skillId);

      // Set UI loading state
      button.disabled = true;
      button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...';

      if (isSelected) {
        // Remove skill
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
            // Show success message
            this.showToast('Skill removed from travel plan.');
          } else {
            console.error('Error removing skill:', data.error);
            this.showToast('Error removing skill.', 'danger');
          }
          // Re-render UI
          this.renderSkills(this.lastReceivedSkills);
        })
        .catch(error => {
          console.error('Error:', error);
          this.showToast('Error removing skill.', 'danger');
          button.disabled = false;
          button.innerHTML = '<i class="fas fa-check"></i> Selected';
        });
      } else {
        // Add skill
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
            // Show success message
            this.showToast('Skill added to travel plan!');
          } else {
            console.error('Error adding skill:', data.errors);
            this.showToast('Error adding skill.', 'danger');
          }
          // Re-render UI
          this.renderSkills(this.lastReceivedSkills);
        })
        .catch(error => {
          console.error('Error:', error);
          this.showToast('Error adding skill.', 'danger');
          button.disabled = false;
          button.innerHTML = '<i class="fas fa-plus"></i> Add to Plan';
        });
      }
    } else {
      // For new travel plans - just toggle the selection locally
      this.toggleSkillSelection(skillId);
      // Refresh the UI
      this.renderSkills(this.lastReceivedSkills);
    }
  }

  toggleSkillSelection(skillId) {
    console.log("Before toggle:", this.selectedSkillIdsValue);
    skillId = Number(skillId); // Ensure it's a number for consistent comparison

    const currentIds = [...this.selectedSkillIdsValue];
    const index = currentIds.indexOf(skillId);

    if (index > -1) {
      // Remove skill
      currentIds.splice(index, 1);
    } else {
      // Add skill
      currentIds.push(skillId);
    }

    this.selectedSkillIdsValue = currentIds;

    // Update hidden inputs after changing selection
    this.updateHiddenInputs();

    console.log("After toggle:", this.selectedSkillIdsValue);
  }

  updateHiddenInputs() {
    // Get or create the container for selected skills
    let container = document.getElementById('selected-skills-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'selected-skills-container';
      container.style.display = 'none';
      this.element.appendChild(container);
    }

    // Clear the container
    container.innerHTML = '';

    // Add hidden inputs for each selected skill
    this.selectedSkillIdsValue.forEach(skillId => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'travel_plan[skill_ids][]';
      input.value = skillId;
      container.appendChild(input);
    });

    console.log(`Updated hidden inputs: ${this.selectedSkillIdsValue.length} skills selected`);
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

    // Initialize and show toast using DOM API
    toast.classList.add('show');

    // Remove toast after timeout
    setTimeout(() => {
      console.log("timer");
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 500);
    }, 3000);
  }
}
