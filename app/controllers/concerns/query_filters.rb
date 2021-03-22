# frozen_string_literal: true

module QueryFilters
  extend ActiveSupport::Concern

  FILTERS_TO_REMEMBER = %i[filter_start_date filter_end_date filter_tag_ids].freeze

  def remember_query_filters # rubocop:disable Metrics/AbcSize
    return if params[:query].blank?

    FILTERS_TO_REMEMBER.each do |key|
      if params[:query][key].blank?
        cookies.delete key
      elsif cookies[key] != params[:query][key]
        cookies[key] = params[:query][key]
      end
    end
  end
end
