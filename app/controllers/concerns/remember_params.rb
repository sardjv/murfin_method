# frozen_string_literal: true

module RememberParams
  extend ActiveSupport::Concern

  PARAMS_TO_REMEMBER = %i[filter_start_date filter_end_date filter_tag_ids time_scope graph_kind].freeze

  included do
    helper_method :graph_time_scope, :graph_kind
  end

  def graph_time_scope
    cookies[:time_scope] || (params[:time_scope] || 'weekly')
  end

  def graph_kind
    cookies[:graph_kind] || (params[:graph_kind] || 'percentage_delivered')
  end

  private

  def remember_params # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return unless params[:query].present? || params[:time_scope] || params[:graph_kind]

    data = {
      time_scope: params[:time_scope],
      graph_kind: params[:graph_kind]
    }

    if params[:query].present?
      query_params = params[:query].permit!.to_h
      data.merge!(query_params)
    end

    data = data.symbolize_keys.slice(*PARAMS_TO_REMEMBER)
    data = data.reject { |_k, v| v.blank? }

    data.each_pair do |k, v|
      if v.blank?
        cookies.delete key
      elsif cookies[k] != v
        cookies[k] = v
      end
    end
  end
end
