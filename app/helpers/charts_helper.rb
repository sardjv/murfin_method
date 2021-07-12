# frozen_string_literal: true

module ChartsHelper
  BAR_CHART_BAR_THICKNESS = 10
  BAR_CHART_BAR_MARGINS = 14
  BAR_CHART_CONTAINER_DEFAULT_HEIGHT = 400

  def bar_chart_scroll_container_height_css(users_count)
    return 'height: auto' if users_count.try(:zero?)
    return "height: #{BAR_CHART_CONTAINER_DEFAULT_HEIGHT}px !important" if users_count > 15

    "height: #{((BAR_CHART_BAR_THICKNESS + BAR_CHART_BAR_MARGINS) * users_count) + 20}px !important"
  end

  def bar_chart_container_height_css(users_count)
    return 'height: auto' if users_count.try(:zero?)

    "height: #{(BAR_CHART_BAR_THICKNESS + BAR_CHART_BAR_MARGINS) * users_count}px !important"
  end
end
