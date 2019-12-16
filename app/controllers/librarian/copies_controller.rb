class Librarian::CopiesController < ApplicationController
 
def new
  @copy = Copy.new
end

def create

  @library = Library.find_by_id(params[:library_id])
  return render_not_found if @library.blank?
  @copy = @library.copies.create(copy_params)
    if @copy.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
end

private

  def copy_params
    params.require(:copy).permit(:bookowner, :book_id, :status, :notes, :loanedto)
  end

end

