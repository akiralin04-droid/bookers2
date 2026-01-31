Rails.application.routes.draw do
  # 1. トップページ設定 (http://.../)
  root to: "homes#top"

  # 2. Aboutページ設定 (http://.../home/about)
  get "home/about" => "homes#about", as: "about"

  # 3. 認証機能（ログイン・ログアウト・パスワードリセット）
  # ※rails g authentication で自動生成された部分です
  resource :session
  resources :passwords, param: :token

  # 4. 新規登録（Sign Up）用
  # ※後ほどこのためのコントローラーを作成しますが、ルートだけ先に作っておきます
  resource :registration, only: [:new, :create]

  # 5. Booksコントローラー（投稿機能：CRUDすべて）
  resources :books do
    # いいね機能のルーティング（createとdestroyのみ）
    # 単数形 resource にすると、/:book_id/favorites というURLになりIDを含まないので扱いやすいです
    resource :favorites, only: [:create, :destroy]

    resources :book_comments, only: [:create, :destroy]

  end

  # 6. Usersコントローラー（ユーザー機能）
  # ※ユーザー一覧、詳細、編集、更新があればOK（作成と削除は認証機能が担当するため）
  resources :users, only: [:index, :show, :edit, :update] do
    # フォロー機能（create, destroy）
    resource :relationships, only: [:create, :destroy]
    
    # フォロー一覧・フォロワー一覧画面へのルーティング
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  
end