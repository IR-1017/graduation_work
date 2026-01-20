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
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",

        # 最大文字数の制限。編集画面のフロント側で利用する想定。
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze
# freeze によって定数の変更を防止し、予期せぬ上書きを防ぐ

# -------------------------------------------------------
GRAY_NATURAL_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/gray_natural_12lines_full.png"
  },
  "placeholders" => [].tap do |ary|
    13.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 120,
        "y"           => 270 + 70 * i,
        "width"       => 720,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
AUTUMN_FLOWER_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/autumn_flower_watercolor.png"
  },
  "placeholders" => [].tap do |ary|
    12.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 190,
        "y"           => 270 + 70 * i,
        "width"       => 580,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
CLASSIC_GOLD_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/classic_gold.png"
  },
  "placeholders" => [].tap do |ary|
    11.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 160,
        "y"           => 340 + 70 * i,
        "width"       => 640,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
PLUM_BLOSSOMS_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/plum_blossoms_red.png"
  },
  "placeholders" => [].tap do |ary|
    line_widths = {
      10 => 680,
      11 => 620,
      12 => 440
    }

    12.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 120,
        "y"           => 340 + 70 * i,
        "width"       => line_widths[line] || 720,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
SIMPLE_BLUE_WHITE_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/simple_blue_white.png"
  },
  "placeholders" => [].tap do |ary|
    12.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 140,
        "y"           => 270 + 70 * i,
        "width"       => 680,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
SPRING_FLOWER_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/spring_flower_watercolor.png"
  },
  "placeholders" => [].tap do |ary|
    11.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 140,
        "y"           => 300 + 70 * i,
        "width"       => 680,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
THANKS_SIMPLE_LAYOUT = {
  "canvas" => { "width" => 960, "height" => 1350 },
  "background" => {
    "type" => "image",
    "src"  => "templates/stationery/thanks_simple_black.png"
  },
  "placeholders" => [].tap do |ary|
    10.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 140,
        "y"           => 360 + 70 * i,
        "width"       => 680,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 52 }
      }
    end
  end
}.freeze
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

        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",

        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
BIRTHDAY_CAT_BROWN_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/birthday_cat_brown.png"
  },
  "placeholders" => [].tap do |ary|
    5.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 375,
        "y"           => 480 + 60 * i,
        "width"       => 600,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
BIRTHDAY_CUTE_YELLOW_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/birthday_cute_yellow.png"
  },
  "placeholders" => [].tap do |ary|
    5.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 375,
        "y"           => 380 + 60 * i,
        "width"       => 600,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
BIRTHDAY_ITEM_colorfull_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/birthday_item_colorfull.png"
  },
  "placeholders" => [].tap do |ary|
    5.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 400,
        "y"           => 480 + 60 * i,
        "width"       => 550,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
CONGRATULATIONS_JAPANESE_STYLE_COLORFULL_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/congratulations_japanese_style_colorfull.png"
  },
  "placeholders" => [].tap do |ary|
    2.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 260,
        "y"           => 550 + 60 * i,
        "width"       => 830,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
EXCURSION_YELLOW_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/excursion_yellow.png"
  },
  "placeholders" => [].tap do |ary|
    7.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 260,
        "y"           => 200 + 60 * i,
        "width"       => 830,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
SIMPLE_GOLD_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/simple_gold.png"
  },
  "placeholders" => [].tap do |ary|
    3.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 375,
        "y"           => 510 + 60 * i,
        "width"       => 550,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
SIMPLE_WINTER_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/simple_winter.png"
  },
  "placeholders" => [].tap do |ary|
    line_widths = {
      5 => 800,
      6 => 770,
      7 => 740
    }

    7.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 260,
        "y"           => 280 + 60 * i,
        "width"       => line_widths[line] || 830,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

# -------------------------------------------------------
THANKS_FEMININE_SKYBLUE_LAYOUT = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/thanks_feminine_skyblue.png"
  },
  "placeholders" => [].tap do |ary|
    7.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 260,
        "y"           => 300 + 60 * i,
        "width"       => 830,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
      }
    end
  end
}.freeze

THANKS_SIMPLE_IVORY = {
  "canvas" => { "width" => 1350, "height" => 900 },
  "background" => {
    "type" => "image",
    "src"  => "templates/message_card/thanks_simple_ivory.png"
  },
  "placeholders" => [].tap do |ary|
    5.times do |i|
      line = i + 1
      ary << {
        "id"          => format("line_%02d", line),
        "kind"        => "text",
        "x"           => 260,
        "y"           => 440 + 60 * i,
        "width"       => 830,
        "height"      => 40,
        "font_family" => "Noto Sans JP",
        "font_size"   => 16,
        "color"       => "#000000",
        "align"       => "left",
        "constraints" => { "max_chars" => 42 }
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
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Gray Neutral Letter",
    layout:         GRAY_NATURAL_LAYOUT,
    thumbnail_path: "templates/stationery/gray_natural_12lines_thumb.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "message_card",
    title:          "Thank You Floral Card",
    layout:         BEIGE_FLORAL_LAYOUT,
    thumbnail_path: "templates/message_card/beige_floral_5lines_thumb.png",
    active:         true,
    category:        "generic"
  },
  {
    kind:           "stationery",
    title:          "Autumn Flower Letter",
    layout:         AUTUMN_FLOWER_LAYOUT,
    thumbnail_path: "templates/stationery/autumn_flower_watercolor.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Autumn leaves Letter",
    layout:         AUTUMN_FLOWER_LAYOUT.merge(
      "background" => { "type" => "image", "src" => "templates/stationery/autumn_leaves_beige.png" }
    ),
    thumbnail_path: "templates/stationery/autumn_leaves_beige.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Clasic gold Letter",
    layout:         CLASSIC_GOLD_LAYOUT,
    thumbnail_path: "templates/stationery/classic_gold.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Plum blossoms Letter",
    layout:         PLUM_BLOSSOMS_LAYOUT,
    thumbnail_path: "templates/stationery/plum_blossoms_red.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Simple blue Letter",
    layout:         SIMPLE_BLUE_WHITE_LAYOUT,
    thumbnail_path: "templates/stationery/simple_blue_white.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Spring flower watercolor Letter",
    layout:         SPRING_FLOWER_LAYOUT,
    thumbnail_path: "templates/stationery/spring_flower_watercolor.png",
    active:         true,
    category:       "generic"
  },
  {
    kind:           "stationery",
    title:          "Thanks simple black Letter",
    layout:         THANKS_SIMPLE_LAYOUT,
    thumbnail_path: "templates/stationery/thanks_simple_black.png",
    active:         true,
    category:       "thanks"
  },
  {
    kind:           "message_card",
    title:          "Birthday cat brown Card",
    layout:         BIRTHDAY_CAT_BROWN_LAYOUT,
    thumbnail_path: "templates/message_card/birthday_cat_brown.png",
    active:         true,
    category:        "birthday"
  },
  {
    kind:           "message_card",
    title:          "Birthday cute yellow Card",
    layout:         BIRTHDAY_CUTE_YELLOW_LAYOUT,
    thumbnail_path: "templates/message_card/birthday_cute_yellow.png",
    active:         true,
    category:        "birthday"
  },
  {
    kind:           "message_card",
    title:          "Birthday item colorfull Card",
    layout:         BIRTHDAY_ITEM_colorfull_LAYOUT,
    thumbnail_path: "templates/message_card/birthday_item_colorfull.png",
    active:         true,
    category:        "birthday"
  },
  {
    kind:           "message_card",
    title:          "Congratulations japanese style colorfull Card",
    layout:         CONGRATULATIONS_JAPANESE_STYLE_COLORFULL_LAYOUT,
    thumbnail_path: "templates/message_card/congratulations_japanese_style_colorfull.png",
    active:         true,
    category:        "congratulation"
  },
  {
    kind:           "message_card",
    title:          "Excursion yellow Card",
    layout:         EXCURSION_YELLOW_LAYOUT,
    thumbnail_path: "templates/message_card/excursion_yellow.png",
    active:         true,
    category:        "generic"
  },
  {
    kind:           "message_card",
    title:          "Simple gold",
    layout:         SIMPLE_GOLD_LAYOUT,
    thumbnail_path: "templates/message_card/simple_gold.png",
    active:         true,
    category:        "generic"
  },
  {
    kind:           "message_card",
    title:          "Simple winter",
    layout:         SIMPLE_WINTER_LAYOUT,
    thumbnail_path: "templates/message_card/simple_winter.png",
    active:         true,
    category:        "generic"
  },
  {
    kind:           "message_card",
    title:          "Thanks feminine skyblue",
    layout:         THANKS_FEMININE_SKYBLUE_LAYOUT,
    thumbnail_path: "templates/message_card/thanks_feminine_skyblue.png",
    active:         true,
    category:        "thanks"
  },
  {
    kind:           "message_card",
    title:          "Thanks simple ivory",
    layout:         THANKS_SIMPLE_IVORY,
    thumbnail_path: "templates/message_card/thanks_simple_ivory.png",
    active:         true,
    category:        "thanks"
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
