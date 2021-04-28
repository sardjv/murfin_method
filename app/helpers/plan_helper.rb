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

  def plan_total_time_worked_per_week(plan)
    plan.activities.sum(&:seconds_per_week) / 60
  end

  def plan_sign_off_options(plan)
    user_group_ids = plan.user.memberships.pluck(:user_group_id)
    lead_ids = Membership.where(user_group_id: user_group_ids, role: 'lead').pluck(:user_id).uniq || []
    lead_ids_partial_query = lead_ids.any? ? "(id IN (#{lead_ids.join(',')}) IS TRUE) DESC," : ''

    User.order(Arel.sql("#{lead_ids_partial_query} last_name ASC, first_name ASC")).map { |t| [t.name, t.id] }
  end

  def plan_pdf_filename(plan)
    "job_plan_#{plan.user.name.downcase.gsub(/\s+/, '_')}.pdf"
  end
end
