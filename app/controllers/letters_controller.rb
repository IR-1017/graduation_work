class LettersController < ApplicationController
  # Devise が提供するメソッド
  # → ログインしていないユーザーは sign_in ページに飛ばす
  before_action :authenticate_user!

  # show で共通的に使う取得処理をまとめる
  before_action :set_letter, only: [:show]

  def index
    #ログインしているuserの作成したletterを取得する。
    @letters = current_user.letters.includes(:template).order(created_at: :desc)
  end

  # GET /letters/new?template_id=1
  def new
    # どのテンプレで手紙を書くか、URLの template_id パラメータから取得する想定
    # 例: /letters/new?template_id=3
    @template = Template.find(params[:template_id])
    @letter = current_user.letters.new(template: @template)
  rescue ActiveRecord::RecordNotFound
    # もし template_id が不正だった場合はテンプレ一覧に戻す
    redirect_to templates_path, alert: "テンプレートが見つかりませんでした。"
  end

  # POST /letters
  # 手紙を実際に保存する処理
  # ※ issue13 で body(JSON)の保存ロジックを本格実装予定なので、ここでは骨組み。
  def create

    @template = Template.find(letter_params[:template_id])
    #ベースとなるletterオブジェクトを生成
    @letter = current_user.letters.new(
      template: @template,
      recipient_name: letter_params[:recipient_name],
      sender_name: letter_params[:sender_name],
      enable_password: letter_params[:enable_password]
    )

    #placehoders(行ごとの本文)をbody(jsonb)に格納。メソッドはmodelで定義
    @letter.build_body_from_placeholders!(
      template: @template,
      placeholders: letter_params[:placeholders] || {}    
    )
    

    if @letter.save
      redirect_to @letter, notice: "手紙を作成しました。"
    else
      # バリデーションエラー時は new を再表示
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to templates_path, alert: "テンプレートが見つかりませんでした。"
  end

  # GET /letters/:id
  # 作成済みの手紙詳細（自分の手紙のみ）
  def show
    # set_letter で @letter は取得済み
  end

  private

  # ログインユーザーの手紙の中からだけ探す
  # → 他人の手紙のURLを叩いても見れないようにするため
  def set_letter
    @letter = current_user.letters.find(params[:id])
  end

  # Strong Parameters
  def letter_params
    params.require(:letter).permit(
      :template_id,
      :recipient_name,
      :sender_name,
      :enable_password,
      :animation_ref,
      # :placeholdersだとハッシュを許可できない。↓の記述だとハッシュ(ネストされた子要素まで)許可できる。
      placeholders: {}
    )
  end
end