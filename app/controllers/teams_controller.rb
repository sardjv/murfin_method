class TeamsController < ApplicationController
  before_action :find_user_group
  before_action :initialize_presenter, only: %i[dashboard individuals]

  def dashboard
    respond_to do |format|
      format.html
      format.json do
        dataset_labels = t("graphs.#{params[:graph_kind]}.dataset_labels", default: nil)
        units = t("graphs.#{params[:graph_kind]}.units", default: '')

        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_data, units: units, dataset_labels: dataset_labels }],
          extras: %i[average_delivery_percent members_under_delivered_percent]
        )
      end
    end
  end

  def individuals
    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :bar_chart, data: :individual_data, units: '%' }])
      end
    end
  end

  def plans
    @plans = Plan.where(user_id: @user_group.users.pluck(:id)).order(updated_at: :desc).page(params[:page])
  end

  private

  def find_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def initialize_presenter
    @presenter = DashboardPresenter.new(params: team_params.merge(user_ids: @user_group.user_ids, time_scope: params[:time_scope]))
  end

  def team_params
    params.permit(:id, :format, :page, :user_ids, :plan_id, :actual_id,
                  :filter_start_month, :filter_end_month, :filter_start_year, :filter_end_year, :filter_tag_ids,
                  :graph_kind, :time_scope)
  end
end
