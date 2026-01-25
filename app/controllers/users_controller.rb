class UsersController < ApplicationController
  def index
    # 1. 右側の一覧表示用（全ユーザー）
    @users = User.all
    
    # 2. 左側の「User info」用（ログインしている自分）
    @user = current_user
    
    # 3. 左側の「New book」用（空っぽの本）
    @book = Book.new
  end

  def show
    # 1. 表示したいユーザーのデータを取得
    @user = User.find(params[:id])
    
    # 2. そのユーザーが投稿した本の一覧を取得
    @books = @user.books
    
    # 3. 左側の「New book」用（空っぽの本）
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    
    # ★アクセス制限
    # ログインユーザーと編集対象のユーザーが違う場合、マイページへ強制送還
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    # ★アクセス制限（念のため、ここでもチェック）
    if @user != current_user
      redirect_to user_path(current_user)
      return
    end

    if @user.update(user_params)
      # 成功時：メッセージを出してマイページへ
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user)
    else
      # 失敗時：編集画面を再表示
      render :edit, status: :unprocessable_entity
    end
  end

end




private

  # ★ストロングパラメータ
  # 名前、自己紹介、プロフィール画像を許可します
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end