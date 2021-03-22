# Adds getters for start/end time and tag ids
# plus helper methods for prepare query params and defaults

module UsesFilters
  extend ActiveSupport::Concern

  included do
    attr_reader :query_params, :cookies
  end

  def filter_start_time
    filter_start_date.in_time_zone.beginning_of_day
  end

  def filter_end_time
    filter_end_date.in_time_zone.end_of_day
  end

  def filter_start_date
    return unless @params[:filter_start_date]

    Date.parse(@params[:filter_start_date])
  end

  def filter_end_date
    return unless @params[:filter_end_date]

    Date.parse(@params[:filter_end_date])
  end

  def filter_tag_ids
    return [] if @params[:filter_tag_ids].blank?

    if @params[:filter_tag_ids].is_a?(String)
      @params[:filter_tag_ids]&.split('&')
    else
      @params[:filter_tag_ids]
    end
  end

  def prepare_query_params(query) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    return {} if query.blank?

    if query['filter_start_date'].present? && query['filter_end_date'].present?
      query_params = {
        filter_start_date: Date.parse(query['filter_start_date']).to_s(:db),
        filter_end_date: Date.parse(query['filter_end_date']).to_s(:db)
      }
    end

    query_params ||= {}
    query_params[:filter_tag_ids] = query['filter_tag_ids'].reject(&:empty?).map(&:to_i) if query['filter_tag_ids'].present?

    query_params.compact
  end

  private

  def filters_defaults # rubocop:disable Metrics/AbcSize
    default_start_date = 11.months.ago.beginning_of_month.to_date
    default_end_date = Date.current.end_of_month
    default_tag_ids = Tag.where(default_for_filter: true).pluck(:id)

    {
      filter_start_date: cookies.try(:[], :filter_start_date) || default_start_date.to_s(:db),
      filter_end_date: cookies.try(:[], :filter_end_date) || default_end_date.to_s(:db),
      filter_tag_ids: cookies.try(:[], :filter_tag_ids) || default_tag_ids,
      actual_id: TimeRangeType.actual_type.id
    }
  end
end
