class PlanCsvDecorator < BaseDecorator
  include PlanHelper
  include TimeRangeHelper

  delegate :first_name, :last_name, to: :user
  alias_attribute :job_plan_start_date, :start_date
  alias_attribute :job_plan_end_date, :end_date

  def job_plan_total_hours_per_week
    duration_in_words(plan_total_time_worked_per_week(self), :short)
  end

  def job_plan_state
    display_state(self)
  end
end
