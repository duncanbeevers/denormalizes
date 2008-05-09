class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.integer :score, :allow_nil => false, :default => 0
      t.integer :zip_code
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
