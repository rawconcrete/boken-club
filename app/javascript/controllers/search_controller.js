// for homepage searchbar
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
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
    this.startTypingAnimation();
  }

  startTypingAnimation() {
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
    } else {
      setTimeout(() => this.startTypingAnimation(), this.isDeleting ? 50 : 100);
    }
  }
}
