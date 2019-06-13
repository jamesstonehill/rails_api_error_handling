require "rails_api_error_handling/version"

module RailsApiErrorHandling
  DEFAULT_ERROR_STATUS_MAPPINGS = {
    'ActiveRecord::RecordNotFound' => :not_found
  }.freeze

  def handle_api_errors(format:, additional_status_mappings: {}, report_error: nil)
    @format = format
    @status_mappings = DEFAULT_ERROR_STATUS_MAPPINGS.merge(additional_status_mappings)
    @report_error = report_error

    self.class.rescue_from(StandardError, with: :handle_error)
  end

  private

  FORMATS_TO_RENDER_FORMATS = {
    json_api: :json
  }

  def handle_error(error)
    error_id = SecureRandom.uuid
    @report_error.call(error, error_id)

    status = @status_mappings[error.class.to_s]
    # serializer = 

    render(FORMATS_TO_RENDER_FORMATS[@format] || @format, status: status)
  end
end
