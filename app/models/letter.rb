class Letter < ApplicationRecord
  belongs_to :user
  belongs_to :template

  has_many :letter_media, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :accesses, dependent: :destroy

  # issue14 で詳細バリデーションを追加するため、ここでは最低限だけ
  validates :view_token, presence: true
  validates :body, presence: true

  before_validation :ensure_view_token

  #body(jsonb)を組み立てる処理
  def build_body_from_placeholders!(template:, placeholders:)
    #空のハッシュを用意。今後編集機能実装などを見据えて、既にbodyに値があれば、deep_dupメソッドでハッシュ(ネストされた子要素まで)コピーする。
    body_hash = self.body.is_a?(Hash) ? self.body.deep_dup : {}
    #用意したハッシュにテンプレidを入れる.左辺が未定義なら右辺を代入
    body_hash["template_id"] ||= template.id
    #placehodlersの空のハッシュを用意
    body_hash["placeholders"] ||= {}

    #ここから1行ずつparamsで取得し、bodyに写す処理
    #line_id = "line_01", attrs = { "value" => "こんにちは" }みたいな感じ。to_sで文字列として上取るので、""(空文字)となる。
    placeholders.each do |line_id, attrs|
      #そこからvalueを変数に定義
      value = attrs["value"].to_s
      
      body_hash["placeholders"][line_id] ||= {}
      body_hash["placeholders"][line_id]["value"] = value
      body_hash["placeholders"][line_id]["overrides"] ||= nil
    end
    
    body_hash["background"] ||= nil

    self.body = body_hash
  end

  private

  def ensure_view_token
    self.view_token ||= SecureRandom.urlsafe_base64(32)
  end
end

