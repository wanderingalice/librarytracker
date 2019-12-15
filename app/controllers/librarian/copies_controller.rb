class Librarian::CopiesController < ApplicationController
 
def new
  @copy = Copy.new
  @user = current_user
end

def create
  @copy = library.copy.create(copy_params)
    if @copy.valid?
      redirect_to librarian_library_copy_path(@copy)
    else
      render :new, status: :unprocessable_entity
    end
end

private

  def copy_params
    params.require(:copy).permit(:book_id, :bookowner, :status, :notes, :loanedto)
  end

end

