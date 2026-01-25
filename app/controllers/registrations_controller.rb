class RegistrationsController < ApplicationController
  # ログインしてなくてもアクセスOKにする
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 登録成功したら自動でログインさせて、マイページへ飛ばす
      start_new_session_for @user
      flash[:notice] = "Welcome! You have signed up successfully."
      redirect_to user_path(@user)
    else
      # 失敗したら再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # 要件通り、name と email と password を許可
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end