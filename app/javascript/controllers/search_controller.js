// for homepage searchbar
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions"];

  connect() {
    this.typingTimer;
    this.inputTarget.addEventListener("input", () => this.handleTyping());
  }

  handleTyping() {
    clearTimeout(this.typingTimer);
    const query = this.inputTarget.value.trim();

    if (query.length === 0) {
      this.suggestionsTarget.innerHTML = "";
      return;
    }

    this.typingTimer = setTimeout(() => {
      this.fetchResults(query);
    }, 300); // Debounce search
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
          return `<div class="suggestion" data-action="click->search#goToLocation" data-id="${item.id}">${item.name}</div>`;
        } else if (item.type === "adventure") {
          return `<div class="suggestion" data-action="click->search#goToAdventure" data-id="${item.id}">${item.name}</div>`;
        } else {
          return `<div class="suggestion" data-action="click->search#searchCategory" data-category="${item.category}" data-query="${item.query}">${item.name}</div>`;
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

  searchCategory(event) {
    const category = event.target.dataset.category;
    const query = event.target.dataset.query;
    window.location.href = `/${category}?q=${encodeURIComponent(query)}`;
  }
}
