# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text
#  due_date    :datetime         not null
#  status      :string           default("to_do"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  # Constants
  STATUSES = ['to_do', 'in_progress', 'done'].freeze

  # Validations
  validates :title, presence: true
  validates :due_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  # Scopes
  scope :by_status, ->(status) { where(status: status) }
  scope :sorted_by_due_date_asc, -> { order(due_date: :asc) }
  scope :sorted_by_due_date_desc, -> { order(due_date: :desc) }

  # Class methods
  def self.sort_by_field(sort_param)
    case sort_param
    when 'due_date_asc'
      sorted_by_due_date_asc
    when 'due_date_desc'
      sorted_by_due_date_desc
    else
      all
    end
  end
end
