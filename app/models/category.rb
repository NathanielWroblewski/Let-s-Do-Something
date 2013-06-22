# encoding: utf-8

require 'slug_mapping'

class Category < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  has_many :activities
  
  after_save :give_wordable
  before_create :slug_it

  attr_accessible :name, 
  :image_url, 
  :video_url, 
  :description, 
  :url_slug

  def to_param
    "#{id}/#{url_slug}"
  end


  def give_wordable
    word = Word.create(:word => self.name.downcase, :wordable_type => "category", :wordable_id => self.id, :counter => 0)
  end
  
  def self.all_sorted
    Category.order(:name).all
  end

  private

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
    self.url_slug = slug_convert(self.name)
  end

end
