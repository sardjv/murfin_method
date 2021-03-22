class TeamsController < ApplicationController
  include RememberParams

  before_action :find_user_group
  before_action :initialize_presenter, only: %i[dashboard individuals]
  after_action :remember_params, only: %i[dashboard individuals], format: :json

  def dashboard
    respond_to do |format|
      format.html
      format.json do
        dataset_labels = t("graphs.#{graph_kind}.dataset_labels.#{graph_time_scope}", default: nil)
        units = t("graphs.#{graph_kind}.units", default: '')

        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_data, units: units, dataset_labels: dataset_labels }],
          extras: %i[average_delivery_percent members_under_delivered_percent]
        )
      end
    end
  end

  def individuals; end

  def plans
    @plans = Plan.where(user_id: @user_group.users.pluck(:id)).order(updated_at: :desc).page(params[:page])
  end

  private

  def find_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def initialize_presenter
    @presenter = DashboardPresenter.new(params: team_params.merge(user_ids: @user_group.user_ids,
                                                                  time_scope: graph_time_scope,
                                                                  graph_kind: graph_kind),
                                        cookies: cookies)
  end

  def team_params
    params.permit(:id, :format, :page, :user_ids, :plan_id, :actual_id, :graph_kind, :time_scope, query: {})
  end
end
