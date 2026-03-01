module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      #全体の流れ. ユーザーが「Googleでログイン」ボタンを押す→Google画面でログイン・許可
      #→Googleからアプリに戻る(callback)→そのときに渡される情報(Googleで登録されている情報一式)が request.env["omniauth.auth"] ハッシュの中に様々(provider等)が格納
      #OmniAuth middleware が Google から取得してくれた認証結果を取り出している
      auth = request.env["omniauth.auth"]
      #Googleから取得した情報をLetteoのUserモデルに変換・統合するメソッド
      #ここで既存Userを見つける/紐づける/新規作成するのどれかを行なっている
      user = User.from_omniauth(auth)
      #オブジェクトがデータベースに保存されている場合はtrue
      if user.persisted?
        #Deviseが提供するメソッド
        #sign_in_and_redirect -> sessionを作ったあとredirectする。
        #event: :authentication -> Devise内部用のイベント指定でログインの種類を示している(認証によるログイン)
        sign_in_and_redirect user, event: :authentication
        #is_navigational_format -> ブラウザのアクセスの場合成功メッセージを表示(画面遷移の時のみ)
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else  
        #ログインページへ遷移
        redirect_to new_user_session_path, alert: "Googleログインに失敗しました。"
      end
    rescue StandardError => e
      Rails.logger.error("[OmniAuth] Google login failed: #{e.class} #{e.message}")
      redirect_to new_user_session_path,alert: "Googleログインに失敗しました。"
    end
  end
end
