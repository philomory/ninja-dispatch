class SetDefaultProgressForMission < ActiveRecord::Migration
  def self.up
    change_column_default(:missions,:progress,0)
  end

  def self.down
    change_column_default(:missions,:progress,nil)
  end
end
