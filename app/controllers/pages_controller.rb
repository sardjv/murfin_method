class PagesController < ApplicationController
  skip_after_action :verify_authorized
  skip_before_action :authenticate_user!

  def home
    redirect_to dashboard_path if user_authenticated?

    @presenter = HomepagePresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.to_json }
    end
  end

  def upgrade
    browser = Browser.new request.user_agent
    @browser_version = browser.try(:version).try(:present?) ? browser.version : '11 or lower'
  end
end
