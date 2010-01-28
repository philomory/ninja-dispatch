class CreateNinjas < ActiveRecord::Migration
  def self.up
    create_table :ninjas do |t|
      t.string :name
      t.boolean :active
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :ninjas
  end
end
