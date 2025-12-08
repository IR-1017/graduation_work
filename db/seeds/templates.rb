# db/seeds/templates.rb
# -------------------------------------------------------
# テンプレート管理用の初期データを投入するための seed ファイル
# 「rails db:seed」を実行すると、このファイルの内容がDBに反映される
# -------------------------------------------------------

puts "== Seeding templates =="

# -------------------------------------------------------
# 便箋テンプレート: Green Leaf Letter（12行）
# layout は jsonb として DB に保存され、テンプレートの設計図として機能する
# -------------------------------------------------------
GREEN_LEAF_LAYOUT = {
  # キャンバス（画像の大きさ）を指定。編集画面での座標計算もここが基準。
  "canvas" => { "width" => 960, "height" => 1350 },

  # 背景画像の設定。フロント側で image_tag で表示される。
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/green_leaf_12lines_full.png"
  },

  # placehoders 配列に、行ごとのテキスト入力欄を定義。
  # [].tap は「空配列を生成 → 中で加工 → 最後に配列自身を返す」便利メソッド。
  "placeholders" => [].tap do |ary|
    # 12行ぶんの placeholder を自動生成
    12.times do |i|
      line = i + 1
      ary << {
        # 行ID。「line_01」「line_02」などの一貫したIDを生成する。
        "id"          => format("line_%02d", line),

        # kind="text" は「テキスト入力欄」であることを意味する。
        "kind"        => "text",

        # x, y はキャンバス内でのテキスト位置（左上基準）
        # y は1行ごとに 70px ずつ下にずらして均等配置
        "x"           => 120,
        "y"           => 340 + 70 * i,

        # テキストボックスの幅・高さ
        "width"       => 720,
        "height"      => 40,

        # デフォルトフォント。それぞれのテンプレートごとに自由に設定可能。
        "font_family" => "Noto Serif JP",
        "font_size"   => 24,
        "color"       => "#333333",
        "align"       => "left",

        # 最大文字数の制限。編集画面のフロント側で利用する想定。
        "constraints" => { "max_chars" => 40 }
      }
    end
  end
}.freeze
# freeze によって定数の変更を防止し、予期せぬ上書きを防ぐ

# -------------------------------------------------------
# 便箋テンプレート: Gray Neutral Letter（12行）
# Green Leaf とレイアウト構造が同一なので、background だけ差し替えて再利用
# merge を使うことで JSON 生成処理を DRY に維持できる
# -------------------------------------------------------
GRAY_NEUTRAL_LAYOUT = GREEN_LEAF_LAYOUT.merge(
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/gray_netural_12lines_full.png"
  }
).freeze

# -------------------------------------------------------
# メッセージカードタイプ: Thank You Floral Card（5行）
# キャンバスが横長（1350x900）で、書き込み領域が中央寄り
# -------------------------------------------------------
BEIGE_FLORAL_LAYOUT = {
  # 横長デザインのため 1350x900
  "canvas" => { "width" => 1350, "height" => 900 },

  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/beige_floral_5lines_full.png"
  },

  # 5行ぶんのテキスト欄を均等配置
  "placeholders" => [].tap do |ary|
    5.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",

        # メッセージカードの白枠に合わせた座標
        "x"           => 260,
        "y"           => 480 + 60 * i,

        "width"       => 830,
        "height"      => 40,

        "font_family" => "Noto Serif JP",
        "font_size"   => 26,
        "color"       => "#333333",
        "align"       => "left",

        "constraints" => { "max_chars" => 30 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
# DB に登録するテンプレート一覧を配列で定義
# find_or_initialize_by で「存在すれば更新・なければ新規」で安全に扱う
# -------------------------------------------------------
templates = [
  {
    kind:           "stationery",
    title:          "Green Leaf Letter",
    layout:         GREEN_LEAF_LAYOUT,
    thumbnail_path: "templates/stationery/green_leaf_12lines_thumb.png",
    active:         true
  },
  {
    kind:           "stationery",
    title:          "Gray Neutral Letter",
    layout:         GRAY_NEUTRAL_LAYOUT,
    thumbnail_path: "templates/stationery/gray_netural_12lines_thumb.png",
    active:         true
  },
  {
    kind:           "message_card",
    title:          "Thank You Floral Card",
    layout:         BEIGE_FLORAL_LAYOUT,
    thumbnail_path: "templates/message_card/beige_floral_5lines_thumb.png",
    active:         true
  }
]

# -------------------------------------------------------
# 1件ずつ DB へ登録（または更新）
# find_or_initialize_by → assign_attributes → save の流れで冪等性を確保
# -------------------------------------------------------
templates.each do |attrs|
  # タイトルで検索。存在しなければ new される。
  template = Template.find_or_initialize_by(title: attrs[:title])

  # ハッシュの値をモデルに一括代入（保存はまだしない）
  template.assign_attributes(attrs)

  # バリデーションに通れば保存、失敗時はエラー内容を表示
  if template.save
    puts "  ✓ #{template.title} (#{template.kind})"  # 成功ログ
  else
    puts "  ✗ #{attrs[:title]} : #{template.errors.full_messages.join(', ')}" # エラーログ
  end
end
