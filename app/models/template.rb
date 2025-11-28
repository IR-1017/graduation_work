class Template < ApplicationRecord
  # kindの候補を定数として設定(後にenumに移行しやすい)/freezeとすることで、KINDSを編集不可能にする。
  KINDS = %w[stationery message_card].freeze

  # すでにそのテンプレで作られたlettersがある場合、Template.destroyを実行すると例外を発生させ削除させない設定
  has_many :letters, dependent: :restrict_with_exception

  # kindは必須かつ定義済みの種類（KINDS）のいずれかでなければならない
  validates :kind,
            presence: true,
            inclusion: { in: KINDS }
  # テンプレ名は必須。長さは最大100文字まで
  validates :title,
            presence: true,
            length: { maximum: 100 }
  # layout(JSON)は必須（詳細な中身はvalidate_layout_schemaで検証）
  validates :layout,
            presence: true
  # サムネイル画像パスは任意。存在する場合は255文字以内
  validates :thumbnail_path,
            length: { maximum: 255 },
            allow_blank: true
  # 指定した属性があることを確認。booleanカラムの[true/false/null]うちnullを禁止
  validates :active,
            inclusion: { in: [true, false] }

  validate :validate_layout_schema
  # よく使う絞り込み条件をスコープとして定義
  scope :active, -> { where(active: true) }
  scope :stationery, -> { where(kind: 'stationery') }
  scope :message_cards, -> { where(kind: 'message_card') }

  private

  # layout全体がHashかどうかと、canvas/background/placeholdersの有無・形式をまとめてチェック
  def validate_layout_schema
    unless layout.is_a?(Hash)
      errors.add(:layout, 'はオブジェクト形式(JSON)である必要があります')
      return
    end

    validate_canvas(layout['canvas'])
    validate_background(layout['background'])
    validate_placeholders(layout['placeholders'])
  end

  # canvasがHashであり、width/heightが数値になっているかを検証
  def validate_canvas(canvas)
    unless canvas.is_a?(Hash)
      errors.add(:layout, 'のcanvasが正しく定義されていません')
      return
    end

    %w[width height].each do |key|
      value = canvas[key]
      errors.add(:layout, "のcanvas.#{key}は数値である必要があります") unless value.is_a?(Numeric)
    end
  end

  # backgroundがHashで、type/imageとsrc(画像パス)が正しく設定されているかを検証
  def validate_background(background)
    unless background.is_a?(Hash)
      errors.add(:layout, 'のbackgroundが正しく定義されていません')
      return
    end

    errors.add(:layout, 'のbackground.typeは"image"である必要があります') unless background['type'] == 'image'

    src = background['src']
    return if src.is_a?(String) && src.present?

    errors.add(:layout, 'のbackground.srcは文字列である必要があります')
  end

  # placeholders配列と各要素の必須キー・文字数制限などを検証
  def validate_placeholders(placeholders)
    unless placeholders.is_a?(Array) && placeholders.any?
      errors.add(:layout, 'のplaceholdersは1件以上の配列である必要があります')
      return
    end

    placeholders.each_with_index do |ph, idx|
      unless ph.is_a?(Hash)
        errors.add(:layout, "のplaceholders[#{idx}]が正しい形式ではありません")
        next
      end

      %w[id kind x y width height font_family font_size color align].each do |key|
        errors.add(:layout, "のplaceholders[#{idx}].#{key}は必須です") if ph[key].nil?
      end

      constraints = ph['constraints'] || {}
      if constraints['max_chars'] && !constraints['max_chars'].is_a?(Integer)
        errors.add(:layout, "のplaceholders[#{idx}].constraints.max_charsは整数である必要があります")
      end
    end
  end
end
