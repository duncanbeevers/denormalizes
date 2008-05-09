class CreateUserZipCodes < ActiveRecord::Migration
  def self.up
    create_table :user_zip_codes do |t|
      t.integer :user_id
      t.integer :zip_code
      t.timestamps
    end
  end

  def self.down
    drop_table :user_zip_codes
  end
end
