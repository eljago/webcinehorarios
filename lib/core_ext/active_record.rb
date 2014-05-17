class ActiveRecord::Base
  
  def self.attributes_to_ignore_when_comparing
    [:id, :created_at, :updated_at]
  end

  def identical?(other)
    self. attributes.except(*self.class.attributes_to_ignore_when_comparing.map(&:to_s)) ==
    other.attributes.except(*self.class.attributes_to_ignore_when_comparing.map(&:to_s))
  end
    
end