import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["short", "full", "button"]

  toggle() {
    if (this.fullTarget.style.display === "none") {
      this.fullTarget.style.display = "block";
      this.shortTarget.style.display = "none";
      this.buttonTarget.innerText = "Show Less";
    } else {
      this.fullTarget.style.display = "none";
      this.shortTarget.style.display = "block";
      this.buttonTarget.innerText = "Show More";
    }
  }
}
