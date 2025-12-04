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

  private

  def ensure_view_token
    self.view_token ||= SecureRandom.urlsafe_base64(32)
  end
end

