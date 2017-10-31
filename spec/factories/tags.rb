FactoryGirl.define do
  factory :tag do
    sequence :title do |n|
      "low shedding #{n}"
    end
    created_at Time.now
  end
end
