class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date, :priority, :status

  # Format the due_date as ISO8601 for API consistency
  def due_date
    object.due_date.iso8601 if object.due_date
  end

  # Convert id to string to match the Swagger spec
  def id
    object.id.to_s
  end
end

