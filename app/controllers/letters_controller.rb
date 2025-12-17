class LettersController < ApplicationController
  # Devise が提供するメソッド
  # → ログインしていないユーザーは sign_in ページに飛ばす
  before_action :authenticate_user!

  # show / share で共通的に使う取得処理をまとめる
  before_action :set_letter, only: [:show, :share]

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
      password_in_session(@letter)
      redirect_to share_letter_path(@letter), notice: "手紙を作成しました。共有情報を確認してください。"
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
    @generated_view_password = session.dig(:generated_view_password_by_letter_id, @letter.id.to_s)
  end

  def share
    @generated_view_password = session.dig(:generated_view_password_by_letter_id, @letter.id.to_s)
  end

  private

  # ログインユーザーの手紙の中からだけ探す
  # → 他人の手紙のURLを叩いても見れないようにするため
  def set_letter
    @letter = current_user.letters.find(params[:id])
    @template = @letter.template
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

  def password_in_session(letter)
    return if letter.generated_view_password.blank?

    session[:generated_view_password_by_letter_id] ||= {}
    session[:generated_view_password_by_letter_id][letter.id.to_s] = letter.generated_view_password
  end
end
