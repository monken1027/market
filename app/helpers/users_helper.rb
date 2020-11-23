module UsersHelper
    # 渡されたユーザーでサインインする
    def user_sign_in(user)
      session[:user_id] = user.id
    end
    
    # 現在サインイン中のユーザー情報を返す
    def current_user
        if @current_user.nil?
            @current_user = User.find_by(id: session[:user_id])
        else
            @current_user
        end
    end
    
    # ユーザーがサインインしていればtrue, そうでなければfalseを返す
    def user_signed_in?
        current_user.present?
    end
    
    #認証チェック
    def authorize
        redirect_to sign_in_path unless user_signed_in?
    end
    
    #サインインしている場合はトップページへ
    def redirect_to_top_if_signed_in
        redirect_to profiles_path if user_signed_in?
    end

    #サインアウト
    def user_sign_out
        session.delete(:user_id)
        @current_user = nil
    end
    
    #プロフィール画像取得
    def image_url(user)
        if user.image.blank?
            "https://dummyimage.com/200x200/000/fff"
        else
            user.image.url
        end
    end
end
