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

    this.fetchResults(); // Fetch results on page load
    this.startAnimation();
  }

  startAnimation() {
    this.stopAnimation(); // Ensure no duplicate intervals
    this.typingInterval = setInterval(() => {
      this.inputTarget.placeholder = `I want to... ${this.animationTexts[this.animationIndex]}`;
      this.animationIndex = (this.animationIndex + 1) % this.animationTexts.length;
    }, 2000);
  }

  stopAnimation() {
    clearInterval(this.typingInterval);
  }

  fetchResults() {
    fetch(`/search.json?q=`)
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

    this.suggestionsTarget.style.display = "block"; // Ensure suggestions stay visible
  }

  selectSuggestion(event) {
    this.inputTarget.value = event.target.innerText;
    this.suggestionsTarget.style.display = "none";
  }
}
