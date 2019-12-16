require 'rails_helper'
require_dependency "#{::Rails.root}/app/controllers/librarian/libraries_controller"

RSpec.describe Librarian::LibrariesController, type: :controller do 

  describe "libraries#destroy" do
    it "shouldn't allow users who didn't create the library to destroy it" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: library.id }
      expect(response).to have_http_status(:forbidden)
    end


    it "shouldn't let unathenticated users destroy a library" do
      library = FactoryBot.create(:library)
      delete :destroy, params: { id: library.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy libraries" do
      library = FactoryBot.create(:library)
      sign_in library.user
      delete :destroy, params: { id: library.id }
      expect(response).to redirect_to librarian_libraries_path
      library = Library.find_by_id(library.id)
      expect(library).to eq nil
    end

    it "should return a 404 message if we cannot find a library with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "libraries#update action" do 
    it "shouldn't let the user who didn't create the library destroy it" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: library.id, library: { title: "Nope!!" } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a library" do
      library = FactoryBot.create(:library)
      patch :update, params: { id: library.id, library: { title: "Nope!!" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to succesfully update libraries" do
      library = FactoryBot.create(:library, title: "first title")
      sign_in library.user
      patch :update, params: { id: library.id, library: { title: "second title" } }
      expect(response).to redirect_to librarian_library_path
      library.reload
      expect(library.title).to eq "second title"
    end

    it "should have a 404 error if the library cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "NOPE", library: { title: "changed" } }
      expect(response).to have_http_status(:not_found)
    end

    it "should return the edit form as unprocessable entity if edits not valid" do
      library = FactoryBot.create(:library, title: "first title")
      sign_in library.user
      patch :update, params: { id: library.id, library: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      library.reload
      expect(library.title).to eq "first title"
    end
  end

  describe "libraries#edit action" do
    it "shouldn't let a user who did not create the library edit it" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: library.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a library" do
      library = FactoryBot.create(:library)
      get :edit, params: { id: library.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully show the edit form if the library is found" do
      library = FactoryBot.create(:library)
      sign_in library.user
       get :edit, params: { id: library.id }
       expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the library is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'NOPE' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "libraries#show action" do
    it "should successfully show the page if the library is found" do
      library = FactoryBot.create(:library)
      get :show, params: { id: library.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the library isn't found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :show, params: { id: 'NOPE' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "libraries#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "libraries#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "libraries#create action" do
    it "should require the user to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully create a new library in the database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {
        library: {
          title: "rspec test library",
          librarytype: "tester library",
          description: "an RSpec test",
          location: "development only"
        }
      }
      library = Library.last
      expect(response).to redirect_to librarian_library_path(library.id)
      expect(library.title).to eq("rspec test library")
      expect(library.librarytype).to eq("tester library")
      expect(library.description).to eq("an RSpec test")
      expect(library.location).to eq("development only")
      expect(library.user).to eq(user)
    end

    it "should properly take care of validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {
        library: {
          title: "",
          librarytype: "tester library",
          description: "an RSpec test",
          location: "development only"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Library.count).to eq 0
    end
  end
end