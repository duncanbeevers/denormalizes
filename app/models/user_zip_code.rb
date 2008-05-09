class UserZipCode < ActiveRecord::Base
  belongs_to :user
  named_scope_for :user_id

  denormalizes :zip_code, :from => :user
end
