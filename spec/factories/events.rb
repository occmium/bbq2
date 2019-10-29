FactoryBot.define do
  factory :event do
    association :user
    title { 'Событие' }
    description { 'Домашка' }
    address { 'На полу в Ленинграде' }
    datetime { DateTime.parse('29.10.2019 00:00') }
  end
end
