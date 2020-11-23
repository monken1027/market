class ProductsController < ApplicationController
  before_action :authorize

  #ユーザー商品一覧ページ
  def top
    @products = Product.where(user_id: current_user.id).order(created_at: "DESC").page(params[:page]).per(9)
  end

  #出品ページ
  def new
    @product = Product.new
    set_categories
  end
  #出品処理
  def create
    @product = Product.new(product_params)
    #登録   
    if @product.save
      flash[:success] = "登録しました。"
      redirect_to products_show_path(@product.id) and return
    else
      flash.now[:danger] = "登録に失敗しました。"
      set_categories
      render "products/new" and return
    end
  end
  
  #ユーザー商品詳細ページ
  def show
    @product = Product.find_by(id: params[:id], user_id: current_user.id)
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to products_path and return
    end
  end
  #削除処理
  def delete
    @product = Product.find_by(id: params[:id])
    if @product.present? && @product.destroy
      flash[:success] = "商品を削除しました。"
    else
      flash[:danger] = "商品の削除に失敗しました。"
    end
    redirect_to products_path and return
  end

  #ユーザー商品編集ページ
  def edit
    @product = Product.find_by(id: params[:id], user_id: current_user.id)
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to products_path and return
    end
    set_categories
    @product.image1.cache! unless @product.image1.blank?
    @product.image2.cache! unless @product.image2.blank?
    @product.image3.cache! unless @product.image3.blank?
  end
  #更新処理
  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:notice] = "商品が存在しません。"
      redirect_to products_path and return
    end
    if @product.update(product_params)
      flash[:success] = "更新しました。"
      redirect_to products_show_path and return
    else
      flash.now[:danger] = "更新に失敗しました。"
      set_categories
      render "products/edit" and return
    end
  end
  
  #お気に入り商品一覧ページ
  def likes
    @products = Product.where(id: UserLike.where(user_id: current_user.id).pluck(:product_id)).order(created_at: "DESC").page(params[:page]).per(9)
  end
  
  private
  def product_params
    params.require(:product).permit(:name, :description, :category_id, :price, :image1, :image2, :image3).merge(user_id: current_user.id).merge(status: 0)
  end
end
