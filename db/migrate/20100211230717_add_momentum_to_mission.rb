class AddMomentumToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :momentum, :integer, :default => 0
  end

  def self.down
    remove_column :missions, :momentum
  end
end
