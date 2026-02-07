import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = [
    "line",
    "panel", "help",
    "fontFamily", "fontSize", "color",
    "hiddenFontFamily", "hiddenFontSize", "hiddenColor"
  ]
  //DOMに接続された時（ページ表示）に1度だけ実行される
  connect() {
    //現在選択されている行のIDを今後記憶するための箱を作っている
    this.selectedLineId = null
    //パネルを操作不可状態にする。
    this._setPanelEnabled(false)
  }

  //行を選択した時に、その行に現在適用されているスタイル(default か override)を取得し、パネルの表示を同期する処理
  select(event) {
    //focus/click(HTML側で指定)された要素(DOM)を格納(1つの行)
    const el = event.currentTarget
    //DOMの中から↑で選択されたlinId(例えばdata0line-id="3")を変数へ定義している。ここでローカル変数を定義
    const lineId = el.dataset.lineId
    //thisをつけることでインスタンス変数のように扱える（他のメソッド内で使用できる）
    this.selectedLineId = lineId

    // forEachメソッド(配列の各要素に対して、同じ処理を順番に実行する)
    //this.lineTargets(各行)をt(textarea)として、各行のclassから削除する。
    //ここの処理は指定行をクリックした時に、他の行全てを未選択状態にすることを目的としている。
    this.lineTargets.forEach(t => t.classList.remove("ring-2", "ring-stone-500", "bg-stone-50"))
    el.classList.add("ring-2", "ring-stone-500", "bg-stone-50")

    //パネルを有効化
    this._setPanelEnabled(true)

    //指定したlineIdのスタイル情報(override か default)をオブジェクトとして定義{}
    const current = this._currentStyleFor(lineId)
    //指定したlineIdの現在のスタイル情報をもとに、フォント選択パネルの表示値を更新している。
    this.fontFamilyTarget.value = current.font_family
    //current.font_familyは整数なので、それを文字列に戻している
    this.fontSizeTarget.value = String(current.font_size)
    this.colorTarget.value = current.color
  }

  //パネルで文字スタイルを変更したときに処理が起動
  apply() {
    //スタイルを適用するべき行が決まっていない場合は処理をおとす
    //(!.)は◯◯がない/未設定/空なら処理をやめる
    if (!this.selectedLineId) return
    //現在選択している行に対応するtexeareaのDOM情報を定義
    const line = this._findLine(this.selectedLineId)
    //選択中の行IDはあるが、そのIDに対応するDOMがない場合に処理をおとす
    if (!line) return
    //パネル操作で変更した文字スタイルをローカル変数に定義
    const font_family = this.fontFamilyTarget.value
    const font_size = parseInt(this.fontSizeTarget.value, 10)
    const color = this.colorTarget.value

    //選択されているtextareaのDOM情報のstyleにある文字スタイルを上書き->ブラウザ上では即時反映
    line.style.fontFamily = font_family
    line.style.fontSize = `${font_size}px`
    line.style.color = color

    //変更した文字スタイルをhidden fieldに書き込み、submit時にparams ->DB(JSON)へ渡す準備
    this._setHidden(this.selectedLineId, { font_family, font_size, color })
  }

  // 「デフォルトに戻す」ボタン
  reset() {
    //行が未選択の場合処理を落とす
    if (!this.selectedLineId) return
    //選択した行IDと一致する行IDのtextareaのDOM情報を取得する
    const line = this._findLine(this.selectedLineId)
    //DOMがなければ処理を落とす
    if (!line) return
    //デフォルトのスタイルをハッシュ形式で定義
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
  
  //パネルの有効/無効の処理
  _setPanelEnabled(enabled) {
    if (enabled) {
      this.panelTarget.classList.remove("opacity-50", "pointer-events-none")
    } else {
      this.panelTarget.classList.add("opacity-50", "pointer-events-none")
    }
  }
  //textareaそのもののDOMを返す
  //this.lineTargets ->全ての行配列(textarea)、find ->一致した最初の1要素を返す
  //t.dataset.LineId(そのtextareaが持つ行番号) === lineId(探したい行番号 返り値)
  _findLine(lineId) {
    return this.lineTargets.find(t => t.dataset.lineId === lineId)
  }
  //指定されたlineIdをもつtextareaから、デフォルトの文字スタイルをオブジェクトとして返す処理
  //{ font_family:◯◯,
  //  font_size:◯◯,
  //. color:◯◯}. みたいな感じ
  _defaultsFor(lineId) {
    const line = this._findLine(lineId)
    return {
      // (?.)はオプショナルチェーン演算子 -> 呼び出される関数がundefinedやnullの場合エラーが発生することなく、処理が途中で終わり、undefinedを返す
      //HTML側でdefault_font_family: ph["font_family"]のようにデフォルト値が入っていればそのfontをなければNoto Sans JPをデフォルトとする。
      font_family: line?.dataset.defaultFontFamily || "Noto Sans JP",
      //parseInt -> 文字列を整数に変換する関数 line?.dataset.defaultFontSizeで取れる値は必ず文字列
      //parseInt(◯,10) 10は何進数として解釈するかを指定
      font_size: parseInt(line?.dataset.defaultFontSize || "16", 10),
      color: line?.dataset.defaultColor || "#000000"
    }
  }

  _currentStyleFor(lineId) {
    //指定されたlineIdを持つtextareaからスタイルのdefault(d)をローカル変数に定義(オブジェクト)
    const d = this._defaultsFor(lineId)
    //指定したlineIdと一致するhidden_field_tagに入っている値(上書きしたいスタイル)を読みローカル変数に定義
    const hf = this.hiddenFontFamilyTargets.find(t => t.dataset.lineId === lineId)?.value
    const hs = this.hiddenFontSizeTargets.find(t => t.dataset.lineId === lineId)?.value
    const hc = this.hiddenColorTargets.find(t => t.dataset.lineId === lineId)?.value
    //ここで、上書きの値があればそれ、なければdefaultのスタイルをオブジェクトとして返す
    return {
      font_family: hf || d.font_family,
      font_size: hs ? parseInt(hs, 10) : d.font_size,
      color: hc || d.color
    }
  }
  //lineIdに対応するhidden_fieldを探し、見つかればそのvalueを更新→submit時に値を一緒に送り→paramsで取得→DBへ保存
  _setHidden(lineId, { font_family, font_size, color }) {
    //DOM要素が保存されている
    const hf = this.hiddenFontFamilyTargets.find(t => t.dataset.lineId === lineId)
    const hs = this.hiddenFontSizeTargets.find(t => t.dataset.lineId === lineId)
    const hc = this.hiddenColorTargets.find(t => t.dataset.lineId === lineId)
    //()内が存在する場合だけ、値を更新する
    if (hf) hf.value = font_family
    if (hs) hs.value = font_size === "" ? "" : String(font_size)
    if (hc) hc.value = color
  }
}
