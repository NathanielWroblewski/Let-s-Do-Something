class Word < ActiveRecord::Base
  validates_uniqueness_of :word, :scope => [:wordable_type, :wordable_id]

  validates :word, :presence => true
  validates :wordable_type, :inclusion => {:in => ["country", "category", "region", "junk", "city", "content", "to_check"]}
  
  attr_accessible :word, :wordable_type, :wordable_id, :interpretation, :counter


  before_save :default_values

  def default_values
    self.counter ||= 0
  end

  def has_a_category?
    self.wordable_type && self.wordable_type != "junk" && self.wordable_type != "to_check"
  end
end

