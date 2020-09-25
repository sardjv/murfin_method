class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    redirect_to user_dashboard_path if user_authenticated?

    @presenter = HomepagePresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.to_json }
    end
  end
end
