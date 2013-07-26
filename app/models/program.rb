class Program < ActiveRecord::Base
  belongs_to :channel
  attr_accessible :name, :time
end
