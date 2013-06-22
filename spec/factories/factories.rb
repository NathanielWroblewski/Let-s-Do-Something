require 'faker'

FactoryGirl.define do

  sequence :name do |n|
    "my name#{n}"
  end

  factory :activity do
    sequence(:extern_id) { |n| "#{n+245525}" }        
    sequence(:title)     { |n| "title #{n}" }
    description          { Faker::Lorem.sentences(sentence_count = 3) }
    phone                ""
    creator              ""
    lat                  Random.rand(1000)
    long                 Random.rand(1000)
    starts_at            { Time.now - 25_200 }
    ends_at              { (self.starts_at + 3600) }
    duration             1
    venue_name           "my venue"
    street               "my street"
    city                 "my city"
    zip                  90543
    recurrence           2
    url                  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQ0ELM6FBTBQUVE25oB8PxV3OldccBGFftF0V2B2HCtQw7uATo2"
    image_url            "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQ0ELM6FBTBQUVE25oB8PxV3OldccBGFftF0V2B2HCtQw7uATo2"
    times_visited        0
    min_price            nil
    max_price            nil
    association          :category
    country_id           1
    region
  end

  factory :category do
    name
    video_url   ""
    image_url   ""
    description { Faker::Lorem.sentences(sentence_count = 3) }
  end

  factory :country do
    name
    sequence(:code) {|n| "a#{n}"} 
  end


  factory :region do
    sequence(:name) {|n| "name#{n}"}
    sequence(:code) {|n| "a#{n}"} 
  end


end
