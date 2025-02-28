// app/javascript/controllers/skills_recommendation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["skillsList"]

  connect() {
    // listen for location or adventure changes from the travel plan controller
    document.addEventListener('locations-adventures-changed', this.updateSkills.bind(this))
  }

  updateSkills(event) {
    // get location and adventure IDs from the event
    const { locationIds, adventureIds } = event.detail

    // don't make the request if there are no locations or adventures
    if (!locationIds.length && !adventureIds.length) {
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          Select locations and adventures to see recommended skills.
        </div>
      `
      return
    }

    // create params for the API request
    const params = new URLSearchParams()
    if (locationIds.length) params.append('location_ids', locationIds.join(','))
    if (adventureIds.length) params.append('adventure_ids', adventureIds.join(','))

    // make the API request
    fetch(`/travel_plans/get_recommended_skills?${params}`)
      .then(response => response.json())
      .then(skills => this.renderSkills(skills))
      .catch(error => {
        console.error('Error fetching skills:', error)
        this.skillsListTarget.innerHTML = `
          <div class="alert alert-danger">
            Error loading skill recommendations. Please try again.
          </div>
        `
      })
  }

  renderSkills(skills) {
    if (!skills.length) {
      this.skillsListTarget.innerHTML = `
        <div class="alert alert-info">
          No specific skills recommended for this trip.
        </div>
      `
      return
    }

    // group skills by category
    const skillsByCategory = skills.reduce((acc, skill) => {
      const category = skill.category || 'Other'
      if (!acc[category]) acc[category] = []
      acc[category].push(skill)
      return acc
    }, {})

    // build HTML
    let html = ''

    Object.entries(skillsByCategory).forEach(([category, categorySkills]) => {
      html += `
        <div class="mb-3">
          <h5 class="text-capitalize">${category}</h5>
          <div class="row g-2">
      `

      categorySkills.forEach(skill => {
        const safetyCriticalBadge = skill.safety_critical
          ? `<span class="badge bg-warning text-dark ms-1">Safety Critical</span>`
          : ''

        html += `
          <div class="col-md-6">
            <div class="card ${skill.safety_critical ? 'border-warning' : ''}">
              <div class="card-body p-3">
                <h6 class="mb-1">${skill.name} ${safetyCriticalBadge}</h6>
                <p class="small text-muted mb-2">${skill.difficulty || 'beginner'} level</p>
                <small class="d-block mb-2">${skill.details.substring(0, 100)}${skill.details.length > 100 ? '...' : ''}</small>
                <a href="/skills/${skill.id}" class="btn btn-sm btn-outline-primary" target="_blank">Learn More</a>
              </div>
            </div>
          </div>
        `
      })

      html += `
          </div>
        </div>
      `
    })

    this.skillsListTarget.innerHTML = html
  }
}
