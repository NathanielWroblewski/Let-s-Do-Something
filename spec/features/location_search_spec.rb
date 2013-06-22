require 'spec_helper'

describe "Search Integration" do
  let(:country)                  { create(:country, code: "US") }
  let(:country2)                 { create(:country, code: "GA") }
  let(:country3)                 { create(:country, code: "IL") }
  #different street name
  let(:activity_venue1_street1)  { create(:activity) }
  let(:activity_venue1_street2)  { create(:activity, street: "NOT my street - will return") }
  let(:activity_venue1_street3)  { create(:activity, street: "NOT it") }
  #different city name
  let(:activity_venue1_city1)    { create(:activity) }
  let(:activity_venue1_city2)    { create(:activity, city: "NOT my city - will return") }
  let(:activity_venue1_city3)    { create(:activity, city: "NOT it") }
  #different state
  let(:activity_venue1_state1)   { create(:activity) }
  let(:activity_venue1_state2)   { create(:activity, region: "NY") }
  let(:activity_venue1_state3)   { create(:activity, region: "MD") }
  #different zip
  let(:activity_venue1_zip1)     { create(:activity) }
  let(:activity_venue1_zip2)     { create(:activity, zip: "48274") }
  let(:activity_venue1_zip3)     { create(:activity, zip: "58972") }  
  #different country
  let(:activity_venue1_country1) { create(:activity) }
  let(:activity_venue1_country2) { create(:activity, country_id: 2) }
  let(:activity_venue1_country3) { create(:activity, country_id: 3) }
  #new venue
  let(:activity_venue2)          { create(:activity, venue_name: "NOT my venue - will return") }
  let(:activity_venue3)          { create(:activity, venue_name: "NOT it") }
  
  context "location search" do 
    before do
      country
      country2
      country3
      activity_venue1_street1
      activity_venue1_street2
      activity_venue1_street3
      activity_venue1_city1
      activity_venue1_city2
      activity_venue1_city3
      activity_venue1_state1
      activity_venue1_state2
      activity_venue1_state3
      activity_venue1_zip1
      activity_venue1_zip2
      activity_venue1_zip3
      activity_venue1_country1
      activity_venue1_country2
      activity_venue1_country3
      activity_venue2
      activity_venue3

      visit root_path
    end

    context "using form tag" do
      describe "by street" do
        before do
          fill_in 'streets', :with => 'my street'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events with same street name" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)

          page.should have_content(activity_venue1_street2.title)
        end

        pending it "should not return events with different street name" do
          page.should_not have_content(activity_venue1_street3.title)
        end
      end

      describe "by city" do
        before do
          fill_in 'cities', :with => 'my city'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events with same city name" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)

          page.should have_content(activity_venue1_city2.title)
        end

        pending it "should not return events with different city name" do
          page.should_not have_content(activity_venue1_city3.title)
        end
      end

      describe "by state" do
        before do
          fill_in 'regions', :with => 'cA'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end


        pending it "should return all events with same state name" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)
        end

        pending it "should not return events with different state name" do
          page.should_not have_content(activity_venue1_state2.title)
          page.should_not have_content(activity_venue1_state3.title)
        end
      end

      describe "by zip" do
        before do
          fill_in 'zips', :with => '90543'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events with same zip" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)
        end

        pending it "should not return events with different zip" do
          page.should_not have_content(activity_venue1_zip2.title)
          page.should_not have_content(activity_venue1_zip3.title)
        end
      end
    end

    context "using search bar" do
      describe "by venue" do
        before do
          fill_in 'search', :with => 'my venue'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events with same venue name" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)
        end

        pending it "should not return events with different venue name" do
          page.should_not have_content(activity_venue2.title)
        end

      end

      describe "by country" do
        before do
          fill_in 'search', :with => 'uS'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end


        pending it "should return all events with same country" do
          page.should have_content(activity_venue1_street1.title)
          page.should have_content(activity_venue1_city1.title)
          page.should have_content(activity_venue1_state1.title)
          page.should have_content(activity_venue1_zip1.title)
          page.should have_content(activity_venue1_country1.title)
        end

        pending it "should not return events with different country" do
          page.should_not have_content(activity_venue1_country2.title)
          page.should_not have_content(activity_venue1_country3.title)
        end
      end
    end
  end
end
