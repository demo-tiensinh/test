# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing tasks
puts "Clearing existing tasks..."
Task.destroy_all

# Create sample tasks
puts "Creating sample tasks..."

# High priority tasks
Task.create!(
  title: "Complete project proposal",
  description: "Finalize the project proposal document and send it to the client",
  due_date: 2.days.from_now,
  priority: 1,
  status: "incomplete"
)

Task.create!(
  title: "Fix critical bug in authentication",
  description: "Users are unable to log in due to a token validation issue",
  due_date: 1.day.from_now,
  priority: 1,
  status: "incomplete"
)

# Medium priority tasks
Task.create!(
  title: "Update documentation",
  description: "Update the API documentation with the new endpoints",
  due_date: 5.days.from_now,
  priority: 2,
  status: "incomplete"
)

Task.create!(
  title: "Refactor user service",
  description: "Improve code quality and performance of the user service",
  due_date: 7.days.from_now,
  priority: 2,
  status: "incomplete"
)

# Low priority tasks
Task.create!(
  title: "Research new technologies",
  description: "Research new technologies for the upcoming project",
  due_date: 14.days.from_now,
  priority: 3,
  status: "incomplete"
)

# Completed tasks
Task.create!(
  title: "Set up development environment",
  description: "Install and configure all necessary tools and dependencies",
  due_date: 1.day.ago,
  priority: 1,
  status: "complete"
)

Task.create!(
  title: "Initial project setup",
  description: "Create the repository and set up the basic project structure",
  due_date: 2.days.ago,
  priority: 2,
  status: "complete"
)

puts "Created #{Task.count} tasks"

