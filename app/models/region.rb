class Region < ActiveRecord::Base
  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true
  has_many :activities
  
  attr_accessible :name, :code

  after_save :give_wordable

  def give_wordable
    word = Word.create(:word => self.code.downcase, :wordable_type => "region", :wordable_id => self.id, :counter => 0)
  end
end

# Region.all.each do |region|
#   word = Word.create(:word => region.code.downcase, :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#   puts "#{word.word}"
#   word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#   if region.name == "District of Columbia"
#     word = Word.create(:word => "dc", :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#     word = Word.create(:word => "d.c.", :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#   elsif region.name == "California"
#     word = Word.create(:word => "cali", :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#     word = Word.create(:word => "socal", :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#     word = Word.create(:word => "cal", :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#   else
#   end
#   region.name.downcase.split(' ').each do |word|
#     next if word == "of"
#     word = Word.create(:word => word, :wordable_type => "region", :wordable_id => region.id, :counter => 0)
#     puts "#{word.word}"
#     word ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
#   end
# end
