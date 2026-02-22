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
  //textareaの横幅におさまらない分を次の行へ押し出す処理
  _fitLine(i) {
    //選択中のi行目のtextareaのDOM要素を変数へ
    const el = this.lineTargets[i]
    //i+1行目のtextareaのDOM要素を変数へ
    const next = this.lineTargets[i + 1]
    //i行目のtextareaがない場合は処理をおとす
    if (!el) return

    // textareaのDOM要素から入力された文字列を変数へ(文字列がなければ"")
    const raw = el.value || ""
    //Windows改行（\r\n）も、普通の改行（\n）も、全部消す->改行をなくしたものを変数に。
    const text = raw.replace(/\r?\n/g, "")
    //text(改行含むかもしれない)とtext（改行を全部削除した文字列)が等しくない場合、
    //textarea内の中身を上書きする。変更があったときのみ処理するようにしている
    if (text !== raw) el.value = text

    // selStartに選択中のDOM要素の現在のカーソル位置(のインデックス)を返す ※カーソルor選択中の最初の位置
    const selStart = el.selectionStart
    //選択中でなければselectionStartと同じ位置(インデックス)を返す、選択中であれば選択範囲の最後の位置を返す
    const selEnd = el.selectionEnd
    //論理演算のため、true or falseがはいる。末尾にカーソルがあるならtrue、それ以外false
    const caretAtEnd = (selStart === selEnd) && (selEnd === text.length)
    //el(textarea)内の最終的に適用されているCSSの値をかえす
    const style = getComputedStyle(el)
    //textareaの左右paddingの合計数値(px)を計算する(合計幅)
    //parseFloat()-> 例:12px -> 12
    const paddingX =
      parseFloat(style.paddingLeft || "0") + parseFloat(style.paddingRight || "0")
    //el.clientWidth(選択したtextarea内の要素の内側の寸法(content+padding)-paddingX(padding分)で実際に文字が描画されるcontent部分の横幅を求める
    const maxWidth = el.clientWidth - paddingX
    if (!maxWidth || maxWidth <= 0) return
    //this._ctx.font上書き(計測器の設定を合わせる) 基本的にstyle.fontでfont一式は取得できる
    this._ctx.font = style.font || `${style.fontSize} ${style.fontFamily}`
    //今のテキストの幅がtextareaのcontent幅以内であれば処理をおとす
    if (this._textWidth(text) <= maxWidth) return

    // 二分探索:ソート済みの配列から、中央の要素を基準にして目的のデータを高速に見つけるアルゴリズム
    // 真ん中をためす-> OKなら右へ-> NGなら左へ -> 最大のok値をを探す
    let lo = 0
    let hi = text.length
    //何文字目まで幅におさまるか確認
    while (lo < hi) {
      //Math.ceil->切り上げ
      const mid = Math.ceil((lo + hi) / 2)
      //指定範囲の文字列を取得(前半部分)
      const part = text.slice(0, mid)
      //幅に収まる場合はloの値を更新
      if (this._textWidth(part) <= maxWidth) lo = mid
      //収まらない場合はhiの値を更新
      else hi = mid - 1
    }
    //収まる文字とはみ出る文字にわける
    const head = text.slice(0, lo)
    const tail = text.slice(lo)
    //処理しているtextareaのDOM要素を上書き(収まる文字列に)
    el.value = head
    //次のtextareaが存在して、収まらない文字がある場合の処理
    if (next && tail.length > 0) {
      //元々次の行に入っていた文字列を定義(改行をならしたもの)
      const nextText = (next.value || "").replace(/\r?\n/g, "")
      //元々入っていた文字の前に押し出した文字をいれる
      next.value = tail + nextText

      // 「行末で入力していた」ケースだけ、押し出し後に次の行へ自然に連れていく
      if (caretAtEnd) {
        //次の行にカーソル移動
        next.focus()
        // 次行の先頭に tail を足したので、その直後にカーソルを移動
        const pos = tail.length
        next.setSelectionRange(pos, pos)
      }
    }
  }
  //その文字列が今のフォント設定で何pxの横幅になるか返す関数
  _textWidth(str) {
    //measureText()は測定したテキストの情報をもつオブジェクトを返す。(オブジェクトからwidth(横幅)のみ抽出
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