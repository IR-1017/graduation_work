# frozen_string_literal: true

# アプリ共通のメール設定を行うベースクラス
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
