class ActiveRecord::Base
  def self.named_scope_for attribute
    named_scope "for_#{attribute}",
      lambda { |attribute_value| { :conditions => { attribute => attribute_value } } }
  end

  def self.named_scope_by attribute, desc = nil
    named_scope "by_#{attribute}", :order => "#{attribute}#{ desc ? ' DESC' : '' }"
  end
end
