FactoryBot.define do
  factory :user do
    name { "Новый пользователь (#{rand(777)})" }
    sequence(:email) { |n| "thing#{n}@example.com" }
    after(:build) { |u| u.password_confirmation = u.password = "123"}

    # sequence(:email) { |n| "user#{n}@example.com" }
    # password "password"
    # password_confirmation "password"
    # это мне ещё пригодится
  end
end
