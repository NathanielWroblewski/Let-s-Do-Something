module ActivitiesHelper
  require 'cache.rb'

  def cached_surprise
    Cache.fetch('surprise') { surprise_me.to_a }
  end

  def surprise_me
    us = Country.find_by_code("US")
    us.activities.where("starts_at < ? AND category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ? OR category_id = ?", Time.now + 691200, 2, 7, 89, 16, 20, 22, 28, 30, 32, 33, 35, 37, 42, 45, 46, 71, 92, 93, 98, 118)
  end

  def weekend_list(activities)
   activities.select {|activity| activity; weekend?(activity.starts_at, activity.ends_at)}
  end

  def today_list(activities)
   activities.select {|activity| activity; today?(activity.starts_at, activity.ends_at)}
  end

  def all_activities
    us = Country.find_by_code("US")
    us.activities.where("ends_at > ?", Time.now - 86400)
  end

  def all_activities_for_week
    Country.find_by_code!("US").activities.where("ends_at > ? AND starts_at < ?", Time.now - 86400, Time.now + 691200)
  end

  def cached_front_page
    Cache.fetch('front_pages') { all_activities_for_week.to_a }
  end

  def sort_desc(activities, limit = nil)
    activities.sort_by! {|activity| activity.times_visited}
    limit ? activities.reverse.take(limit) : activities.reverse
  end

  def sort_asc(activities, limit = nil)
    activities.sort_by! {|activity| activity.times_visited}
    limit ? activities.take(limit) : activities
  end

  def cat_array
    Category.all_sorted.map { |category| [category.name, category.id]}
  end

  def results_to_display(results_id_array, page)
    first_event_to_show = ((page-1) * 20 + 1)
    last_event_to_show = [ (page * 20), results_id_array.length - 1].min
    @to_display = []
    (first_event_to_show..last_event_to_show).each do |index|
      @to_display << Activity.find(results_id_array[index])
    end
    p @to_display
  end
end
