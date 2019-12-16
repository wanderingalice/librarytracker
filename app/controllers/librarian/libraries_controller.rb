class Librarian::LibrariesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]


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
    @library = Library.find_by_id(params[:id])
    return render_not_found if @library.blank?
    @copies = Copy.where(library_id: @library.id).order('status ASC').all
  end

  def edit
    @library = Library.find_by_id(params[:id])
    return render_not_found if @library.blank?
    return render_not_found(:forbidden) if @library.user != current_user
  end

  def update
    @library = Library.find_by_id(params[:id])
    return render_not_found if @library.blank?
    return render_not_found(:forbidden) if @library.user != current_user
    @library.update_attributes(library_params)

     if @library.valid?
      redirect_to librarian_library_path(@library)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @library = Library.find_by_id(params[:id])
    return render_not_found if @library.blank?
    return render_not_found(:forbidden) if @library.user != current_user
    @library.destroy
    redirect_to librarian_libraries_url
  end

  private

  def library_params
    params.require(:library).permit(:title, :description, :librarytype, :location)
  end

end
