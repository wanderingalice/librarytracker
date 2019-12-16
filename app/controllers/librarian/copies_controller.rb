class Librarian::CopiesController < ApplicationController
 
def new
  @copy = Copy.new
end

def create
  @library = Library.find_by_id(params[:library_id])
  return render_not_found if @library.blank?
  @copy = @library.copies.create(copy_params)
    if @copy.valid?
      redirect_to librarian_library_path(@library)
    else
      render :new, status: :unprocessable_entity
    end
end

def edit
    @copy = Copy.find_by_id(params[:id])
    @library = Library.find_by_id(params[:libraryid])
    return render_not_found if @copy.blank?
    return render_not_found(:forbidden) if @copy.bookowner != current_user.email
end

def update
    @copy = Copy.find_by_id(params[:id])
    @library = Library.find_by_id(params[:library_id])
    @book = Book.find_by_id(params[:book_id])
    return render_not_found if @copy.blank?
    return render_not_found(:forbidden) if @copy.bookowner != current_user.email
    @copy.update_attributes(copy_params)

     if @copy.valid?
      redirect_to librarian_library_path(@copy.library)
    else
      render :new, status: :unprocessable_entity
    end
end

def destroy
  @copy = Copy.find_by_id(params[:id])
  @library = Library.find_by_id(params[:libraryid])
  return render_not_found if @copy.blank?
  return render_not_found(:forbidden) if @copy.library.user != current_user
  @copy.destroy
  redirect_to librarian_library_path(@copy.library)
end


private

  def copy_params
    params.require(:copy).permit(:bookowner, :book_id, :status, :notes, :loanedto)
  end

end

