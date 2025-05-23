# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text
#  due_date    :datetime         not null
#  priority    :integer          not null
#  status      :string           default("incomplete"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  # Constants
  PRIORITIES = [1, 2, 3].freeze
  STATUSES = ['incomplete', 'complete'].freeze

  # Validations
  validates :title, presence: true
  validates :due_date, presence: true
  validates :priority, presence: true, inclusion: { in: PRIORITIES }
  validates :status, presence: true, inclusion: { in: STATUSES }

  # Scopes
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :sorted_by_due_date_asc, -> { order(due_date: :asc) }
  scope :sorted_by_due_date_desc, -> { order(due_date: :desc) }
  scope :sorted_by_priority_asc, -> { order(priority: :asc) }
  scope :sorted_by_priority_desc, -> { order(priority: :desc) }

  # Class methods
  def self.sort_by_field(field, direction)
    case field
    when 'dueDate'
      direction == 'asc' ? sorted_by_due_date_asc : sorted_by_due_date_desc
    when 'priority'
      direction == 'asc' ? sorted_by_priority_asc : sorted_by_priority_desc
    else
      all
    end
  end
end

