require 'spec_helper'

describe "Activities Integration" do
  let(:country)               { create(:country, code: "US") }
  let(:activity)              { create(:activity) }
  let(:activity2)             { create(:activity) }
  let(:activity_free)         { create(:activity, min_price: 0) }
  let(:activity_multi_price)  { create(:activity, min_price: 0, max_price: 20) }
  let(:activity_today)        { create(:activity) }
  
  describe "Homepage" do
    before do
      country
      activity
      activity2
      activity_today
      activity.times_visited += 10
      activity.save
      activity_today.times_visited += 20
      activity_today.save
      activity_free
      activity_multi_price
      visit root_path
    end

    context "activities" do
      it "should contain today's top 5 activities" do
        page.should have_content(activity.title)
        page.should have_content(activity_today.title)
        page.should have_content(activity_free.title)
        page.should have_content(activity_multi_price.title)
      end

      it "should direct to activity page when clicked" do
        within '.today' do
          click_link activity.title
        end
        page.current_path.should eq(activity_path(activity))
      end

      pending  it "should increment visited counter if link is clicked", js: true do
        expect { 
          within '.today' do 
            click_link activity2.title
          end 
        }.to change{activity2.reload.times_visited}.from(0).to(1)
      end
    end

    it "should ordered by number of times clicked" do
      within '.today' do
        page.should have_selector("ul li:nth-child(1)", text: activity_today.title)
        page.should have_selector("ul li:nth-child(2)", text: activity.title)
      end
    end
  end

  describe "Activity page" do
    before do
      activity
      activity_today
      activity_free
      activity_multi_price
      visit activity_path(activity)
    end

    it "should diplay the title" do
      page.should have_content(activity.title) 
    end

    it "should diplay the category" do
      page.should have_content(activity.category.name) 
    end

    it "should diplay the street" do
      page.should have_content(activity.street) 
    end

    it "should diplay the city" do
      page.should have_content(activity.city) 
    end

    it "should diplay the region" do
      page.should have_content(activity.region.name) 
    end

    it "should diplay the zip" do
      page.should have_content(activity.zip) 
    end

    it "should diplay the start date" do
      page.should have_content(activity.duration_formated) 
    end

    it "should have functioning link to category page" do
      click_link activity.category.name
      page.current_path.should eq(category_path(activity.category)) 
    end
  end
end

