class Librarian::LibrariesController < ApplicationController

  before_action :authenticate_user!

  def new
    @library = Library.new
  end

  def create
    @library = current_user.libraries.create(library_params)
    if @library.valid?
      redirect_to librarian_library_path(@library)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @library = Library.find(params[:id])
  end

  private

  def library_params
    params.require(:library).permit(:title, :description, :librarytype, :location)
  end

end
