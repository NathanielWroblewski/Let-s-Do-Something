require 'spec_helper'

describe "Categories Integration" do
  let(:country)         { create(:country, code: "US") }
  let(:activity)              { create(:activity) }
  let(:activity_free)         { create(:activity, min_price: 0) }
  let(:activity_multi_price)  { create(:activity, min_price: 0, max_price: 20) }
  let(:activity_today)        { create(:activity) }
  
  describe "Homepage" do
    before do
      country
      activity
      activity_today
      activity_free
      activity_multi_price
      visit root_path
    end

    # NO TESTS NEEDED AS OF 6/16/2013
    # NO CATEGORY INFO/LINKS ON HOMEPAGE

    # context "categories" do

    # end
  end

  describe "Category page" do
    before do
      activity
      activity_today
      activity_free
      activity_multi_price
      visit category_path(activity.category)
    end

    it "should contain category name" do
      page.should have_content(activity.category.name)
    end

    it "should contains the relevant activities" do
      page.should have_content(activity.title)
    end

    it "should not contains othe categories activities" do
      page.should_not have_content(activity_today.title)
    end
  end
end

