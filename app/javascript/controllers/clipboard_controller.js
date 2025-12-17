// Rails7で標準導入されている Stimulus から Controller クラスを読み込む
import { Controller } from "@hotwired/stimulus"
// Stimulus の Controller を継承したクラスを定義
// data-action や event.currentTarget などが使えるようになる
export default class extends Controller {
  // コピー用の処理
  // ボタンがクリックされたときに呼ばれる
  copy(event) {
    // クリックされたボタン要素そのものを取得(currentTarget→buttonを指定)
    const button = event.currentTarget
    // HTML の data-copy-text 属性に設定されたコピー対象の文字列を取得(dataset→HTML側のdata-copy-textをcopyTextへ変換)
    const text = button.dataset.copyText
    //コピー対象がない時は、以下の処理をスキップ
    if (!text) return
    // Clipboard API を使って文字列をコピーする
    navigator.clipboard.writeText(text).then(() => {
      // コピー成功後、ボタンの表示を「済み✔︎」に変更
      button.textContent = "済み✔︎"
      // 再クリックできないようにボタンを無効化
      button.disabled = true
    })
  }
}