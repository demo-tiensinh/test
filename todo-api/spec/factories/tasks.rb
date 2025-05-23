FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Time.forward(days: 7) }
    status { ['to_do', 'in_progress', 'done'].sample }

    trait :to_do do
      status { 'to_do' }
    end

    trait :in_progress do
      status { 'in_progress' }
    end

    trait :done do
      status { 'done' }
    end

    trait :due_soon do
      due_date { 1.day.from_now }
    end

    trait :due_later do
      due_date { 14.days.from_now }
    end
  end
end
