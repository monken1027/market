class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :user_likes, dependent: :destroy
  
  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  
  enum status: { sale: 0, sold: 1 }

  # バリデーション
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :category_id, presence: true
  #画像は順番通りに登録しなければエラーにする
  validates :image1, presence: true, if: proc { |s| s.image2.present? || s.image3.present? }
  validates :image2, presence: true, if: proc { |s| s.image3.present? }
  
  #ユーザーがいいねをつけているか判断
  def like_from?(user)
    self.user_likes.exists?(user_id: user.id)
  end
  
  #検索機能
  scope :search, -> (search_params) do
    if search_params.blank?
      recent
    elsif search_params[:keyword].present?
      keyword_like(search_params[:keyword]).recent
    else
      add_keyword_like(search_params[:add_keyword])
      .selected_category(search_params[:category_id])
      .check_min_price(search_params[:min_price])
      .check_max_price(search_params[:max_price])
      .selected_order(search_params[:order])
    end
  end
  
  scope :keyword_like, -> (keyword) { where("name LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%") if keyword.present? }
  scope :add_keyword_like, -> (add_keyword) { where("name LIKE ? OR description LIKE ?", "%#{add_keyword}%", "%#{add_keyword}%") if add_keyword.present? }
  scope :selected_category, -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :check_min_price, -> (min_price) { where("price >= ?", min_price.to_i) if min_price.present? }
  scope :check_max_price, -> (max_price) { where("price <= ?", max_price.to_i) if max_price.present? }
  scope :selected_order, -> (order) { order(order) if order.present? }
  scope :recent, -> { order(created_at: :desc) }
end
