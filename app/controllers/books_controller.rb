class BooksController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.where(book_id: book_params[:book_id]).first 
    @book = Book.create!(book_params) unless @book
    render json: @book 
  end

  def index
    @copy = Copy.new
    @user = current_user
    @book = Book.all
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :title, :book_id, :author, :subtitle, :publisher, :published_date, :description, :page_count, :cover_image_small, :cover_image_large)
  end
end