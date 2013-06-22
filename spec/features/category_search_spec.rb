require 'spec_helper'

describe "Search Integration" do
  let(:country)                 { create(:country, code: "US") }
  let(:activity_category1_orig) { create(:activity) }
  let(:activity_category1_2)    { create(:activity, category: activity_category1_orig.category) }
  let(:activity_category1_3)    { create(:activity, category: activity_category1_orig.category) }
  let(:activity_category2_orig) { create(:activity) }
  let(:activity_category2_2)    { create(:activity, category: activity_category2_orig.category) }
  let(:activity_category2_3)    { create(:activity, category: activity_category2_orig.category) }
  let(:activity_category3_orig) { create(:activity) }
  let(:activity_category3_2)    { create(:activity, category: activity_category3_orig.category) }
  let(:activity_category3_3)    { create(:activity, category: activity_category3_orig.category) }
  let(:activity_category4_orig) { create(:activity) }
  let(:activity_category4_2)    { create(:activity, category: activity_category4_orig.category) }
  let(:activity_category4_3)    { create(:activity, category: activity_category4_orig.category) }


  context "category search" do 
    before do
      country
      activity_category1_orig
      activity_category1_2
      activity_category1_3
      activity_category2_orig
      activity_category2_2
      activity_category2_3
      activity_category3_orig
      activity_category3_2
      activity_category3_3
      activity_category4_orig
      activity_category4_2
      activity_category4_3

      visit root_path
    end

    describe "no categories selected" do
      before do
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should show events with all categories" do
        page.should have_content ( activity_category1_orig.title )
        page.should have_content ( activity_category1_2.title )
        page.should have_content ( activity_category1_3.title )
        page.should have_content ( activity_category2_orig.title )
        page.should have_content ( activity_category2_2.title )
        page.should have_content ( activity_category2_3.title )
        page.should have_content ( activity_category3_orig.title )
        page.should have_content ( activity_category3_2.title )
        page.should have_content ( activity_category3_3.title )
        page.should have_content ( activity_category4_orig.title )
        page.should have_content ( activity_category4_2.title )
        page.should have_content ( activity_category4_3.title )
      end
    end

    describe "one category selected" do
      before do
        page.select activity_category1_orig.category.name, :from => 'category'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events from selected category" do
        page.should have_content ( activity_category1_orig.title )
        page.should have_content ( activity_category1_2.title )
        page.should have_content ( activity_category1_3.title )
      end

      pending it "should not return events from other categories " do
        page.should_not have_content ( activity_category2_orig.title )
        page.should_not have_content ( activity_category3_orig.title )
        page.should_not have_content ( activity_category4_orig.title )
      end
    end


    describe "mult. categories selected" do
      before do
        page.select activity_category1_orig.category.name, :from => 'category'
        page.select activity_category2_orig.category.name, :from => 'category'
        click_button('Find Events')
        page.current_path.should eq(activities_search_path)
      end

      pending it "should return events from selected category" do
        page.should have_content ( activity_category1_orig.title )
        page.should have_content ( activity_category1_2.title )
        page.should have_content ( activity_category1_3.title )
        page.should have_content ( activity_category2_orig.title )
        page.should have_content ( activity_category2_2.title )
        page.should have_content ( activity_category2_3.title )
      end

      pending it "should not return events from other categories " do
        page.should_not have_content ( activity_category3_orig.title )
        page.should_not have_content ( activity_category4_orig.title )
      end
    end
  end
end
