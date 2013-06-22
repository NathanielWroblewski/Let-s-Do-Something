require 'spec_helper'

describe Activity do
  let (:activity) { create(:activity) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:times_visited) }
  it { should validate_presence_of(:dup_status) }
  it { should belong_to(:category) }
  it { should belong_to(:country) }
  it { should belong_to(:region) }

  # Callbacks to be tested
  # before_create :slug_it
  # before_save :valid_phone
  # before_save :eliminate_ampersands
  # before_save :remove_backspaces
  # before_save :serialize_title_and_description

  context "Model Method tests" do
    before do
      activity
    end

  end
end

__END__

# TO BE TESTED
# def serialize_title_and_description
#     return if self.title.is_a?(Array) || self.description.is_a?(Array)
#     self.title_words = self.title.downcase if self.title
#     self.description_words = self.description.downcase if self.description
#   end

#   def remove_backspaces
#     return if self.title.is_a?(Array) || self.description.is_a?(Array)
#     return if self.title.nil?
#     self.title.gsub!("&nbsp;", " ")
#     return if self.description.nil?
#     self.description.gsub!("&nbsp;", " ")
#   end

#   def eliminate_ampersands
#     return if self.title.is_a?(Array) || self.description.is_a?(Array)
#     return if self.title.nil?
#     self.title.gsub!("&amp;", "&")
#     return if self.description.nil?
#     self.description.gsub!("&amp; ", "")
#   end

#   def upcoming?
#     self.starts_at >= now
#   end

#   def duration_formated
#     if self.duration.nil? || self.duration == 0
#       return nil
#     else
#       minutes = ((self.duration.to_f - self.duration.to_i.to_f) * 60).to_i.to_s
#       time = self.duration.to_i.to_s + " h" + ( minutes == "0" ? "" : (minutes + " min"))
#       duration_of_activity(time)
#     end
#   end

#   def location_formated
#     (self.street ? self.street : "") + (self.city ? (", " + self.city) : "") + (self.region ? (", " + self.region.name) : "") + (self.zip ? (", " + self.zip.to_s) : "")
#   end

#   def location_formated_short
#     (self.city ? self.city : "") + (self.region ? (", " + self.region.code.upcase) : "") 
#   end

#     describe "cat" do
      it "should return the category name" do
        expect { activity.cat }.to eq(activity.category.name)
      end
    end

# def display_price
#   case 
#   when self.min_price && self.max_price && self.min_price != self.max_price
#     "between $#{min_price.to_i} and $#{max_price.to_i}"
#   when self.min_price && self.max_price || self.min_price
#     " $#{min_price.to_i}"
#   when self.max_price
#     " $#{min_price.to_i}"
#   else
#     nil
#   end
# end

# def duration_of_activity(time)
#   days = self.duration.to_i / 24
#   case 
#   when days > 13
#     "#{days / 7} weeks"
#   when days > 6 
#     "#{days / 7} week, #{days % 7} day" + (days % 7 > 1 ? "s" : "")
#   when days > 1 
#     "#{days % 7} days, #{self.duration.to_i % 24} hour" + (self.duration.to_i / 24 > 1 ? "s" : "")
#   else
#     time
#   end
# end

# def beginning_date_formated
#   self.starts_at.strftime(" %A,%B %-d %Y, at %l:%M %P") if self.starts_at
# end

# def beginning_time_formated
#   self.starts_at.strftime(" at %l:%M %P") if self.starts_at
# end

# def to_param
#   "#{id}/#{url_slug}"
# end



