class AddProgressToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :progress, :integer
  end

  def self.down
    remove_column :missions, :progress
  end
end
