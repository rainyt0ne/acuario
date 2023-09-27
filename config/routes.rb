Rails.application.routes.draw do

  namespace :public do
    get 'relationships/following'
    get 'relationships/followers'
  end

  #ユーザー側
  #URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: "public/sessions"
  }

  #管理者側
  #URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  #ゲストログイン
  devise_scope :user do
    post '/users/guest_sign_in' => 'public/sessions#guest_sign_in'
  end

  # 管理者側のルーティング
  namespace :admin do
    resources :users, only: [:index, :edit, :update]
    resources :posts, only: [:index, :edit, :update, :destroy]
    resources :comments, only: [:index, :destroy]
  end

  # ユーザー側のルーティング
  scope module: :public do
    root 'homes#top'
    # 投稿ワード検索用
    get 'search' => 'searchs#search'
    # ユーザー退会用
    get '/users/confirm' => 'users#confirm'
    patch '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get :likes
      end
      # フォロー用
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    resources :posts do
      # いいね用
      resource :likes, only: [:create, :destroy]
      # コメント用
      resources :comments, only: [:create, :destroy]
    end
    # 通知用
    resources :notifications, only: [:index]
  end
end
