class PagesController < ApplicationController
  def home
    @presenter = HomepagePresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.to_json }
    end
  end
end
