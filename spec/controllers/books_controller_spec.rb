require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe "books#index action" do
    it "should successfully show the page" do
      user = FactoryBot.create(:user)
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "books#create action" do
    it "should require users to be logged in" do
      get :create
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully allow a user to create a book" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        book: {
        title: "TestBook",
        subtitle: "Something witty here",
        book_id: "-abc-123-",
        isbn: "1234567890",
        author: "Nobody Nowhere",
        publisher: "Some Publisher",
        published_date: "12/12/1989",
        description: "something silly here",
        page_count: "42",
        cover_image_small: "http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE70qPSF352d2Qk9fy-GR6LGcmbIce8LeYon92LQ7ix5FGb5NA48KVbucB5m94MRzjNybMRyp_eSKld72lnad0MFlHwCZW_w19XwavFWoPKyuw8GXbaYZyIbyyCu18uu4HBpx3L_W&source=gbs_api",
        cover_image_large: "http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&imgtk=AFLRE71_VpAYUr4vRw_Ftp6b1bS0mqXfI5guO6meGMZyNOlftsmxoMn5Zrb3eVjCAIhAzxdG_Dp3iwbGOR64seJrUDi5b2T1inCW7Oqt5eVs-1XehHlqLZbA-tBF16BjMZg2TTQyjSKw&source=gbs_api" 
        }
      }
      expect(response).to have_http_status(:success)
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value['title']).to eq("TestBook")
      expect(response_value['subtitle']).to eq("Something witty here")
      expect(response_value['book_id']).to eq("-abc-123-")
      expect(response_value['isbn']).to eq("1234567890")
      expect(response_value['author']).to eq("Nobody Nowhere")
      expect(response_value['publisher']).to eq("Some Publisher")
      expect(response_value['published_date']).to eq("1989-12-12")
      expect(response_value['description']).to eq("something silly here")
      expect(response_value['page_count']).to eq(42)
      expect(response_value['cover_image_small']).to eq("http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE70qPSF352d2Qk9fy-GR6LGcmbIce8LeYon92LQ7ix5FGb5NA48KVbucB5m94MRzjNybMRyp_eSKld72lnad0MFlHwCZW_w19XwavFWoPKyuw8GXbaYZyIbyyCu18uu4HBpx3L_W&source=gbs_api")
      expect(response_value['cover_image_large']).to eq("http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&imgtk=AFLRE71_VpAYUr4vRw_Ftp6b1bS0mqXfI5guO6meGMZyNOlftsmxoMn5Zrb3eVjCAIhAzxdG_Dp3iwbGOR64seJrUDi5b2T1inCW7Oqt5eVs-1XehHlqLZbA-tBF16BjMZg2TTQyjSKw&source=gbs_api")
      expect(Book.last.title).to eq("TestBook")
    end
  end
end