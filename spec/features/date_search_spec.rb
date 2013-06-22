require 'spec_helper'

describe "Search Integration" do
  let(:country)             { create(:country, code: "US") }
  let(:activity_today)      { create(:activity) }
  let(:activity_tomorrow)   { create(:activity, starts_at: Time.now + 61_200) }
  let(:activity_next_week)  { create(:activity, starts_at: Time.now + 579_600) }
  let(:activity_next_month) { create(:activity, starts_at: Time.now + 2_394_000) }
  let(:activity_next_year)  { create(:activity, starts_at: Time.now + 31_424_400) }
  
  context "date range search" do 
    before do
      country
      activity_today
      activity_tomorrow
      activity_next_week
      activity_next_month
      activity_next_year
      visit root_path
    end

    describe "No date entered" do
      pending it "should return events on or after current date" do
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
        page.should have_content(activity_today.title)
        page.should have_content(activity_next_week.title)
      end
    end

    describe "Start date entered" do
      before do
        fill_in 'starts_at', :with => activity_tomorrow.starts_at.year/activity_tomorrow.starts_at.mon/activity_tomorrow.starts_at.day
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events on start date" do        
        page.should have_content(activity_tomorrow.title)
      end

      pending it "should return event after start date" do        
        page.should have_content(activity_next_week.title)
        page.should have_content(activity_next_month.title)
        page.should have_content(activity_next_year.title)
      end
    end

    describe "End date entered" do
      before  do
        fill_in 'ends_at', :with => activity_next_week.starts_at.year/activity_next_week.starts_at.mon/activity_next_week.starts_at.day
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events on end date" do          
        page.should have_content(activity_next_week.title)
      end

      pending it "should return event before end date" do        
        page.should have_content(activity_tomorrow.title)
      end
    end

    describe "Start and end date entered" do
      before do
        fill_in 'starts_at', :with => activity_tomorrow.starts_at.year/activity_tomorrow.starts_at.mon/activity_tomorrow.starts_at.day
        fill_in 'starts_at', :with => activity_next_month.starts_at.year/activity_next_month.starts_at.mon/activity_next_month.starts_at.day
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events on start date" do        
        page.should have_content(activity_tomorrow.title)
      end

      pending it "should return events on end date" do        
        page.should have_content(activity_next_month.title)
      end

      pending it "should return event between start and end date" do        
        page.should have_content(activity_next_week.title)
      end
    end
  end

end

