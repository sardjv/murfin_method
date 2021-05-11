class TeamsController < ApplicationController
  include RememberParams

  before_action :find_and_authorize_user_group, only: %i[dashboard individuals plans]
  before_action :initialize_presenter, only: %i[dashboard individuals plans]
  after_action :remember_params, only: %i[dashboard individuals], format: :json

  def dashboard
    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_data }]
        )
      end
    end
  end

  def individuals; end

  def plans
    @plans = Plan.where(user_id: @user_group.users.pluck(:id)).order(updated_at: :desc).page(params[:page])
  end

  private

  def find_and_authorize_user_group
    @user_group = UserGroup.find(params[:id])
    authorize @user_group
  end

  def initialize_presenter
    @presenter = TeamDashboardPresenter.new(params: team_params.merge(user_ids: @user_group.user_ids,
                                                                      time_scope: graph_time_scope,
                                                                      graph_kind: graph_kind),
                                            cookies: cookies)
  end

  def team_params
    params.permit(:id, :format, :page, :user_ids, :plan_id, :actual_id, :graph_kind, :time_scope, query: {})
  end
end
