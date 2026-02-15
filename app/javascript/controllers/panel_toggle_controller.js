import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "toggleButton"]

  toggle() {
    const isHidden = this.panelTarget.classList.contains("hidden")

    if (isHidden) {
      this.panelTarget.classList.remove("hidden")
      this.toggleButtonTarget.textContent = "文字スタイルを閉じる"
      this.toggleButtonTarget.setAttribute("aria-expanded", "true")
    } else {
      this.panelTarget.classList.add("hidden")
      this.toggleButtonTarget.textContent = "文字スタイルを開く"
      this.toggleButtonTarget.setAttribute("aria-expanded", "false")
    }
  }
}