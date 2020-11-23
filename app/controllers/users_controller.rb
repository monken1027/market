class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  #トップページ表示
  def top
    @user = User.find(current_user.id)
  end
  
  #編集画面表示
  def edit
    @user = User.find(current_user.id)
    @user.image.cache! unless @user.image.blank?
  end

  #更新処理
  def update
    if current_user.update(user_params)
      flash[:success] = "更新しました。"
      redirect_to profiles_path and return
    else
      flash.now[:danger] = "更新に失敗しました。"
      @user = User.new(user_params)
      render "users/edit" and return
    end
  end
  
  #ユーザー登録ページ
  def sign_up
    @user = User.new
    set_categories
  end
  #登録処理
  def sign_up_process
    @user = User.new(user_params)
    if @user.save
      user_sign_in(@user)
      flash[:success] = "登録しました。"
      redirect_to profiles_path and return
    else
      flash.now[:danger] = "登録に失敗しました。"
      set_categories
      render sign_up_path and return
    end
  end
  
  #サインインページ
  def sign_in
    @user = User.new
    set_categories
  end
  #サインイン
  def sign_in_process
    @user = User.find_by(email: user_params[:email])
    if @user.present? && @user.authenticate(user_params[:password])
      user_sign_in(@user)
      flash[:notice] = "サインインに成功しました。"
      redirect_to profiles_path and return
    else
      flash.now[:danger] = "入力内容に不備があります。"
      @user = User.new(email: user_params[:email])
      set_categories
      render sign_in_path and return
    end
  end
  
  #サインアウト
  def sign_out
    user_sign_out
    redirect_to sign_in_path and return
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :image, :image_cache)
  end

end