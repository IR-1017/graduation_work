import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["line"]

  connect() {
    //命名規則 状態-> _なし. 内部実装の道具-> _あり
    //DOMを読み込んだ瞬間はIME中じゃないよ！ってことをここで明示(インスタンスプロパティ)
    this.composing = false
    //<canvas></canvas>をjブラウザのメモリ上に生成する。(仮想的なDOM要素)(HTML/webAPI)
    //文字幅を測るための作業台
    this._canvas = document.createElement("canvas")
    //2次元コンテキストを取得。(Canvas API)
    this._ctx = this._canvas.getContext("2d")
  }

  // IME(日本後変換)開始を検知して「今は変換中」と記録する。
  // 状態フラグ
  onCompositionStart() {
    this.composing = true
  }
  // IME(日本語変換)完了を検知して「変換中でない」と記録する。
  //
  onCompositionEnd(e) {
    this.composing = false
    this._normalizeFrom(e.currentTarget)
  }

  // ===== 入力 =====
  onInput(e) {
    // IME中は触らない（事故防止）
    if (this.composing || e.isComposing) return
    this._normalizeFrom(e.currentTarget)
  }

  // ===== Enter制御 =====
  onKeydown(e) {
    if (e.key !== "Enter") return

    // Shift+Enterは無効化（改行させない）
    if (e.shiftKey) {
      e.preventDefault()
      return
    }

    // IME変換中のEnterは確定なので邪魔しない
    const imeNow =
      this.composing ||
      e.isComposing ||
      e.key === "Process" ||
      e.keyCode === 229

    if (imeNow) return

    // 確定後Enterだけ次の行へ（改行はさせない）
    e.preventDefault()
    this._focusNext(e.currentTarget)
  }

  // ===== 内部処理 =====
  _normalizeFrom(startEl) {
    const startIdx = this.lineTargets.indexOf(startEl)
    if (startIdx < 0) return

    // start行から下へ、溢れを順に押し出す
    for (let i = startIdx; i < this.lineTargets.length; i++) {
      this._fitLine(i)
    }
  }

  _fitLine(i) {
    const el = this.lineTargets[i]
    const next = this.lineTargets[i + 1]
    if (!el) return

    // 改行除去（既存）
    const raw = el.value || ""
    const text = raw.replace(/\r?\n/g, "")
    if (text !== raw) el.value = text

    // 押し出し前にキャレット位置を覚える
    const selStart = el.selectionStart
    const selEnd = el.selectionEnd
    const caretAtEnd = (selStart === selEnd) && (selEnd === text.length)

    const style = getComputedStyle(el)
    const paddingX =
      parseFloat(style.paddingLeft || "0") + parseFloat(style.paddingRight || "0")
    const maxWidth = el.clientWidth - paddingX
    if (!maxWidth || maxWidth <= 0) return

    this._ctx.font = style.font || `${style.fontSize} ${style.fontFamily}`

    if (this._textWidth(text) <= maxWidth) return

    // 二分探索（既存）
    let lo = 0
    let hi = text.length
    while (lo < hi) {
      const mid = Math.ceil((lo + hi) / 2)
      const part = text.slice(0, mid)
      if (this._textWidth(part) <= maxWidth) lo = mid
      else hi = mid - 1
    }

    const head = text.slice(0, lo)
    const tail = text.slice(lo)

    el.value = head

    if (next && tail.length > 0) {
      const nextText = (next.value || "").replace(/\r?\n/g, "")
      next.value = tail + nextText

      // 追加：押し出し後にフォーカス移動（条件付き）
      if (caretAtEnd) {
        next.focus()
        // 次行の先頭に tail を足したので、その直後にカーソル
        const pos = tail.length
        next.setSelectionRange(pos, pos)
      }
    }
  }
  //その文字列が今のフォント設定で何pxの横幅になるか返す関数
  _textWidth(str) {
    //
    return this._ctx.measureText(str).width
  }
  //IME確定後のEnterで次行へ移動するための処理
  _focusNext(currentEl) {
    //this.lineTargets->textarea(HTML側でtargetがついている）のDOM情報を参照
    //配列.indexOf(探したい要素) ->配列の中でその要素が何番目にあるか数字を返す
    //currentElにはe.currentTarget(Enterを押した要素)が引数としては入る。
    const i = this.lineTargets.indexOf(currentEl)
    //iの次のインデックスにある要素を取り出している。
    const next = this.lineTargets[i + 1]
    //次の行(インデックス)がない場合は処理をおとす。
    if (!next) return
    //nextにはいっているDOM要素(textarea)にカーソルを移動させる。
    next.focus()
    //文字の選択範囲を指定するメソッド(start, end)
    //focus()だと文字の入力の有無で位置が定まらないので、カーソルを先頭へ
    next.setSelectionRange(0, 0)
  }
}