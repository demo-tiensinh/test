FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Time.forward(days: 7) }
    priority { [1, 2, 3].sample }
    status { ['incomplete', 'complete'].sample }

    trait :high_priority do
      priority { 1 }
    end

    trait :medium_priority do
      priority { 2 }
    end

    trait :low_priority do
      priority { 3 }
    end

    trait :incomplete do
      status { 'incomplete' }
    end

    trait :complete do
      status { 'complete' }
    end

    trait :due_soon do
      due_date { 1.day.from_now }
    end

    trait :due_later do
      due_date { 14.days.from_now }
    end
  end
end

