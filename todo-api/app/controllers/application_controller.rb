class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  private

  def handle_standard_error(e)
    Rails.logger.error("Unexpected error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render json: { code: 500, message: 'Internal server error' }, status: :internal_server_error
  end

  def handle_not_found(e)
    render json: { code: 404, message: e.message }, status: :not_found
  end

  def handle_parameter_missing(e)
    render json: { code: 400, message: e.message }, status: :bad_request
  end

  def handle_record_invalid(e)
    render json: { code: 400, message: e.record.errors.full_messages.join(', ') }, status: :bad_request
  end

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    unless token
      render json: { code: 401, message: 'Authentication token is missing' }, status: :unauthorized
      return
    end
    
    begin
      # In a real application, you would use a JWT gem to decode and verify the token
      # This is a simplified version for demonstration purposes
      payload = JSON.parse(Base64.decode64(token))
      @current_user = User.find(payload['user_id'])
    rescue StandardError => e
      render json: { code: 401, message: 'Invalid or expired token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
