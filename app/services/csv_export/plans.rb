class CsvExport::Plans < BaseService
  include TimeRangeHelper # for duration_in_words
  BASE_COLUMNS = %i[first_name last_name job_plan_start_date job_plan_end_date job_plan_state job_plan_contracted_hours_per_week
                    job_plan_total_hours_per_week].freeze

  attr_accessor :plans

  def call # rubocop:disable Metrics/AbcSize
    CSV.generate do |csv|
      csv << prepare_headers

      plans.each do |plan|
        decorator = ApplicationController.helpers.decorate(plan, ::PlanCsvDecorator)

        plan.activities.each do |activity|
          row = BASE_COLUMNS.collect { |col| decorator.send(col) }

          activity.active_tag_associations.each do |tag_assoc|
            row << tag_assoc.tag.try(:name)
          end
          row << duration_in_words(activity.seconds_per_week / 60, :short)

          csv << row
        end
      end
    end
  end

  private

  def prepare_headers
    cols = BASE_COLUMNS.collect { |col| Plan.human_attribute_name(col) }
    if active_tag_types.any?
      cols += active_tag_types.collect(&:name)
      cols << Plan.human_attribute_name(:activity_time_worked_per_week)
    end
    cols
  end

  def active_tag_types
    TagType.active_for(Activity).sorted
  end
end
