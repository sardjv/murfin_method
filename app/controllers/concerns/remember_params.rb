# frozen_string_literal: true

module RememberParams
  extend ActiveSupport::Concern

  PARAMS_TO_REMEMBER = [:filter_start_date, :filter_end_date, :filter_tag_ids, :time_scope, :graph_kind]

  included do
    helper_method :get_time_scope, :get_graph_kind
  end

  def get_time_scope
    cookies[:time_scope] ? cookies[:time_scope] : (params[:time_scope] || 'weekly')
  end

  def get_graph_kind
    cookies[:graph_kind] ? cookies[:graph_kind] : (params[:graph_kind] || 'percentage_delivered')
  end

  private

  def remember_params # rubocop:disable Metrics/AbcSize
    return if params[:query].blank? && params[:time_scope].blank?

    data = {}
    data.merge!(params[:query].permit!.to_h) unless params[:query].blank?
    data.merge!({ time_scope: params[:time_scope] }) unless params[:time_scope].blank?
    data.merge!({ graph_kind: params[:graph_kind] }) unless params[:graph_kind].blank?

    data = data.symbolize_keys.slice(*PARAMS_TO_REMEMBER)

    data.each_pair do |k, v|
      if v.blank?
        cookies.delete key
      elsif cookies[k] != v
        cookies[k] = v
      end
    end
  end
end
