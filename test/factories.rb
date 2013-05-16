FactoryGirl.define do
  factory :buzz_source do
    name Faker::Company.name
    uri Faker::Internet.http_url
    buzz_weight 1
    buzz_source_type "feed"

    factory :email_source do
      buzz_source_type "email"
    end

    factory :restaurant_list do
      buzz_source_type "restaurant_list"
    end

    factory :twitter_source do
      buzz_source_type "twitter"
    end

    factory :feed_source do
      buzz_source_type "feed"
    end
  end

  factory :buzz_post do
    post_date_time DateTime.now
    post_uri Faker::Internet.http_url
    post_content Faker::Lorem.paragraphs 
    scanned_flag false
    post_weight 1.0
    buzz_source
    post_guid Faker::Product.letters(25)
    post_title Faker::Lorem.sentence 
    city "nyc"
  end

  factory :buzz_mention do
    restaurant
    buzz_post
  end

  factory :restaurant do
    name Faker::Company.name
    twitter_handle "@"+Faker::Lorem.word
    city "nyc"
    skip_scan false
    description Faker::Lorem.sentences
  end

  factory :user do
end
