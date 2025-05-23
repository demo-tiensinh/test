class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date, :status, :created_at, :updated_at

  # Format the due_date as ISO8601 for API consistency
  def due_date
    object.due_date.iso8601 if object.due_date
  end

  # Format the created_at as ISO8601 for API consistency
  def created_at
    object.created_at.iso8601 if object.created_at
  end

  # Format the updated_at as ISO8601 for API consistency
  def updated_at
    object.updated_at.iso8601 if object.updated_at
  end
end
