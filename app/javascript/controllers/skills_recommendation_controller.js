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

    // Track previously seen skills to detect new additions
    this.previousSkillIds = new Set(this.selectedSkillIdsValue);
    this.showSkillNotification = false;
    this.helpTipShown = false; // Track if help tip has been shown yet

    console.log("Travel plan ID:", this.travelPlanIdValue);
    console.log("Initially selected skills:", this.selectedSkillIdsValue);

    // Store for later reference
    this.lastReceivedSkills = [];

    // Listen for location or adventure changes from the travel plan controller
    document.addEventListener('locations-adventures-changed', this.updateSkills.bind(this));

    // Render initial input fields for selected skills
    this.updateHiddenInputs();

    // Set initial state
    let initialGuidance = '';

    if (this.selectedSkillIdsValue.length > 0) {
      const word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills";
      initialGuidance = `
        <div class="alert alert-success">
          <h6><i class="fas fa-check-circle me-2"></i>Skills Already Selected</h6>
          <p class="mb-0">You have ${this.selectedSkillIdsValue.length} ${word} already selected for this trip.</p>
        </div>
      `;
    } else {
      initialGuidance = `
        <div class="alert alert-info">
          <h6><i class="fas fa-lightbulb me-2"></i>Skills Recommendations</h6>
          <p>Select locations and adventures to see what skills you might want to learn for your trip.</p>
          <p class="mb-0"><small>We'll suggest skills based on your selected activities and destinations.</small></p>
        </div>
      `;
    }

    this.skillsListTarget.innerHTML = initialGuidance;
  }

  updateSkills(event) {
    console.log("Skills update event received:", event.detail);

    // Store the event detail for potential re-renders
    this.lastDetail = event.detail;

    // Get location and adventure IDs from the event
    const { locationIds, adventureIds } = event.detail;

    // Don't make the request if there are no locations or adventures
    if (!locationIds.length && !adventureIds.length) {
      console.log("No locations or adventures selected, showing default message");

      let initialGuidance = '';
      if (this.selectedSkillIdsValue.length > 0) {
        const word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills";
        initialGuidance = `
          <div class="alert alert-success">
            <h6><i class="fas fa-check-circle me-2"></i>Skills Already Selected</h6>
            <p class="mb-0">You have ${this.selectedSkillIdsValue.length} ${word} already selected for this trip.</p>
          </div>
        `;
      } else {
        initialGuidance = `
          <div class="alert alert-info">
            <h6><i class="fas fa-lightbulb me-2"></i>Skills Recommendations</h6>
            <p>Select locations and adventures to see what skills you might want to learn for your trip.</p>
            <p class="mb-0"><small>We'll suggest skills based on your selected activities and destinations.</small></p>
          </div>
        `;
      }

      this.skillsListTarget.innerHTML = initialGuidance;
      return;
    }

    // Create params for the API request
    const params = new URLSearchParams();
    if (locationIds.length) params.append('location_ids', locationIds.join(','));
    if (adventureIds.length) params.append('adventure_ids', adventureIds.join(','));

    const url = `/travel_plans/get_recommended_skills?${params}`;
    console.log("Fetching skills from:", url);

    // Set this flag to indicate we want to show notifications for new skills
    this.showSkillNotification = true;
    this.helpTipShown = false; // Reset help tip flag when fetching new skills

    // Display loading state
    this.skillsListTarget.innerHTML = `
      <div class="loading-indicator alert alert-info">
        <div class="d-flex align-items-center">
          <div class="spinner-border spinner-border-sm me-2" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <div>Analyzing your selections and generating skill recommendations...</div>
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

        // Add a small delay to show the loading state for better UX
        setTimeout(() => {
          this.renderSkills(skills);
        }, 1200);
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
    if (!skills || !skills.length) {
      let message = '';

      if (this.selectedSkillIdsValue.length > 0) {
        const word = this.selectedSkillIdsValue.length === 1 ? "skill" : "skills";
        message = `
          <div class="alert alert-success">
            <h6><i class="fas fa-check-circle me-2"></i>Skills Already Selected</h6>
            <p class="mb-0">You have ${this.selectedSkillIdsValue.length} ${word} already selected for this trip.</p>
          </div>
          <div class="alert alert-info">
            <h6><i class="fas fa-info-circle me-2"></i>No Additional Skills Suggested</h6>
            <p class="mb-0">Your current selections don't have specific skill recommendations. Try selecting different locations or adventures.</p>
          </div>
        `;
      } else {
        message = `
          <div class="alert alert-info">
            <h6><i class="fas fa-info-circle me-2"></i>No Skills Recommended</h6>
            <p>No specific skills recommended for this combination of locations and adventures.</p>
            <p class="mb-0">Try selecting different locations or adventures to see skill suggestions.</p>
          </div>
        `;
      }

      this.skillsListTarget.innerHTML = message;
      return;
    }

    // Check for new skills
    const currentSkillIds = new Set(skills.map(skill => skill.id));
    const newSkillIds = new Set([...currentSkillIds].filter(id => !this.previousSkillIds.has(id)));
    const hasNewSkills = newSkillIds.size > 0 && this.previousSkillIds.size > 0;

    // Update the tracking set for next time
    this.previousSkillIds = currentSkillIds;

    // Group skills by category
    const skillsByCategory = skills.reduce((acc, skill) => {
      const category = skill.category || 'Other';
      if (!acc[category]) acc[category] = [];
      acc[category].push(skill);
      return acc;
    }, {});

    // Generate notification for new skills
    let notificationHtml = '';
    if (hasNewSkills && this.showSkillNotification) {
      notificationHtml = `
        <div class="notification-alert alert alert-success alert-dismissible fade show mb-3">
          <div class="d-flex align-items-center">
            <div class="me-2">
              <i class="fas fa-info-circle"></i>
            </div>
            <div>
              <strong>New skills found!</strong> ${newSkillIds.size} new skills recommended based on your selection.
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      `;
    }

    // Build HTML
    let html = notificationHtml;

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

        const isNew = newSkillIds.has(skill.id) && this.showSkillNotification;
        const highlightClass = isNew ? 'new-item border-warning' : '';
        const newBadge = isNew ? '<span class="badge bg-warning text-dark ms-2 new-badge">New</span>' : '';

        // Get source badges (if we have location/adventure info)
        let sourceBadges = '';
        if (skill.adventure_name || skill.location_name) {
          if (skill.adventure_name) {
            const shortName = this.getShortName(skill.adventure_name);
            sourceBadges += `<span class="badge bg-primary me-1">${shortName}</span>`;
          }
          if (skill.location_name) {
            const shortName = this.getShortName(skill.location_name);
            sourceBadges += `<span class="badge bg-info me-1">${shortName}</span>`;
          }
        }

        html += `
          <div class="col-md-12 mb-2">
            <div class="card ${skill.safety_critical ? 'border-warning' : ''} ${highlightClass}" style="position: relative;">
              ${isNew ? '<span class="notification-badge">NEW</span>' : ''}
              <div class="card-body p-3">
                <h6 class="mb-1">${skill.name} ${safetyCriticalBadge} ${newBadge}</h6>
                <p class="small text-muted mb-2">${difficultyBadge}</p>
                ${sourceBadges ? `<div class="mb-2">${sourceBadges}</div>` : ''}
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

    // Add event listener to clear highlight on scroll or hover
    if (hasNewSkills) {
      const newItems = this.skillsListTarget.querySelectorAll('.new-item');
      const clearHighlight = () => {
        newItems.forEach(item => {
          item.classList.remove('new-item', 'border-warning');
          const badge = item.querySelector('.notification-badge');
          if (badge) badge.remove();
        });
        // Remove the event listeners after first trigger
        this.skillsListTarget.removeEventListener('mouseover', clearHighlight);
        this.skillsListTarget.removeEventListener('scroll', clearHighlight);
      };

      this.skillsListTarget.addEventListener('mouseover', clearHighlight);
      this.skillsListTarget.addEventListener('scroll', clearHighlight);

      // Auto-dismiss notification after a few seconds
      setTimeout(() => {
        const notification = this.skillsListTarget.querySelector('.notification-alert');
        if (notification) {
          notification.classList.remove('show');
          setTimeout(() => notification.remove(), 300);
        }
      }, 5000);
    }

    // Reset notification flag after rendering
    this.showSkillNotification = false;
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

      // Add a visual feedback for the action
      const card = button.closest('.card');

      // Show a quick flash effect
      card.style.transition = 'background-color 0.3s';
      const originalBackground = card.style.backgroundColor;

      if (this.selectedSkillIdsValue.includes(skillId)) {
        // Removing skill - flash red
        card.style.backgroundColor = 'rgba(220, 53, 69, 0.1)';
      } else {
        // Adding skill - flash green
        card.style.backgroundColor = 'rgba(40, 167, 69, 0.1)';
      }

      // Revert after the flash effect
      setTimeout(() => {
        card.style.backgroundColor = originalBackground;

        // Toggle the selection and update UI
        this.toggleSkillSelection(skillId);

        // Refresh the UI
        this.renderSkills(this.lastReceivedSkills);
      }, 300);
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
