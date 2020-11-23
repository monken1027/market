class MarketsController < ApplicationController
  before_action :authorize, only: [:payment]
  
  #商品一覧ページ
  def top
    @products = Product.search(search_params).page(params[:page]).per(9)
    set_categories
  end
  #いいね機能
  def like
    @user_like = UserLike.find_by(product_id: params[:id], user_id: current_user.id)
    if @user_like.present?
      @user_like.destroy
    else
      UserLike.create(product_id: params[:id], user_id: current_user.id)
    end
    redirect_back(fallback_location: markets_path)
  end
  
  #商品詳細ページ
  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to markets_path and return
    elsif current_user.present? && @product.user_id == current_user.id
      #自分の商品の場合はユーザー商品詳細に遷移する
      redirect_to products_show_path(@product.id) and return
    end
    set_categories
  end

  #購入確認ページ
  def payment
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to markets_path and return
    elsif @product.user_id == current_user.id
      #自分の商品の場合はユーザー商品詳細に遷移する
      redirect_to products_show_path(@product.id) and return
    end
    set_categories
  end
  #購入処理
  def payment_process
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to markets_path and return
    end
    if @product.update(status: "sold")
      flash[:success] = "商品を購入しました。"
    else
      flash[:danger] = "商品を購入できませんでした。"
    end
    redirect_to markets_path and return
  end
  
  private 
  def search_params
    params.fetch(:search,{}).permit(:keyword, :add_keyword, :category_id, :min_price, :max_price, :order)
  end
end
