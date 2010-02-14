class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.belongs_to :mission
      t.integer :index
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :challenges
  end
end
