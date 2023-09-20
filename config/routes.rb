Rails.application.routes.draw do

  #ユーザー側
  #URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: "public/sessions"
  }

  #ゲストログイン
  devise_scope :user do
    post '/users/guest_session' => 'public/sessions#guest_session'
    #ユーザー登録失敗時のリダイレクトエラー対策
    get 'users' => 'public/registrations#new'
  end

  scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about'
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      collection do
        patch 'unsubscribe' => 'users#unsubscribe'
        patch 'withdraw' => 'users#withdraw'
        get 'user_search' => 'users#search'
      end
    end
    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
      collection do
        get 'search' => 'posts#search', as: 'search'
      end
    end
  end

  #管理者側
  #URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    root 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update, :destroy] do
      resources :comment, only: [:destroy]
    end
  end

end
