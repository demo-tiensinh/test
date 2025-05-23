class HealthController < ApplicationController
  def index
    health_status = {
      status: 'ok',
      database: database_connected?,
      version: Rails.version,
      ruby_version: RUBY_VERSION,
      environment: Rails.env,
      timestamp: Time.current.iso8601
    }

    render json: health_status
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active? rescue false
  end
end

