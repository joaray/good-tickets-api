class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from StandardError, with: :render_standard_error_response
  rescue_from UncaughtThrowError, with: :render_uncaught_throw_error_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_standard_error_response(exception)
    render json: exception.message, status: :unprocessable_entity
  end

  def render_uncaught_throw_error_response
    render json: 'Transaction cannot be continued, aborting', status: :unprocessable_entity
  end
end
