module RenderPdf
  extend ActiveSupport::Concern

  included do
    layout(proc { |c| c.pdf? ? 'pdf' : 'application' })
    helper_method :pdf?
  end

  def pdf?
    (Rails.env.development? && params[:layout] == 'pdf') || request.env['Rack-Middleware-Grover'].as_boolean == true
  end

  def render_attachment(filename)
    response.headers['Content-Disposition'] = %(attachment; filename="#{filename}")
  end
end
