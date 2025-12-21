import { Controller } from "@hotwired/stimulus"
import lottie from "lottie-web"

export default class extends Controller {
  static targets = ["container", "button", "modal", "modalCard"]
  static values = { path: String }

  connect() {
    this.animation = lottie.loadAnimation({
      container: this.containerTarget,
      renderer: "svg",
      loop: false,
      autoplay: false,
      path: this.pathValue
    })

    this.animation.addEventListener("DOMLoaded", () => {
      this.animation.goToAndStop(0, true)
    })

    this._opened = false
  }

  disconnect() {
    if (this.animation) this.animation.destroy()
  }

  open() {
    if (this._opened) return
    this._opened = true

    this.buttonTarget.disabled = true
    this.buttonTarget.textContent = "開封中…"

    const STOP_FRAME = 60

    const onEnterFrame = () => {
      if (this.animation.currentFrame >= STOP_FRAME) {
        this.animation.removeEventListener("enterFrame", onEnterFrame)
        this.animation.goToAndStop(STOP_FRAME, true)
        this.showModal()
      }
    }

    this.animation.addEventListener("enterFrame", onEnterFrame)
    this.animation.goToAndPlay(0, true)
  }

  showModal() {
    // 背景フェードイン
    this.modalTarget.classList.remove("opacity-0", "pointer-events-none")
    this.modalTarget.classList.add("opacity-100")
    this.modalTarget.setAttribute("aria-hidden", "false")

    // カード（スケール＋フェード）
    requestAnimationFrame(() => {
      this.modalCardTarget.classList.remove("opacity-0", "scale-95")
      this.modalCardTarget.classList.add("opacity-100", "scale-100")
    })
  }

  close() {
    // カードを先に縮める
    this.modalCardTarget.classList.add("opacity-0", "scale-95")
    this.modalCardTarget.classList.remove("opacity-100", "scale-100")

    // 背景フェードアウト
    this.modalTarget.classList.add("opacity-0")
    this.modalTarget.classList.remove("opacity-100")

    // transition完了後にクリック不可へ
    window.setTimeout(() => {
      this.modalTarget.classList.add("pointer-events-none")
      this.modalTarget.setAttribute("aria-hidden", "true")
    }, 300)
  }
}
