FactoryGirl.define do
  factory :breed do
    sequence :name do |n|
      "Norwegian Forest Cat#{n}"
    end
    created_at Time.now
  end
end
