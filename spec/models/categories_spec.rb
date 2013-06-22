require 'spec_helper'

describe Category do
  
  it { should validate_presence_of(:name) }
  it { should have_many(:activities) }

# Callbacks to be tested
 #  before_save :give_wordable
 #  before_create :slug_it


end


__END__
def to_param
    "#{id}/#{url_slug}"
  end


  def give_wordable
    word = Word.create(:word => self.name.downcase, :wordable_type => "category", :wordable_id => self.id, :counter => 0)
  end
  
  def self.all_sorted
    Category.order(:name).all
  end
