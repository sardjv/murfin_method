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
        tmp_filename = "plans_#{Date.current}_#{current_user.id}.csv"
        filename = "plans_#{Date.current}.csv"
        path = Rails.root.join('tmp', tmp_filename)
        begin
          file = File.open(path, 'r')
          csv = file.read
          send_data csv, filename: filename, type: 'text/csv', disposition: 'attachment'
        ensure
          # file.close unless file.closed?
          File.delete(file) if file && File.exist?(file)
        end
      end
    end
  end
end
