FactoryGirl.define do
  factory :claim_identity_key do |f|
    f.key { rand(1000..000000) }
  end
end
