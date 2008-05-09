class UserScore < ActiveRecord::Base
  belongs_to :user
  named_scope_for :user_id

  denormalizes :score, :from => :user
end
