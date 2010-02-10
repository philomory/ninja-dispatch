class CreateMissions < ActiveRecord::Migration
  def self.up
    create_table :missions do |t|
      t.string :state
      t.int :progress
      t.text :message
      t.belongs_to :ninja
      t.references :victim

      t.timestamps
    end
  end

  def self.down
    drop_table :missions
  end
end
