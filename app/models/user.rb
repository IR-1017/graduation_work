class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #OmniAuthでログインできるようにするためのDevise拡張
  #OmniAuthで使用すプロバイダはgoogle_oauth2と宣言
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :letters, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  #password必須だとgoogle連携のためのupdate(provider/uid)が失敗するので修正(presence削除)
  validates :password, length: { minimum: 7 }, format: { with: VALID_PASSWORD_REGEX }, if: :password_required?

  #Google認証結果からuserを見つける/作る/紐付けする処理
  def self.from_omniauth(auth)
    #認証結果から照合に必要なキーを取り出す
    provider = auth.provider
    uid = auth.uid
    #info -> email,name,imageなど
    #downcaseはemailを小文字に変換
    email = auth.info&.email&.downcase
    
    #既存判定
    user = find_by(provider: provider, uid: uid)
    return user if user

    #emailがすでに登録されていたら、Googleを紐付け
    if email.present?
      user = find_by(email: email)
      if user
        user.update!(provider: provider, uid: uid)
        return user
      end
    end

    #新規登録
    create!(
      email: email || "change-me-#{SecureRandom.hex(8)}@example.com",
      provider: provider,
      uid: uid,
      password: generate_oauth_password
    )
  end
  #VALID_PASSWORD_REGEXに確実に合う文字列を生成
  def self.generate_oauth_password
    letters = ('a'..'z').to_a
    digits  = ('0'..'9').to_a
    #Array.new(10) -> 10個分の配列を作成
    #sample -> 配列からランダムに1つ取り出す
    base = Array.new(10) { (letters + digits).sample }.join
    #作成したpasswordがVALID_PASSWORD_REGEXにマッチしているか。
    #生成されたpasswordが数字のみや英語のみの場合があるので、"a1#{base[0, 8]}" -> 先頭に必ずa1をつける
    base.match?(VALID_PASSWORD_REGEX) ? base : "a1#{base[0, 8]}"
  end

  private
  #passwordのバリテーションを実行するべきか？を判定
  def password_required?
    #new_record -> DBに保存されていないオブジェクト(ActiveRecord)
    #deviseにもpassword_required?メソッドがあるが上書き
    new_record? || password.present? || password_confirmation.present?
  end
end
