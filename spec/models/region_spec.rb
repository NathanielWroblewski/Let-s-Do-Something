require 'spec_helper'

describe Region do

  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:name) }
  it { should have_many(:activities) }


# Callbacks to be tested
 # before_save :give_wordable

end

__END__
  def give_wordable
    word = Word.create(:word => self.code.downcase, :wordable_type => "region", :wordable_id => self.id, :counter => 0)
  end
