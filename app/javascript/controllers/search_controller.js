// for homepage/landing page
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions"];

  connect() {
    this.suggestionsList = [];
    this.animationTexts = [
      "go hiking",
      "go to Hokkaido",
      "go rock climbing",
      "explore Mount Fuji",
      "find a hidden waterfall"
    ];
    this.animationIndex = 0;
    this.typingInterval = null;
  }

  startAnimation() {
    this.typingInterval = setInterval(() => {
      this.inputTarget.placeholder = `I want to... ${this.animationTexts[this.animationIndex]}`;
      this.animationIndex = (this.animationIndex + 1) % this.animationTexts.length;
    }, 2000);
  }

  stopAnimation() {
    clearInterval(this.typingInterval);
    this.inputTarget.placeholder = "I want to...";
  }

  fetchResults() {
    const query = this.inputTarget.value.trim();
    if (query.length < 2) {
      this.suggestionsTarget.style.display = "none";
      return;
    }

    fetch(`/search.json?q=${query}`)
      .then(response => response.json())
      .then(data => {
        this.suggestionsList = data;
        this.showSuggestions();
      });
  }

  showSuggestions() {
    if (this.suggestionsList.length === 0) {
      this.suggestionsTarget.style.display = "none";
      return;
    }

    this.suggestionsTarget.innerHTML = this.suggestionsList
      .map(item => `<div data-action="click->search#selectSuggestion">${item}</div>`)
      .join("");

    this.suggestionsTarget.style.display = "block";
  }

  selectSuggestion(event) {
    this.inputTarget.value = event.target.innerText;
    this.suggestionsTarget.style.display = "none";
  }
}
