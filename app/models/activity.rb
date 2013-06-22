# encoding: utf-8
require 'slug_mapping'

class Activity < ActiveRecord::Base

  validates :title, :presence => true
  validates :times_visited, :presence => true
  validates :dup_status, :presence => true
  # validates :phone, :format => { :with => /\d{3}-\d{3}-\d{4}( ext| x)\d*(?=\b)/,
  #   :message => "Please use a phone number of the format '123-456-7890' with an optional extension of the format ' ext1234567890' or ' x1234567890'" }
  # validates :city, :presence => true

  belongs_to :category
  belongs_to :country
  belongs_to :region

  before_create :slug_it

  before_save :valid_phone
  before_save :eliminate_ampersands
  before_save :remove_backspaces
  before_save :serialize_title_and_description
  before_save :remove_apostrophes
  
  attr_accessible :category_id,
  :user_id,
  :extern_id,
  :title,
  :description,
  :phone,
  :creator,
  :lat,
  :long,
  :starts_at,
  :ends_at,
  :duration,
  :venue_name,
  :street,
  :city,
  :region_id, 
  :zip,
  :country_id,
  :recurrence,
  :url,
  :image_url,
  :times_visited,
  :dup_status,
  :min_price,
  :max_price,
  :url_slug,
  :title_words,
  :description_words

  def remove_apostrophes
    return if self.title.is_a?(Array) || self.description.is_a?(Array)
    return if self.title.nil?
    self.title.gsub!("&#039;", "'")
    return if self.description.nil?
    self.description.gsub!("&#039;", "'")
  end

  def serialize_title_and_description
    return if self.title.is_a?(Array) || self.description.is_a?(Array)
    self.title_words = self.title.downcase if self.title
    self.description_words = self.description.downcase if self.description
  end

  def remove_backspaces
    return if self.title.is_a?(Array) || self.description.is_a?(Array)
    return if self.title.nil?
    self.title.gsub!("&nbsp;", " ")
    return if self.description.nil?
    self.description.gsub!("&nbsp;", " ")
  end

  def eliminate_ampersands
    return if self.title.is_a?(Array) || self.description.is_a?(Array)
    return if self.title.nil?
    self.title.gsub!("&amp;", "&")
    return if self.description.nil?
    self.description.gsub!("&amp; ", "")
  end

  def upcoming?
    self.starts_at >= now
  end

  def duration_formated
    if self.duration.nil? || self.duration == 0
      return nil
    else
      minutes = ((self.duration.to_f - self.duration.to_i.to_f) * 60).to_i.to_s
      time = self.duration.to_i.to_s + " h" + ( minutes == "0" ? "" : (minutes + " min"))
      duration_of_activity(time)
    end
  end

  def location_formated
    (self.street ? self.street : "") + (self.city ? (", " + self.city) : "") + (self.region ? (", " + self.region.name) : "") + (self.zip ? (", " + self.zip.to_s) : "")
  end

  def location_formated_short
    (self.city ? self.city : "") + (self.region ? (", " + self.region.code.upcase) : "") 
  end

  def cat
    self.category.name
  end

  def display_price
    case 
    when self.min_price && self.max_price && self.min_price != self.max_price
      "between $#{min_price.to_i} and $#{max_price.to_i}"
    when self.min_price && self.max_price || self.min_price
      " $#{min_price.to_i}"
    when self.max_price
      " $#{min_price.to_i}"
    else
      nil
    end
  end

  def duration_of_activity(time)
    days = self.duration.to_i / 24
    case 
    when days > 13
      "#{days / 7} weeks"
    when days > 6 
      "#{days / 7} week, #{days % 7} day" + (days % 7 > 1 ? "s" : "")
    when days > 1 
      "#{days % 7} days, #{self.duration.to_i % 24} hour" + (self.duration.to_i / 24 > 1 ? "s" : "")
    else
      time
    end
  end

  def beginning_date_formated
    self.starts_at.strftime(" %A,%B %-d %Y, at %l:%M %P") if self.starts_at
  end

  def beginning_time_formated
    self.starts_at.strftime(" at %l:%M %P") if self.starts_at
  end

  def to_param
    "#{id}/#{url_slug}"
  end

  private

  def valid_phone
    if self.phone.blank?
      return true 
    else
      temp_number = self.phone.gsub(/[^0-9]/i, '')
      return true if temp_number.length == 0
      self.phone = number_to_phone(temp_number, "-")
    end
  end

  def number_to_phone(number, delimiter)
    num = uninternationalize(number.to_s)
    num[0..2] + delimiter + num[3..5] + delimiter + num[6..9] + ( num[10..13].blank? ? "" : (":" + num[10..13])) if num.length > 10
  end

  def uninternationalize(num)
    if num[0] == 1 && (num.length == 11 || num.length == 15)
      num[1..-1]
    else
      num
    end
  end

  def days_shift(days)
    now = Time.now
    Time.at((DateTime.new(now.year, now.month, now.day + days, 0, 0, 0, 0)).to_i - now.utc_offset)
  end

  def now
    Time.now
  end

  def past?
    self.starts_at.getlocal < now
  end


  def slug_convert (str, trim = false)
    result = ''

    str.each_char do |kar|
      if SlugMapping.include?(kar)
        result << SlugMapping[kar]
      end
    end

    if trim
      tmp = result
      result = ""
      prefix = ""
      tmp.each_char do |kar|
        if kar == '-'
          prefix = "-"
        else
          prefix = '' if result == ""
          result << prefix + kar
          prefix = ''
        end
      end
    end

    result
  end

  def slug_it
    self.url_slug = slug_convert(self.title)
  end
end
