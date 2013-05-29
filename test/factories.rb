FactoryGirl.define do
  sequence(:name) {|n| "some_restaurant_name#{n}"}

  factory :buzz_source do
    name Faker::Company.name
    uri Faker::Internet.http_url
    buzz_weight 1
    buzz_source_type "feed"
    decay_factor 0.906

    factory :email_source do
      buzz_source_type "email"
    end

    factory :restaurant_list do
      buzz_source_type "restaurant_list"
      name "Tasting Table NY"
      uri "http://nymag.com/srch?t=restaurant&N=265+334&No=0&Ns=nyml_sort_name"
      x_path_nodes "//dl[@class=\"result\"]/dt/a"
      city "nyc"
    end

    factory :twitter_source do
      buzz_source_type "twitter"
      uri "@codee"
    end

    factory :feed_source do
      buzz_source_type "feed"
      name "Eater NY"
      uri "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "fixtures", "eater_rss.rss"))}"
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
    buzz_score 2
    decayed_buzz_score 2
  end

  factory :buzz_score do
    restaurant
  end
  
  factory :buzz_mention_highlight do
    buzz_mention
    buzz_mention_highlight_text Faker::Lorem.sentences
  end

  factory :restaurant do
    name 
    twitter_handle "@"+Faker::Lorem.word
    city "nyc"
    skip_scan false
    description Faker::Lorem.sentences
  end

  factory :user do
    email Faker::Internet.email
    password Faker::Lorem.word
    password_confirmation { |u| u.password }

    factory :admin do
      role "admin"
    end
  end

 
end

