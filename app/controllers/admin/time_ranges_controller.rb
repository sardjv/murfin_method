module Admin
  class TimeRangesController < ApplicationController
    def index
      @time_ranges = TimeRange.order(updated_at: :asc).page(params[:page])
    end

    def destroy
      @time_range = TimeRange.find(params[:id])
      @time_range.destroy
      redirect_to admin_time_ranges_path, notice: t('time_range.notice.successfully.destroyed')
    end
  end
end
