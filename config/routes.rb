Rails.application.routes.draw do
  #ユーザープロフィール
  get 'users/profiles', to:'users#top', as: :profiles
  get 'users/profiles/edit', to:'users#edit', as: :profiles_edit
  post 'users/profiles/update', to:'users#update', as: :profiles_update
  #ユーザー登録／サインイン
  get 'users/sign_up', to:'users#sign_up', as: :sign_up
  post 'users/sign_up', to:'users#sign_up_process'
  get 'users/sign_in', to:'users#sign_in', as: :sign_in
  post 'users/sign_in', to:'users#sign_in_process'
  #サインアウト
  get 'users/sign_out', to:'users#sign_out', as: :sign_out
  #ユーザー商品関連
  get 'users/products', to:'products#top', as: :products
  get 'users/products/new', to:'products#new', as: :products_new
  post 'users/products/create', to:'products#create', as: :products_create
  get 'users/products/:id', to:'products#show', as: :products_show
  post 'users/products/:id/delete', to:'products#delete', as: :products_delete
  get 'users/products/:id/edit', to:'products#edit', as: :products_edit
  post 'users/products/:id/update', to:'products#update', as: :products_update
  get 'users/likes', to:'products#likes', as: :likes
  #商品一覧関連
  get '/', to:'markets#top', as: :markets
  get 'markets/:id', to:'markets#show', as: :markets_show
  get 'markets/:id/like', to:'markets#like', as: :markets_like
  get 'markets/:id/payment', to:'markets#payment', as: :markets_payment
  post 'markets/:id/payment', to:'markets#payment_process', as: :payment_process
end
