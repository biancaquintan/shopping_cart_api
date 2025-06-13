# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found(exception)
    message = exception.respond_to?(:message) ? exception.message : exception.to_s
    render json: { error: message }, status: :not_found
  end
end
