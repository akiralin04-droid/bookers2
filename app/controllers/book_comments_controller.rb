class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    # 投稿されたコメントの中に、ログインしているユーザーのIDも含める
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    # 前の画面に戻る
    redirect_to book_path(book)
  end

  def destroy
    # URLから「どのコメントか」を探して削除
    # 他人のコメントを消せないよう、current_user.book_comments から探す
    BookComment.find(params[:id]).destroy
    redirect_to book_path(params[:book_id])
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end