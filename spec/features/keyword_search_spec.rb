require 'spec_helper'

describe "Search Integration", js: true do
  let(:country)                 { create(:country, code: "US") }
  let(:category2)               { create(:category, name: "don't show me") }

  let(:activity_category1_orig) { create(:activity) }
  let(:activity_category1_2)    { create(:activity, category: activity_category1_orig.category) }
  let(:activity_category1_3)    { create(:activity, category: activity_category1_orig.category) }
  let(:activity_category2_orig) { create(:activity, category_id: 2) }
  let(:activity_category2_2)    { create(:activity, category: activity_category2_orig.category) }
  let(:activity_category2_3)    { create(:activity, category: activity_category2_orig.category) }

  let(:activity_today)          { create(:activity) }
  let(:activity_tomorrow)       { create(:activity, starts_at: Time.now + 61_200) }
  let(:activity_next_week)      { create(:activity, starts_at: Time.now + 579_600) }
  let(:activity_next_month)     { create(:activity, starts_at: Time.now + 2_394_000) }
  let(:activity_next_year)      { create(:activity, starts_at: Time.now + 31_424_400) }

  let(:activity_street)         { create(:activity, title: "I only want this to show", street: "Street Name") }
  let(:activity_city)           { create(:activity, title: "I only want this to show", city: "City Name") }
  let(:activity_state)          { create(:activity, title: "I only want this to show") }
  let(:activity_zip)            { create(:activity, title: "I only want this to show", zip: "00500") }

  let(:activity_free)           { create(:activity, min_price: 0) }
  let(:activity_multi_price)    { create(:activity, min_price: 0, max_price: 172) }
  let(:activity_max_price)      { create(:activity, max_price: 420) }
  let(:activity_min_price)      { create(:activity, min_price: 52) }


  context "keyword search" do 
    before do
      country
      activity_category1_orig
      activity_category1_2
      activity_category1_3
      category2
      activity_category2_orig
      activity_category2_2
      activity_category2_3
      activity_today
      activity_tomorrow
      activity_next_week
      activity_next_month
      activity_next_year
      activity_street
      activity_city
      activity_state
      activity_zip
      activity_free
      activity_multi_price
      activity_max_price
      activity_min_price

      visit root_path
    end

    describe "category via search" do
      before do
        fill_in 'search', :with => '#{activity_category1_orig.category.name}'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should show events with specified category" do
        pending
        page.should have_content(activity_category1_orig.title)
        page.should have_content(activity_category1_2.title)
        page.should have_content(activity_category1_3.title)
        page.should_not  have_content(activity_category2_orig.title)
      end
    end

    context "date via search" do
      context "in words" do
        pending context "such as today/tomorrow/this weekend/next month" do
          describe "today" do
            before do
              fill_in 'search', :with => 'today'
              click_button('Find Events')
              page.current_path.should eq(activities_search_path)
            end

            describe "should return events occuring today" do
              page.should have_content(activity_today.title)
            end

            describe "should not return events occuring any other time" do
              page.should_not have_content(activity_tomorrow.title)
              page.should_not have_content(activity_next_month.title)
              page.should_not have_content(activity_next_year.title)
            end
          end

          describe "tomorrow" do
            before do
              fill_in 'search', :with => 'tomorrow'
              click_button('Find Events')
              page.current_path.should eq(activities_search_path)
            end

            pending describe "should return events occuring tomorrow" do
              page.should have_content(activity_tomorrow.title)
            end

            pending describe "should not return events occuring any other time" do
              page.should_not have_content(activity_today.title)
              page.should_not have_content(activity_next_month.title)
              page.should_not have_content(activity_next_year.title)
            end
          end

          describe "next week" do
            before do
              fill_in 'search', :with => 'next week'
              click_button('Find Events')
              page.current_path.should eq(activities_search_path)
            end

            pending describe "should return events occuring next week" do
              page.should have_content(activity_next_week.title)
            end

            pending describe "should not return events occuring any other time" do
              page.should_not have_content(activity_today.title)
              page.should_not have_content(activity_next_month.title)
              page.should_not have_content(activity_next_year.title)
            end
          end

          describe "next month" do
            before do
              fill_in 'search', :with => 'next month'
              click_button('Find Events')
              page.current_path.should eq(activities_search_path)
            end

            pending describe "should return events occuring next month" do
              page.should have_content(activity_next_month.title)
            end

            pending describe "should not return events occuring any other time" do
              page.should_not have_content(activity_next_year.title)
            end
          end

          describe "next year" do
            before do
              fill_in 'search', :with => 'next year'
              click_button('Find Events')
              page.current_path.should eq(activities_search_path)
            end

            pending describe "should return events occuring next month" do
              page.should have_content(activity_next_year.title)
            end

            pending describe "should not return events occuring any other time" do
              page.should_not have_content(activity_today.title)
            end
          end
        end

        # pending context "such as April first" do
        #   before do
        #     fill_in 'search', :with => ''
        #     click_button('Find Events')
        #     page.current_path.should eq(activities_search_path)
        #   end

        #   describe "should " do

        #   end

        #   describe "should " do

        #   end
        # end
      end

      # pending context "in numbers" do
      #   before do
      #     fill_in 'search', :with => ''
      #     click_button('Find Events')
      #     page.current_path.should eq(activities_search_path)
      #   end

      #   describe "should " do

      #   end

      #   describe "should " do

      #   end
      # end


      # pending context "in words and numbers" do
      #   before do
      #     fill_in 'search', :with => ''
      #     click_button('Find Events')
      #     page.current_path.should eq(activities_search_path)
      #   end

      #   describe "should " do

      #   end

      #   describe "should " do

      #   end
      # end
    end


    context "location via search" do
      describe "street input" do
        before do
          fill_in 'search', :with => 'Street Name'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return results with same street name" do
          page.should have_content(activity_street.title)
        end

        pending it "should not return results containing other street names " do
          page.should_not have_content(activity_city.title)
          page.should_not have_content(activity_state.title)
          page.should_not have_content(activity_zip.title)
        end
      end

      describe "city input" do
        before do
          fill_in 'search', :with => 'City Name'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return results with same city name" do
          page.should have_content(activity_city.title)
        end

        pending it "should not return results containing other city names " do
          page.should_not have_content(activity_street.title)
          page.should_not have_content(activity_state.title)
          page.should_not have_content(activity_zip.title)
        end
      end

      describe "state input" do
        before do
          r_id = activity_state.region_id
          region = Region.find(r_id)
          fill_in 'search', :with => region.code
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return results with same state name" do
          page.should have_content(activity_state.title)
        end

        pending it "should not return results containing other state names " do
          page.should_not have_content(activity_street.title)
          page.should_not have_content(activity_city.title)
          page.should_not have_content(activity_zip.title)
        end
      end

      describe "zip input" do
        before do
          fill_in 'search', :with => '00500'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return results with same zip name" do
          pending
          page.should have_content(activity_zip.title)
        end

        pending it "should not return results containing other zip names " do
          page.should_not have_content(activity_street.title)
          page.should_not have_content(activity_city.title)
          page.should_not have_content(activity_state.title)
        end
      end
    end


    context "price via search" do
      context "free" do
        before do
          fill_in 'search', :with => 'free'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events that are free" do
          page.should have_content(activity_free.title)
          page.should have_content(activity_multi_price.title)
        end

        pending it "should not return events that are not free " do
          pending
          page.should_not have_content(activity_max_price.title)
          page.should_not have_content(activity_min_price.title)
        end
      end

      context "mid-range" do
        before do
          fill_in 'search', :with => 'between 100 and 200'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events that have that price or lower" do
          page.should_not have_content(activity_multi_price.title)
        end

        pending it "should not return events that don't have that price " do
          page.should_not have_content(activity_free.title)
          page.should_not have_content(activity_min_price.title)
          page.should_not have_content(activity_max_price.title)
        end
      end

      context "higher" do
        before do
          fill_in 'search', :with => 'greater than 400'
          click_button('Find Events')
          page.current_path.should eq(activities_search_path)
        end

        pending it "should return all events that have that price or higher" do
          page.should have_content(activity_max_price.title)
        end

        pending it "should not return events that don't have that price " do
          page.should_not have_content(activity_free.title)
          page.should_not have_content(activity_min_price.title)
          page.should_not have_content(activity_multi_price.title)
        end
      end
    end

    pending describe "multi-item search" do

    end
  end
end
