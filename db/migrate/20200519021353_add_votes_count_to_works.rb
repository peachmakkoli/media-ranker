class AddVotesCountToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :votes_count, :integer, default: 0
    add_index :works, :votes_count
  end
end
