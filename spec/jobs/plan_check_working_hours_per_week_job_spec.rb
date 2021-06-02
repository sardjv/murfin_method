describe PlanCheckWorkingHoursPerWeekJob, type: :job do
  subject(:job) { PlanCheckWorkingHoursPerWeekJob.perform_later(*args) }
  let(:args) { { plan_id: plan.id } }

  let(:record_warning) { plan.record_warnings.unscoped.last }

  let(:working_hours_per_week) { 37.5 }
  let(:plan_start_date) { Date.current.beginning_of_year + 3.months } # 1st Apr
  let(:plan_end_date) { (plan_start_date + 1.year - 1.day) } # 31st Mar

  let(:user) { create :user }
  let!(:plan) { create :plan, user: user, start_date: plan_start_date, end_date: plan_end_date, working_hours_per_week: working_hours_per_week }

  let(:week1_start_date) { plan_start_date.beginning_of_week }
  let(:week2_start_date) { week1_start_date + 1.week }

  let!(:week1_activities) do
    working_hours = 4

    5.times do |d|
      start_time = week1.start + d.days + 10.hours

      create :time_range,
              user_id: user.id,
              time_range_type_id: TimeRangeType.actual_type.id,
              start_time: start_time,
              end_time: start_time + working_hours.hours,
              value: hours * 3600
      # 20h per week
    end
  end

  let!(:week1_activities) do
    working_hours = 12

    4.times do |d|
      start_time = week1.start + d.days + 8.hours

      create :time_range,
              user_id: user.id,
              time_range_type_id: TimeRangeType.actual_type.id,
              start_time: start_time,
              end_time: start_time + working_hours.hours,
              value: hours * 3600
    end # 48h per week
  end

  before { perform_enqueued_jobs { job } }

  it 'creates record warning assigned to the plan' do

    pp plan.record_warnings
    pp plan.time_ranges.count


  end
end
