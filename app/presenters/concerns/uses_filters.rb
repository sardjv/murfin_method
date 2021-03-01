# Adds getters for start/end time and tag ids
# plus helper methods for prepare query params and defaults

module UsesFilters
  extend ActiveSupport::Concern

  def filter_start_time
    filter_start_date.in_time_zone.beginning_of_day
  end

  def filter_end_time
    filter_end_date.in_time_zone.beginning_of_day
  end

  def filter_start_date
    return unless @params[:filter_start_year] && @params[:filter_start_month]

    Date.new(@params[:filter_start_year].to_i, @params[:filter_start_month].to_i)
  end

  def filter_end_date
    return unless @params[:filter_end_year] && @params[:filter_end_month]

    Date.new(@params[:filter_end_year].to_i, @params[:filter_end_month].to_i)
  end

  def filter_tag_ids
    return [] if @params[:filter_tag_ids].blank?

    @params[:filter_tag_ids].is_a?(String) ? @params[:filter_tag_ids]&.split(',') : @params[:filter_tag_ids]
  end

  def prepare_query_params(query) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return {} if query.blank?

    query_params = {
      filter_start_month: query['filter_start_month'] || query['filter_start_time(2i)'],
      filter_start_year: query['filter_start_year'] || query['filter_start_time(1i)'],
      filter_end_month: query['filter_end_month'] || query['filter_end_time(2i)'],
      filter_end_year: query['filter_end_year'] || query['filter_end_time(1i)']
    }.update { |_k, v| v.to_i }

    query_params[:filter_tag_ids] = query['filter_tag_ids'].reject(&:empty?).map(&:to_i) if query['filter_tag_ids'].present?

    query_params.compact
  end

  private

  def filters_defaults
    {
      filter_start_year: 1.year.ago.year,
      filter_start_month: 1.year.ago.month,
      filter_end_year: Time.zone.today.year,
      filter_end_month: Time.zone.today.month,
      filter_tag_ids: Tag.where(default_for_filter: true).pluck(:id)
    }
  end
end
