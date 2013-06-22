module TimeHelper

  def next_week(date)
    date + (7 - date.wday)
  end

  def next_wday(date, n)
    n >= date.wday ? date + (n - date.wday) : date.next_week.next_day(n)
  end

  def weekend?(start_date, end_date)
    range_include(start_date, end_date, next_we_beginning, next_we_end)
  end

  def today?(start_date, end_date)
    tday = today.to_datetime
    tmorrow = (Date.today + 1).to_datetime
    range_include(start_date, end_date, tday, tmorrow)
  end

  def time_now
    Date.today.to_datetime
  end

  private

  def range_include(start_date, end_date, range_start, range_end)
    case 
    when start_date && end_date
      date_between(range_start, start_date, range_end) || date_between(range_start, end_date, range_end)
    when start_date
      date_between(range_start, start_date, range_end)
    when end_date
      date_between(range_start, end_date, range_end)
    else
      false
    end
  end

  def date_between(starts, date, ends)
    date >= starts && date <= ends
  end

  def today
    Date.today
  end

  def next_we_beginning
    case 
    when [6,7].include?(today.wday)
      p time_now
    when today.wday == 5
      [time_now, today.to_datetime - 0.25].max
    else
      next_wday(today.to_datetime, 6) - 0.25
    end
  end

  def next_we_end
    if today.wday == 7
      [time_now, today.to_datetime + 0.99999].max
    else
      next_wday(today.to_datetime, 7) + 0.99999
    end
  end
end
