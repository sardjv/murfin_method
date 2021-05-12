class Admin::TimeRangesController < ApplicationController
  before_action :find_and_authorize_time_range, only: %i[edit update destroy]

  def index
    authorize :time_range

    @q = TimeRange.order('time_ranges.user_id', start_time: :asc).ransack(params[:q])
    @time_ranges = @q.result(distinct: true).includes(:user, :tags).page(params[:page])
  end

  def new
    @time_range = TimeRange.new
    authorize @time_range
    render action: :edit
  end

  def create
    @time_range = TimeRange.new(time_range_params)
    authorize @time_range
    if @time_range.save
      redirect_to admin_time_ranges_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @time_range.update(time_range_params)
      redirect_to admin_time_ranges_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_range.destroy
    redirect_to admin_time_ranges_path, notice: notice('successfully.destroyed')
  end

  private

  def find_and_authorize_time_range
    @time_range = TimeRange.find(params[:id])
    authorize @time_range
  end

  def notice(action)
    t("notice.#{action}", model_name: TimeRange.model_name.human)
  end

  def time_range_params
    params.require(:time_range).permit(
      :appointment_id,
      :time_range_type_id,
      :start_time,
      :end_time,
      :seconds_worked,
      :user_id,
      tag_associations_attributes: %i[id tag_type_id tag_id _destroy]
    )
  end
end
