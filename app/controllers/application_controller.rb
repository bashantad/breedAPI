class ApplicationController < ActionController::API
  before_filter :log_request

  rescue_from Exception do |e|
    Rails.logger.error "Error occured: #{e.message}"
    case e
    when ActiveRecord::RecordNotFound
      render_404(e)
    else
      render_500(e)
    end
    #raise e if Rails.env.development?
  end

  protected

    def render_500(e)
      render_json({status: 500, error: e.message})
    end

    def render_404(e)
      render_json({status: 404, error: e.message})
    end

    def render_json(data)
      render json: data
    end

    def log_request
      Rails.logger.info "Started API request at #{request.url}"
    end

end
