# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a default user
User.create!(
  username: 'admin',
  password: 'password123'
)

puts 'Default user created'

# Create sample tasks
statuses = ['to_do', 'in_progress', 'done']

20.times do |i|
  Task.create!(
    title: "Task #{i + 1}",
    description: "This is a sample task description for task #{i + 1}",
    due_date: rand(1..30).days.from_now,
    status: statuses.sample
  )
end

puts '20 sample tasks created'

