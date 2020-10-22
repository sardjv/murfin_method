class AddTeamStatsIndexToTimeRanges < ActiveRecord::Migration[6.0]
  def change
    add_index :time_ranges,
              [:time_range_type_id, :user_id, :start_time, :end_time, :value],
              name: 'index_time_range_team_stats'
  end
end
