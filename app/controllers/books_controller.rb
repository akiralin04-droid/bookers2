class BooksController < ApplicationController
  def index
    @book = Book.new           # 新規投稿用
    @books = Book.all          # 一覧表示用
    @user = current_user       # 左側のユーザー情報表示用
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id # 誰が投稿したかセット
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index, status: :unprocessable_entity
    end
  end

  def show
    # 1. URLのIDから、表示したい「本」のデータを取得
    @book = Book.find(params[:id])
    
    # 2. 左側の「New book」用（空っぽのインスタンス）
    @new_book = Book.new
    
    # 3. 左側の「User info」用（この本を投稿したユーザー）
    @user = @book.user  
  end

  def edit
    @book = Book.find(params[:id])
    
    # ★アクセス制限の実装
    # もし投稿者とログインユーザーが違ったら、一覧画面に強制送還する
    if @book.user != current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    
    # ★アクセス制限（念のため、更新処理の直前にもチェック）
    if @book.user != current_user
      redirect_to books_path
      return
    end

    if @book.update(book_params)
      # 成功時：メッセージを出して詳細画面へ
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      # 失敗時：編集画面を再表示（エラーメッセージ用）
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    
    # 削除を実行
    @book.destroy
    
    # 成功メッセージ
    flash[:notice] = "Book was successfully destroyed."
    
    # 一覧画面へリダイレクト (Turbo対応のため status: :see_other をつける)
    redirect_to books_path, status: :see_other
  end



  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end