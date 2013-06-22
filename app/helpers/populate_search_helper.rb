module PopulateSearchHelper

  def fill_form(search)
    categorized_words = parse_search(search)
    FPrinter.yellow(categorized_words.inspect)
    fields = initialize_fields_to_match
    FPrinter.green(fields.inspect)
    map_words_to_search_fields(categorized_words, fields)
  end

  def parse_search(search)
    individual_words = search.downcase.split(' ')
    parse_words_into_categories(individual_words)
  end

  def parse_words_into_categories(words)
    categorized_words = Hash.new { |hash, key| hash[key] = [] }
    parse_for_text_date(words, categorized_words)
    words = words.join(' ').split(' ')
    words.each do |word|
      parse_search_fields(word, categorized_words)
    end
    categorized_words
  end

  def parse_for_text_date(words, categorized_words)
    check_for_common_words(words, categorized_words)
    check_for_date_words(words, categorized_words)
  end

  def check_for_common_words(words, categorized_words)
    words.each do |word|
      check_for_days_of_week(word)
      check_for_common_date_words(word)
    end
    check_for_common_dates_with_qualifiers(words)
    check_for_holidays(words)
  end

  def check_for_holidays(words)
    match_string = words.join(' ')
    holidays = { "new year's eve"               => '12-31-2013',
                 "new year's day"               => '01-01-2014',
                 "independence day"             => '07-04-2013',
                 "fourth of july"               => '07-04-2013',
                 "veteran's day"                => '11-11-2013',
                 "christmas eve"                => '12-24-2013',
                 "christmas"                    => '12-25-2013',
                 "groundhog day"                => '02-02-2014',
                 "valentine's day"              => '02-14-2014',
                 "earth day"                    => '04-22-2014',
                 "flag day"                     => '06-14-2014',
                 "patriot day"                  => '09-11-2013',
                 "halloween"                    => '10-31-2013',
                 "pearl harbor remembrance day" => '12-07-2013'
                 }
    holidays.each do |holiday, date|
      words << date if match_string.match(holiday)
    end
  end

  def check_for_common_dates_with_qualifiers(words)
    join = words.join(' ')
    match = join.match(/next (week|month|year)/)
    words.each do |word|
      word.gsub!(word, format_next_week) if word == match.to_s.split(' ')[1] && match.to_s.split(' ')[1] == 'week'
      word.gsub!(word, format_next_month) if word == match.to_s.split(' ')[1] && match.to_s.split(' ')[1] == 'month'
      word.gsub!(word, format_next_year) if word == match.to_s.split(' ')[1] && match.to_s.split(' ')[1] == 'year'
    end
  end

  def format_next_week
    today = Date.today
    until today.sunday?
      today = today.next
    end
    [today.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1'), (today + 7).to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')].join(' ')
  end

  def format_next_month
    today = Date.today
    until today.day == 1
      today = today.next
    end
    [today.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1'), (today >> 1).to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')].join(' ')
  end

  def format_next_year
    today = Date.today
    [(today >> 12).to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1'), (today >> 24).to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')].join(' ')
  end

  def check_for_days_of_week(word)
    days = %w{ sunday monday tuesday wednesday thursday friday saturday }
    if days.include?(word)
      today = Date.today
      method = word + "?"
      until today.send(method)
        today = today.next
      end
      date = today.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')
      word.gsub!(word, date)
    end
  end

  def check_for_common_date_words(word)
    common_words = { 'tomorrow' => format_tomorrow,
                     'today'    => format_today,
                     'weekend'  => format_weekend }
    common_words.each do |common_word, translation|
      word.gsub!(word, translation) if word == common_word && translation.is_a?(String)
      word.gsub!(word, translation.join(' ')) if word == common_word && translation.is_a?(Array)
    end
  end

  def format_tomorrow
    Date.today.next.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')
  end

  def format_today
    Date.today.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')
  end

  def format_weekend
    today = Date.today
    until today.saturday?
      today = today.next
    end
    [today.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1'),today.next.to_s.gsub!(/(\d{4})(-)(\d{2}-\d{2})/, '\3\2\1')]
  end

  def check_for_date_words(words, categorized_words)
    months = %w{ january february march april may june july august september october november december }
    month = words.select{|word| months.include?(word)}
    unless month.empty?
      day = words.select {|word| word.gsub(/(th|rd|nd|st)/,'').to_i <= 31 && word.gsub(/(th|rd|nd|st)/,'').to_i != 0 }
      day.each {|word| word.gsub!(/(th|rd|nd|st)/,'') }
      if day.empty?
        day << 1
        day << 30
      end
      month_num = "0#{months.index(month[0]) + 1}" if months.index(month[0]) + 1 < 10
      month_num = "#{months.index(month[0]) + 1}" if months.index(month[0]) + 1 >= 10
      day_num = "0#{ day[0] }" if day[0].to_i < 10
      day_num = "#{ day[0] }" if day[0].to_i >= 10
      words.each do |word| 
        word.gsub!(month[0], "#{ month_num }-#{ day_num }-2013 ")
        word.gsub!(" ", " #{ month_num }-#{ day[1] }-2013") if day[1]
      end
    end
  end

  def parse_search_fields(word, categorized_words)
    unless parse_zip_codes(word, categorized_words) || parse_budget(word, categorized_words) ||  parse_dates(word, categorized_words)
      parse_miscellaneous(word, categorized_words)
    end
  end

  def parse_zip_codes(word, container)
    container[:zip] << word.to_i if word =~ /\d{5}/ && word.length == 5
  end

  def parse_budget(word, container)
    amount = word.gsub(/,/,'')
    container[:how_much] << amount.gsub(/\$/,'').to_i if amount =~ /\$\d*/ && (amount =~ /[a-z]/).nil?
  end

  def parse_dates(word, container)
    container[:date] << create_date(word, is_date(word)) if is_date(word)
  end

  def create_date(word, format)
    Date.strptime(word.gsub(/[-.\/]/, ''), format)
  end

  def is_date(date)
    date = date.gsub(/[-.\/]/, '')
    begin
      ['%m%d%Y','%m%d%y','%M%D%Y','%M%D%y'].find {|date_format| Date.strptime(date, date_format)}
    rescue
      false
    end
  end

  def parse_miscellaneous(word, container)
    check_db_for_category_mapping(word, container) unless word_already_categorized?(word, container)
  end

  def word_already_categorized?(word, container)
    container.values.flatten.include?(word)
  end

  def check_db_for_category_mapping(word, container)
    similar_words = fetch_similar_words(word)
    if similar_words.empty?
      Word.create(:word => word, :wordable_type => "to_check", :counter => 0)
    else
      map_word_to_category(container, similar_words) unless junk(similar_words)
    end
  end

  def junk(similar_words)
    similar_words.each do |word|
      return true if word.wordable_type == "junk"
    end
    false
  end

  def fetch_similar_words(word)
    Word.where(:word => word)
  end

  def map_word_to_category(container, similar_words)
    similar_words.each do |similarity|

      if similarity.has_a_category?
        categorize_word(similarity, container, similarity.wordable_type.to_sym)
      else
        increment_counter(similarity)
        container[:content] << similarity.word
      end
    end
  end

  def categorize_word(similarity, container, category)
    if category_is_a_location?(category)
      container[category] << similarity.wordable_id
    elsif category == :city
      container[category] << [similarity.interpretation]
    else
      container[:content] << similarity.interpretation
    end
  end

  def category_is_a_location?(category)
    [:country, :region, :category].include?(category)
  end

  def increment_counter(similarity)
    similarity.counter += 1
    similarity.save
  end

  def initialize_fields_to_match
    match_field = { :category  => [],
                    :street    => [],
                    :city      => [],
                    :region    => [],
                    :zip       => [],
                    :country   => [],
                    :starts_at => [],
                    :ends_at   => [],
                    :min_price => [],
                    :max_price => [], 
                    :content   => [] }
  end

  def map_words_to_search_fields(categorized_words, match_field)
    FPrinter.blue(categorized_words.inspect)
    categorized_words.each do |category, list|
      if [:country, :category, :city, :region].include?(category)
        add_location(category, list, match_field)
      elsif category == :how_much
        set_min_and_max_price(match_field, list)
      elsif category == :date
        set_min_and_max_date(match_field, list)
      else
        match_field[category] = list
      end
    end
    match_field
  end

  def add_location(category, list, match_field)
    list.each do |value|
      match_field[category] << objectified(category, value).id if category == :category
      match_field[category] << objectified(category, value).name if category != :city && category != :category
      match_field[category] = value if category == :city
    end
  end

  def objectified(field,value)
    classed = field.to_s.classify.constantize
    classed.find(value.to_i)
  end

  def set_min_and_max_price(match_field, list)
    match_field[:max_price] = list.max 
    match_field[:min_price] = list.min
  end

  def set_min_and_max_date(match_field, list)
    match_field[:starts_at] = list.min
    match_field[:ends_at]   = list.max
  end
end
