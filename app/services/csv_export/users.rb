class CsvExport::Users < BaseService
  COLUMNS = %i[first_name last_name email epr_uuid admin user_group_names].freeze

  attr_accessor :users

  def call
    CSV.generate do |csv|
      csv << headers
      users.each do |user|
        decorator = ApplicationController.helpers.decorate(user, ::UserCsvDecorator)
        csv << COLUMNS.collect { |col| decorator.send(col) }
      end
    end
  end

  private

  def headers
    COLUMNS.collect { |col| User.human_attribute_name(col) }
  end
end
