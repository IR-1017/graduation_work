import { Controller } from "@hotwired/stimulus"

/**
 * 役割：
 * - textarea をクリックしたら「選択中の行」を覚える
 * - パネル操作で、選択中の行だけ style を反映する
 * - submit 用 hidden fields に overrides を保存する
 */
export default class extends Controller {
  static targets = [
    "line",
    "panel", "help",
    "fontFamily", "fontSize", "color",
    "hiddenFontFamily", "hiddenFontSize", "hiddenColor"
  ]

  connect() {
    this.selectedLineId = null
    this._setPanelEnabled(false)
  }

  // textarea をクリック/フォーカスしたとき
  select(event) {
    const el = event.currentTarget
    const lineId = el.dataset.lineId
    this.selectedLineId = lineId

    // ① 選択中の行を見た目で分かるようにする
    this.lineTargets.forEach(t => t.classList.remove("ring-2", "ring-stone-500", "bg-stone-50"))
    el.classList.add("ring-2", "ring-stone-500", "bg-stone-50")

    // ② パネルを有効化
    this._setPanelEnabled(true)

    // ③ パネルに「現在値」を表示（hidden があれば overrides、なければ default）
    const current = this._currentStyleFor(lineId)
    this.fontFamilyTarget.value = current.font_family
    this.fontSizeTarget.value = String(current.font_size)
    this.colorTarget.value = current.color
  }

  // パネル操作（フォント/サイズ/色）で呼ばれる
  apply() {
    if (!this.selectedLineId) return

    const line = this._findLine(this.selectedLineId)
    if (!line) return

    const font_family = this.fontFamilyTarget.value
    const font_size = parseInt(this.fontSizeTarget.value, 10)
    const color = this.colorTarget.value

    // ① textarea に即時反映
    line.style.fontFamily = font_family
    line.style.fontSize = `${font_size}px`
    line.style.color = color

    // ② hidden に保存（submit で params に載る）
    this._setHidden(this.selectedLineId, { font_family, font_size, color })
  }

  // 「デフォルトに戻す」ボタン
  reset() {
    if (!this.selectedLineId) return

    const line = this._findLine(this.selectedLineId)
    if (!line) return

    const d = this._defaultsFor(this.selectedLineId)

    // textarea をデフォルトに戻す
    line.style.fontFamily = d.font_family
    line.style.fontSize = `${d.font_size}px`
    line.style.color = d.color

    // hidden を空に（→ サーバ側で nil にする）
    this._setHidden(this.selectedLineId, { font_family: "", font_size: "", color: "" })

    // パネル表示もデフォルトに戻す
    this.fontFamilyTarget.value = d.font_family
    this.fontSizeTarget.value = String(d.font_size)
    this.colorTarget.value = d.color
  }

  // ---- private helpers ----

  _setPanelEnabled(enabled) {
    // ✅ disabled 属性は送信されなくなるので使わない
    if (enabled) {
      this.panelTarget.classList.remove("opacity-50", "pointer-events-none")
    } else {
      this.panelTarget.classList.add("opacity-50", "pointer-events-none")
    }
  }

  _findLine(lineId) {
    return this.lineTargets.find(t => t.dataset.lineId === lineId)
  }

  _defaultsFor(lineId) {
    const line = this._findLine(lineId)
    return {
      font_family: line?.dataset.defaultFontFamily || "Noto Sans JP",
      font_size: parseInt(line?.dataset.defaultFontSize || "16", 10),
      color: line?.dataset.defaultColor || "#000000"
    }
  }

  _currentStyleFor(lineId) {
    // hidden が埋まっていれば overrides とみなす（空なら default）
    const d = this._defaultsFor(lineId)

    const hf = this.hiddenFontFamilyTargets.find(t => t.dataset.lineId === lineId)?.value
    const hs = this.hiddenFontSizeTargets.find(t => t.dataset.lineId === lineId)?.value
    const hc = this.hiddenColorTargets.find(t => t.dataset.lineId === lineId)?.value

    return {
      font_family: hf || d.font_family,
      font_size: hs ? parseInt(hs, 10) : d.font_size,
      color: hc || d.color
    }
  }

  _setHidden(lineId, { font_family, font_size, color }) {
    const hf = this.hiddenFontFamilyTargets.find(t => t.dataset.lineId === lineId)
    const hs = this.hiddenFontSizeTargets.find(t => t.dataset.lineId === lineId)
    const hc = this.hiddenColorTargets.find(t => t.dataset.lineId === lineId)

    if (hf) hf.value = font_family
    if (hs) hs.value = font_size === "" ? "" : String(font_size)
    if (hc) hc.value = color
  }
}
