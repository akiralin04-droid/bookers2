class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    # ↓↓↓ ここを :name に変更しました ↓↓↓
    if user = User.authenticate_by(params.permit(:name, :password))
      start_new_session_for user
      # ログイン成功時のメッセージとリダイレクト
      flash[:notice] = "Signed in successfully."
      redirect_to user_path(user)
    else
      redirect_to new_session_path, alert: "Try again later."
    end
  end

  def destroy
    terminate_session
    # ログアウト成功時のメッセージ
    flash[:notice] = "Signed out successfully."
    redirect_to root_path
  end
end