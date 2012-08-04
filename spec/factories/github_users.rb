FactoryGirl.define do
  factory :github_user do |f|
    f.uid { rand(0...90000).to_s }
    f.email { Faker::Internet.email }
    f.login { Faker::Lorem.words(1)[0].to_s }
  end
end
