class Neuron < ActiveRecord::Base
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true
    
  validates_presence_of :name
  validates_uniqueness_of :name
end
