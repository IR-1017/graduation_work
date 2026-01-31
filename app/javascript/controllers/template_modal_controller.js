import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "preview", "kind", "title", "category", "createLink"]
  
  connect() {
    // ESC用ハンドラを this に束縛して保存（後で remove できるように）
    this._onKeydown = this.onKeydown.bind(this)
  }

  open(event) {
    const el = event.currentTarget
    const {
      templateId,
      templateKind,
      templateTitle,
      templateCategory,
      templateThumbnail
    } = el.dataset

    //モーダルに表示
    this.previewTarget.src = templateThumbnail
    this.kindTarget.textContent = templateKind
    this.titleTarget.textContent = templateTitle
    this.categoryTarget.textContent = templateCategory || ""

    this.createLinkTarget.href = `/letters/new?template_id=${templateId}`

    //モーダル自体のopem処理
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