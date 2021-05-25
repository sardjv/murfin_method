class Admin::PlansController < ApplicationController
  def index # rubocop:disable Metrics/AbcSize
    authorize :plan

    respond_to do |format|
      format.html do
        @q = Plan.order(updated_at: :desc).ransack(params[:q])
        @plans = @q.result(distinct: true).includes(:user, activities: :tags).page(params[:page])
      end
      format.csv do # debug only
        send_data CsvExport::Plans.call(plans: Plan.order(updated_at: :desc)), filename: "plans_#{Date.current}.csv"
      end
    end
  end

  def generate_csv
    authorize :user, :download?

    FlashMessageBroadcastJob.perform_now(
      current_user_id: current_user.id,
      message: t('download.queued', records_type: 'plans', file_type: 'CSV'),
      extra_data: { message_type: 'download' }
    )

    GeneratePlansCsvJob.perform_later(current_user_id: current_user.id)

    head :no_content
  end

  def download
    authorize :user

    respond_to do |format|
      format.csv do
        redis_key = "plans_#{Date.current}_#{current_user.id}.csv"
        csv_data = REDIS_CLIENT.get(redis_key)

        if csv_data
          csv_filename = "plans_#{Date.current}.csv"
          send_data csv_data, filename: csv_filename, type: 'text/csv', disposition: 'attachment'

          REDIS_CLIENT.del(redis_key)
        else
          FlashMessageBroadcastJob.perform_now(
            current_user_id: current_user.id,
            message: I18n.t('download.errors.not_found', records_type: 'plans', file_type: 'CSV'),
            alert_type: 'danger',
            extra_data: { message_type: 'download' }
          )
        end
      end
    end
  end
end
