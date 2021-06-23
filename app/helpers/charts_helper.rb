# frozen_string_literal: true

module ChartsHelper
  BAR_CHART_BAR_THICKNESS = 10.freeze
  BAR_CHART_BAR_MARGINS = 14.freeze

  def bar_chart_container_height_css(users_count)
    return 'height: auto' if users_count.try(:zero?)

    "height: #{(BAR_CHART_BAR_THICKNESS + BAR_CHART_BAR_MARGINS) * users_count}px !important"
  end
end