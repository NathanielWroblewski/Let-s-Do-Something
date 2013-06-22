require 'spec_helper'

describe "Search Integration" do
  let(:country)              { create(:country, code: "US") }
  let(:activity_free)        { create(:activity, min_price: 0) }
  let(:activity_multi_price) { create(:activity, min_price: 0, max_price: 172) }
  let(:activity_max_price)   { create(:activity, max_price: 420) }
  let(:activity_min_price)   { create(:activity, min_price: 52) }
  let(:activity_nil)         { create(:activity, min_price: nil) }


  context "price search" do
    before do
      country
      activity_free
      activity_multi_price
      activity_min_price
      activity_max_price
      activity_nil
      visit root_path
    end

    describe "No price entered" do
      before do
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return free event" do        
        page.should have_content(activity_free.title)
      end 

      it "should return event with unknown price" do        
        page.should have_content(activity_nil.title)
      end 

      it "should return lowest price event" do        
        page.should have_content(activity_min_price.title)
      end 

      it "should return highest price event" do        
        page.should have_content(activity_max_price.title)
      end
    end

    describe "Min price entered" do
      before do
        fill_in 'min_price', :with => '52'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events at min price" do        
        page.should have_content(activity_min_price.title)
      end

      pending pending it "should return event higher than min price" do        
        page.should have_content(activity_max_price.title)
      end

      pending pending it "should return event if price range has values >= min" do        
        page.should have_content(activity_multi_price.title)
      end
    end

    describe "Max price entered" do
      before do
        fill_in 'max_price', :with => '420'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

     pending pending it "should return events at max price" do        
        page.should have_content(activity_max_price.title)
      end

      pending pending it "should return event below max price" do        
        page.should have_content(activity_min_price.title)
      end

      pending pending it "should return event with 'NIL' price" do      
        page.should have_content(activity_nil.title)
      end

      pending pending it "should return event if price range has values <= max" do
        page.should have_content(activity_multi_price.title)
      end
    end

    describe "Min and max price entered" do
      before do
        fill_in 'min_price', :with => '52'
        fill_in 'max_price', :with => '420'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events at min price" do
        page.should have_content(activity_min_price.title)
      end

      pending it "should return events at max price" do
        page.should have_content(activity_max_price.title)
      end

      pending it "should return event between min and max price" do
        page.should have_content(activity_multi_price.title)
      end
    end
  end
end

