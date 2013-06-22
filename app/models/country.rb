class Country < ActiveRecord::Base

  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true
  has_many :activities
  
  after_save :give_wordable

  attr_accessible :name, :code

  def give_wordable
    word = Word.create(:word => self.code.downcase, :wordable_type => "country", :wordable_id => self.id, :counter => 0)
  end
end
