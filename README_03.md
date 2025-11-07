### ER図
（ER図のスクリーンショットの画像を貼り付けてください）
アプリで使用する全テーブル・カラム・リレーションを整理し、最新の状態のスクリーンショットを貼り付けてください。
[![Image from Gyazo](https://i.gyazo.com/1d8854316be924f219755fbd31fa7c4a.png)](https://gyazo.com/1d8854316be924f219755fbd31fa7c4a)
### 本サービスの概要（700文字以内）
※ あなたが作成するアプリの目的・概要・想定ユーザー・主な機能などを700文字以内でまとめてください。
「どんな課題を解決するのか」「誰がどのように使うのか」が伝わる内容にしましょう。

  本サービスは、「手軽なデジタル手紙で特別な気持ちを伝えられるサービス」です。LINEやメールでは伝えきれない特別感を、アニメーション付きのデジタル手紙で実現します。ユーザーはブラウザ上で、便箋/メッセージカードと封筒デザインを選択し、テキストや写真/動画を差込み、デジタル手紙を作成します。作成した手紙は閲覧用URLとパスワードを発行してメール(LINE/QRコード)で送信でき、受信者はリンクを開いて、開封アニメーションの演出とともに、内容を閲覧します。本サービスは、日常の近況報告から誕生日・結婚・出産の報告、感謝のメッセージまで、短いテキスト以上の「特別感」を届けたい場合に最適です。
  想定ユーザーはSNSやメッセージアプリに慣れている18〜35歳を中心としたユーザーです。特にライフイベントの報告やギフト感のあるコミュニケーションを求める層に刺さる設計です。
  主要機能はユーザー登録,テンプレート選択,直感的な編集(フォント/色/サイズ/文字差込位置),画像/動画のアップロード,閲覧用URL/パスワード発行,メール送信,開封アニメーション再生です。
---ここまで---
  
### MVPで実装する予定の機能
※ この項目では、MVP（Minimum Viable Product：最小限の実用的な製品）として実装予定の機能を箇条書きで整理してください。

・ユーザー登録/ログイン
・テンプレート一覧表示(便箋/メッセージカー)
・手紙作成画面(本文入力,文字差込位置,直感的な編集,画像/動画など)
・手紙保存・一覧（ユーザーの作成済み手紙一覧）
・閲覧URLとパスワードの発行。
・送信（メール送信）
・受信側閲覧ページ（パスワード入力→開封アニメーション→本文/画像等表）
・メディア保存（ActiveStorage + S3)
・閲覧ログ記録
・基本的なUI（トップ/登録/ログイン/デザイン選択/作成/送信フロー)
・基本的な認可（自分の手紙のみ編集閲覧制御）

### テーブル詳細
#### Aテーブル（例：ユーザー情報）
- name : ユーザーの表示名（山田太郎）
- email : ログイン認証用のメールアドレス / ユニーク制約 （taro@example.com）
- address : ユーザーの住所（東京都渋谷区〇〇）

※id各テーブルのidとcreated_at,update_atは省略します。
####  Users(ユーザー情報)
- email:string(認証・送信用アドレス)
- encrypted_password:string(認証用)
- created_at:timestamptz
- updated_at:timestamptz
###  Templates(便箋/メッセージカード/封筒デザイン)
- templates_kind:string(staioneryなど)
- title:string(デザイン名)
- layout:jsonb(レイアウト/差込位置などの定義)
###  Letters(作成された手紙情報)
- body:jsonb(本文のデータ/位置/スタイル含む)
- recipient_name:string(受信者名)
- sender_name:string(送信者名)
- view_token:string(閲覧用URL)
- view_password_digest:string(閲覧用passwordハッシュ)
- enable_password:boolean(passwordの要求有無)
- animation_ref(アニメーション参照キー）
###  Letter_media(手紙に添付される画像や動画等の情報)
- media_type;string(image/video)
###  Shares(送信の履歴保存）
- how_to_send:string(送信手段 MVPリリース時はmailのみ)
- destination_information:string(送信者情報,mailadress)
- message:text(お届け用メッセージ)
- destination_status:string(送信状態,pending,sent,failedなど)
- sent_at:timestamptz(送信日時）
###  Accesses(閲覧の確認）
- viewed_at:timestamptz(閲覧日時)

テーブルのリレーション
UsersテーブルとLettersテーブル  1対多
LettersテーブルとLetter_mediaテーブル 1対多
LettersテーブルとTemplatesテーブル  多対1
LettersテーブルとAccessesテーブル 1対多
LettersテーブルとSharesテーブル 1対多
UsersテーブルとSharesテーブル 1対多



※ 上記は一例です。
ご自身のアプリに合わせてテーブル名・カラム名・型・説明を修正してください。

### ER図の注意点
- [ ] プルリクエストに最新のER図のスクリーンショットを画像が表示される形で掲載できているか？
- [ ] テーブル名は複数形になっているか？
- [ ] カラムの型は記載されているか？
- [ ] 外部キーは適切に設けられているか？
- [ ] リレーションは適切に描かれているか？多対多の関係は存在しないか？
- [ ] STIは使用しないER図になっているか？
- [ ] Postsテーブルにpost_nameのように"テーブル名+カラム名"を付けていないか？