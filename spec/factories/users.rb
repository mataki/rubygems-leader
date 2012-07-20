FactoryGirl.define do
  factory :user do |f|
    f.handle { Faker::Lorem.words(1).to_s }
    f.email { Faker::Internet.email }
    f.profile_id { rand(0..100) }
    f.rank { rand(0...100000) }
    f.total_downloads { rand(0...100000000) }
  end
end
