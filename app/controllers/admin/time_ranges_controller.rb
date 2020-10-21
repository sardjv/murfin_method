module Admin
  class TimeRangesController < ApplicationController
    def index
      @time_ranges = TimeRange.order(updated_at: :desc).page(params[:page])
    end

    def new
      @time_range = TimeRange.new
      render action: :edit
    end

    def create
      @time_range = TimeRange.new(time_range_params)
      if @time_range.save
        redirect_to admin_time_ranges_path, notice: t('time_range.notice.successfully.created')
      else
        flash.now.alert = t('time_range.notice.could_not_be.created')
        render :edit
      end
    end

    def edit
      @time_range = TimeRange.find(params[:id])
    end

    def update
      @time_range = TimeRange.find(params[:id])

      if @time_range.update(time_range_params)
        redirect_to admin_time_ranges_path, notice: t('time_range.notice.successfully.updated')
      else
        flash.now.alert = t('time_range.notice.could_not_be.updated')
        render :edit
      end
    end

    def destroy
      @time_range = TimeRange.find(params[:id])
      @time_range.destroy
      redirect_to admin_time_ranges_path, notice: t('time_range.notice.successfully.destroyed')
    end

    private

    def time_range_params
      params.require(:time_range).permit(
        :time_range_type_id,
        :start_time,
        :end_time,
        :value,
        :user_id
      )
    end
  end
end