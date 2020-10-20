module Admin
  class TimeRangesController < ApplicationController
    def index
      @time_ranges = TimeRange.order(updated_at: :asc).page(params[:page])
    end
  end
end
