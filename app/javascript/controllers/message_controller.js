import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "button"]

  copy(event) {
    const button = event.currentTarget

    const text = this.textareaTarget.value

    if(!text) return

    navigator.clipboard.writeText(text).then(() => {
      button.textContent = "済み✔︎"
      button.disabled = true
    })
  }
}