FactoryBot.define do
  factory :user do
    name { "Новый пользователь (#{rand(777)})" }
    sequence(:email) { |n| "thing#{n}@example.com" }
    after(:build) { |u| u.password_confirmation = u.password = "123"}
  end
end
