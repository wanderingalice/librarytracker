class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    @book = Book.create(book_params)
  end

  def show
   book = Book.find(params[:id])
   render json: book
  end

  def index

  end

  private

  def book_params
    params.require(:book, :title, :book_id).permit(:isbn, :author, :subtitle, :publisher, :published_date, :description, :page_count, :cover_image_small, :cover_image_large)
  end
end