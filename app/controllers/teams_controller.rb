class TeamsController < ApplicationController
  def dashboard
    @user_group = UserGroup.find(params[:id])
    @presenter = DashboardPresenter.new(params: team_params.merge(user_ids: @user_group.user_ids))

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :line_graph, data: :team_data, units: '%' }])
      end
    end
  end

  def individuals
    @user_group = UserGroup.find(params[:id])
    @presenter = DashboardPresenter.new(params: team_params.merge(user_ids: @user_group.user_ids))

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :bar_chart, data: :individual_data, units: '%' }])
      end
    end
  end

  def plans
    @user_group = UserGroup.find(params[:id])
    @plans = Plan.where(user_id: @user_group.users.pluck(:id)).order(updated_at: :desc).page(params[:page])
  end

  private

  def team_params
    params.permit(:id, :format, :page, :user_ids, :plan_id, :actual_id,
                  :filter_start_month, :filter_end_month, :filter_start_year,
                  :filter_end_year, :filter_tag_ids)
  end
end
