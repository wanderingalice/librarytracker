class LibrariesController < ApplicationController
before_action :authenticate_user!
  def index
    @libraries = Library.all
  end

  def show
    @library = Library.find(params[:id])
  end


end
