module PlanHelper
  def display_state(plan)
    plan.state.to_s.titleize
  end

  def state_badge_class(plan)
    "state-badge badge float-right #{state_badge_colour(plan)}"
  end

  def state_badge_colour(plan)
    {
      draft: 'bg-danger',
      submitted: 'bg-warning',
      complete: 'bg-success'
    }[plan.state]
  end
end
