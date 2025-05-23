class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  private

  def handle_standard_error(exception)
    Rails.logger.error("Unexpected error: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: { code: 500, message: 'Internal server error' }, status: :internal_server_error
  end

  def handle_not_found(exception)
    render json: { code: 404, message: exception.message }, status: :not_found
  end

  def handle_parameter_missing(exception)
    render json: { code: 400, message: exception.message }, status: :bad_request
  end

  def handle_record_invalid(exception)
    render json: { code: 400, message: exception.record.errors.full_messages.join(', ') }, status: :bad_request
  end
end

