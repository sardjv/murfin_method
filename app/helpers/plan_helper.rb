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

  def state_json_response(plan)
    {
      state_badge: {
        text: display_state(plan),
        class: state_badge_class(plan)
      }
    }
  end

  def plan_pdf_filename(plan)
    "job_plan_#{plan.user.name.downcase.gsub(/\s+/, '_')}.pdf"
  end
end
