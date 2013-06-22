require 'spec_helper'

describe Word do

  it { should validate_presence_of(:word) }
  it { should validate_uniqueness_of(:word) }

# Callbacks to be tested
 # before_save :default_values

end

__END__
  def default_values
    self.counter ||= 0
  end

  def has_a_category?
    self.wordable_type && self.wordable_type != "junk" && self.wordable_type != "to_check"
  end
