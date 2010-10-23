class Neuron < ActiveRecord::Base
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true
    
  validates_presence_of :name
  validates_uniqueness_of :name
  
	def self.search(search)
           if search
            find(:all, :conditions => ["name LIKE ? or content LIKE ? or labels LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%"], :order => 'LOWER(name) ASC')
           else
           	   find(:all, :order => 'LOWER(name) ASC')
           end
  end  

  def self.search_label(search)
           if search
            find(:all, :conditions => ["labels LIKE ?", "%#{search}%"], :order => 'LOWER(name) ASC')
           else
           	   find(:all, :order => 'LOWER(name) ASC')
           end
  end  
  
end
