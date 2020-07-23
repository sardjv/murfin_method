class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @presenter = HomepagePresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.to_json }
    end
  end
end
