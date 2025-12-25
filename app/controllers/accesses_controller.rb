class AccessesController < ApplicationController
  def show
    @letter = Letter.find_by!(view_token: params[:token])
    @template = @letter.template
    #view側で使う（パスワードが必要かどうか）
    @password_required = @letter.enable_password?
    #view側で使う（このブラウザがこのtokenを認証済みか）
    @authorized = authorized_for?(@letter)
    
  end

  def verify
    @letter = Letter.find_by!(view_token: params[:token])

    # パスワード不要の手紙なら即OK扱いでshowへ
    unless @letter.enable_password?
      authorize!(@letter)
      #これ以下の処理を実行しないようにするためreturnを使用
      return redirect_to public_letter_path(@letter.view_token)
    end
    #view側から取得したパシワードを格納(空でも""になるように.to_sで文字列化)
    input = params[:view_password].to_s
    #letterモデルでhas_secure_passwordを定義することで、使用することができるメソッド。
    if @letter.authenticate_view_password(input)
      #sessionに値を保持
      authorize!(@letter)
      #verifyは処理専用で、表示はshowに集約する設計なので、成功/失敗どちらもshowへredirectする（差分はflashとセッション状態）
      redirect_to public_letter_path(@letter.view_token), notice: "認証しました"
    else
      redirect_to public_letter_path(@letter.view_token), alert: "パスワードが違います"
    end
  end

  def public_page?
    true
  end


  private
  #認証済みかどうかチェックするメソッド（セッションにこのtokenが入っていれば“このブラウザは認証済み”とみなす）
  def authorized_for?(letter)
    (session[:authorized_letter_tokens] || []).include?(letter.view_token)
  end
  #認証済みtokenをsessionに保持
  def authorize!(letter)
    session[:authorized_letter_tokens] ||= []
    session[:authorized_letter_tokens] << letter.view_token
    session[:authorized_letter_tokens].uniq!
  end
end