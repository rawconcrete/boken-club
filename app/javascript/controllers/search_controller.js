// app/javascript/controllers/search_controller.js
// for homepage/landing page searchbar
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions"];

  connect() {
    this.typingTimer;
    this.suggestionsList = [];
    this.animationTexts = [
      "go hiking",
      "explore Mount Fuji",
      "go rock climbing",
      "visit Hokkaido",
      "camp under the stars"
    ];
    this.animationIndex = 0;
    this.typingIndex = 0;
    this.isDeleting = false;
    this.isUserTyping = false;
    this.startTypingAnimation();

    this.inputTarget.addEventListener("input", () => this.handleTyping());
    this.inputTarget.addEventListener("focus", () => this.stopTypingAnimation());
    this.inputTarget.addEventListener("blur", () => {
      if (this.inputTarget.value === "") this.startTypingAnimation();
    });
  }

  startTypingAnimation() {
    if (this.isUserTyping) return; // do not animate if user is typing
    this.stopTypingAnimation(); // ensure no duplicate intervals

    this.typingInterval = setInterval(() => {
      const text = this.animationTexts[this.animationIndex];
      const current = this.isDeleting
        ? text.substring(0, this.typingIndex--)
        : text.substring(0, this.typingIndex++);

      this.inputTarget.placeholder = `I want to... ${current}`;

      if (!this.isDeleting && this.typingIndex === text.length + 1) {
        this.isDeleting = true;
        setTimeout(() => this.startTypingAnimation(), 1200); // Pause before deleting
      } else if (this.isDeleting && this.typingIndex === 0) {
        this.isDeleting = false;
        this.animationIndex = (this.animationIndex + 1) % this.animationTexts.length;
        setTimeout(() => this.startTypingAnimation(), 500);
      }
    }, this.isDeleting ? 50 : 100);
  }

  stopTypingAnimation() {
    clearInterval(this.typingInterval);
  }

  handleTyping() {
    clearTimeout(this.typingTimer);
    this.isUserTyping = true;

    const query = this.inputTarget.value.trim();
    if (!query) {
      this.suggestionsTarget.innerHTML = "";
      this.isUserTyping = false;
      this.startTypingAnimation();
      return;
    }

    this.typingTimer = setTimeout(() => {
      this.fetchResults(query);
    }, 300);
  }


  fetchResults(query) {
    fetch(`/search.json?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => this.showSuggestions(data));
  }

  showSuggestions(suggestions) {
    if (suggestions.length === 0) {
      this.suggestionsTarget.innerHTML = "";
      return;
    }

    this.suggestionsTarget.innerHTML = suggestions
      .map(item => {
        if (item.type === "location") {
          return `<div class="suggestion" data-action="click->search#goToLocation" data-id="${item.id}">
            <div class="d-flex justify-content-between align-items-start">
              <div>
                <strong>${item.name}</strong>
                ${item.prefecture ? `<div class="text-muted small">${item.city || ''}, ${item.prefecture}</div>` : ''}
                ${item.description ? `<div class="text-muted small">${item.description}</div>` : ''}
              </div>
              <span class="badge bg-info">Location</span>
            </div>
          </div>`;
        } else if (item.type === "adventure") {
          return `<div class="suggestion" data-action="click->search#goToAdventure" data-id="${item.id}">
            <div class="d-flex justify-content-between align-items-start">
              <div>
                <strong>${item.name}</strong>
                <div class="text-muted small">${item.details ? item.details.substring(0, 100) + (item.details.length > 100 ? '...' : '') : ''}</div>
              </div>
              <span class="badge bg-success">Adventure</span>
            </div>
          </div>`;
        } else {
          return `<div class="suggestion" data-action="click->search#searchIndex" data-category="${item.category}" data-query="${item.query}">
            <div class="d-flex justify-content-between align-items-center">
              <strong>${item.name}</strong>
              <span class="badge bg-secondary">Search</span>
            </div>
          </div>`;
        }
      })
      .join("");

    this.suggestionsTarget.style.display = "block";
  }

  goToLocation(event) {
    const locationId = event.target.dataset.id;
    window.location.href = `/locations/${locationId}`;
  }

  goToAdventure(event) {
    const adventureId = event.target.dataset.id;
    window.location.href = `/adventures/${adventureId}`;
  }

  searchIndex(event) {
    const category = event.target.dataset.category;
    const query = event.target.dataset.query;

    console.log("Clicked search result:", { category, query });

    if (!category || category === "undefined" || !query || query === "undefined") {
      console.warn("Invalid search result. Debugging...");
      return;
    }

    window.location.href = `/${category}?q=${encodeURIComponent(query)}`;
  }


}
