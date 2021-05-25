class UserCsvDecorator < BaseDecorator
  def user_group_names
    user_groups.pluck(:name).sort.join(',')
  end
end
