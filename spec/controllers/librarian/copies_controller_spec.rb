require 'rails_helper'
require_dependency "#{::Rails.root}/app/controllers/librarian/copies_controller" 
RSpec.describe Librarian::CopiesController, type: :controller do 

  describe "copies#destroy" do
    it "shouldn't allow users who don't own the library to destroy the copy" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      copy = FactoryBot.create(:copy)
      sign_in user
      delete :destroy, params: { library_id: library.id, id: copy.id,}
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a copy" do
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy)
      delete :destroy, params: { library_id: library.id, id: copy.id,}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy a copy" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy)
      sign_in copy.library.user
      delete :destroy, params: { library_id: library.id, id: copy.id }
      expect(response).to redirect_to librarian_library_path(copy.library.id)
      copy = Copy.find_by_id(copy.id)
      expect(copy).to eq nil
    end

    it "should return a 404 error if it cannot find a copy with the specified id" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      sign_in user
      delete :destroy, params: { library_id: '1', id: 'nope' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "copies#update action" do
    it "shouldn't allow a user who doesn't own the library of the copy update it" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      copy = FactoryBot.create(:copy)
      sign_in user
      patch :update, params: { library_id: library.id, id: copy.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't allow a unauthenticated user to update a copy" do
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy)
      patch :update, params: { library_id: library.id, id: copy.id,}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update a copy" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy, notes: "test notes 1")
      sign_in copy.library.user
      patch :update, params: { library_id: library.id, id: copy.id, copy: { notes: "test again" } }
      expect(response).to redirect_to librarian_library_path(copy.library.id)
      copy.reload
      expect(copy.notes).to eq "test again"
    end

    it "should have a 404 error if the copy can't be found" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      sign_in user
      patch :update, params: { library_id: library.id, id: "NOPE"}
      expect(response).to have_http_status(:not_found)
    end

    it "should return the edit form as unprocessable entity if the edits not valid" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy, status: "In Library")
      sign_in copy.library.user
      patch :update, params: { library_id: library.id, id: copy.id, copy: { status: "test again" } }
      expect(response).to have_http_status(:unprocessable_entity)
      copy.reload
      expect(copy.status).to eq "In Library"
    end
  end

  describe "copies#edit action" do
    it "shouldn't let a user who did not create the library edit a copy" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      copy = FactoryBot.create(:copy)
      sign_in user
      get :edit, params: { library_id: library.id, id: copy.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a copy" do
      library = FactoryBot.create(:library)
      user = FactoryBot.create(:user)
      copy = FactoryBot.create(:copy)
      get :edit, params: { library_id: library.id, id: copy.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the library is found" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      copy = FactoryBot.create(:copy, notes: "test notes 1")
      sign_in copy.library.user
      get :edit, params: { library_id: library.id, id: copy.id, copy: { notes: "test again" } }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the copy isn't found" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      sign_in user
      get :edit, params: { library_id: library.id, id: "NOPE"}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "copy#new action" do
    it "shouldn't let an unauthenticated user add a copy" do
      library = FactoryBot.create(:library)
      book = FactoryBot.create(:book)
      get :new, params: { library_id: library.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "copy#create action" do
    it "should require the user to be logged in" do
      library = FactoryBot.create(:library)
      get :new, params: { library_id: library.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new copy in the database" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      book = FactoryBot.create(:book)
      sign_in library.user
      post :create, params: { library_id: library.id,
        copy: {
          bookowner: user.email,
          book_id: book.id,
          status: "In Library",
          notes: "test copy!!",
          loanedto: ""
        }
      }
      copy = Copy.last
      expect(response).to redirect_to librarian_library_path(library.id)
      expect(copy.status).to eq("In Library")
      expect(copy.notes).to eq("test copy!!")
      expect(copy.bookowner).to eq(user.email)
      expect(copy.library_id).to eq(library.id)
    end

    it "should catch validation errors properly" do
      user = FactoryBot.create(:user)
      library = FactoryBot.create(:library)
      book = FactoryBot.create(:book)
      sign_in library.user
      post :create, params: { library_id: library.id,
        copy: {
          bookowner: user.email,
          book_id: book.id,
          status: "not right",
          notes: "test copy!!",
          loanedto: ""
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Copy.count).to eq 0
    end
  end
end