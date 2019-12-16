FactoryBot.define do
   factory :user do
    sequence :email do |n|
       "dummyEmail#{n}@gmail.com" 
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :book do
    title { "TestBook" }
    subtitle { "Something witty here" }
    book_id { "-abc-123-" }
    isbn { "1234567890" }
    author { "Nobody Nowhere" }
    publisher { "Some Publisher" }
    published_date { "12/12/1989" }
    description { "something silly here" }
    page_count { "42" }
    cover_image_small { "http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE70qPSF352d2Qk9fy-GR6LGcmbIce8LeYon92LQ7ix5FGb5NA48KVbucB5m94MRzjNybMRyp_eSKld72lnad0MFlHwCZW_w19XwavFWoPKyuw8GXbaYZyIbyyCu18uu4HBpx3L_W&source=gbs_api" }
    cover_image_large { "http://books.google.com/books/content?id=-1mYDwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&imgtk=AFLRE71_VpAYUr4vRw_Ftp6b1bS0mqXfI5guO6meGMZyNOlftsmxoMn5Zrb3eVjCAIhAzxdG_Dp3iwbGOR64seJrUDi5b2T1inCW7Oqt5eVs-1XehHlqLZbA-tBF16BjMZg2TTQyjSKw&source=gbs_api" }
  end

  factory :library do
    title { "Testing Library" }
    librarytype { "Personal" }
    description { "a testing library" }
    location { "nowhere" }
    association :user
  end
end