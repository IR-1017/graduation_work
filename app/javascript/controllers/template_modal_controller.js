import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    // ESC用ハンドラを this に束縛して保存（後で remove できるように）
    this._onKeydown = this.onKeydown.bind(this)
  }

  open(event) {

    this.modalTarget.classList.remove("hidden")
    document.addEventListener("keydown", this._onKeydown)
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.removeEventListener("keydown", this._onKeydown)
  }

  closeOnBackdrop(event) {

    if (event.target === event.currentTarget) this.close()
  }

  onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}