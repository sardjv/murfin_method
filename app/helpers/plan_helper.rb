module PlanHelper
  def display_state(plan)
    plan.state.to_s.titleize
  end

  def state_badge_class(plan)
    "state-badge badge float-right #{state_badge_colour(plan)}"
  end

  def state_badge_colour(plan)
    case plan.state
    when :draft then 'bg-danger'
    when :submitted then 'bg-warning'
    when :complete then 'bg-success'
    end
  end
end
