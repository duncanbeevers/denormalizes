class CreateUserScores < ActiveRecord::Migration
  def self.up
    create_table :user_scores do |t|
      t.integer :user_id
      t.integer :score, :allow_nils => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :user_scores
  end
end
