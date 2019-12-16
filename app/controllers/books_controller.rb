class BooksController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.where(book_id: book_params[:book_id]).first 
    @book = Book.create!(book_params) unless @book
    redirect_to book_path(@book)
  end

  def index
    @copy = Copy.new
    @user = current_user
    @book = Book.all
  end

  def show
    @book = Book.find_by_id(params[:id])
    @user = current_user
    @copy = Copy.new
    return render_not_found if @book.blank?
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :title, :book_id, :author, :subtitle, :publisher, :published_date, :description, :page_count, :cover_image_small, :cover_image_large)
  end
end