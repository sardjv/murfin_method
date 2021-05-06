class UserCsvDecorator < BaseDecorator
  def user_group_names
    user_groups.pluck(:name).join(',')
  end
end
