module QueryHelper

  def assemble_query(attrs = {})
    search = fill_form(attrs[:search])
    @conditions = []
    @arguments  = {}
    build_queries({  :content     => [search[:content]].flatten,
                     :category_id => [attrs[:category]].flatten,
                     :street      => [attrs[:streets]],
                     :city        => [attrs[:cities]],
                     :region_id   => [attrs[:regions]],
                     :zip         => [attrs[:zips]],
                     :starts_at   => [attrs[:starts_at]],
                     :ends_at     => [attrs[:ends_at]],
                     :min_price   => [attrs[:min_price]],
                     :max_price   => [attrs[:max_price]] })
    compile_queries
  end

  def build_queries(attrs = {})
    attrs.each do |key, value_array|
      unless value_array.nil? || value_array.compact == [] || value_array.compact == [""]
        if key == :region_id
          value_array.map! do |value|
            r = Region.find_by_name(value)
            r.id
          end
        end
        new_conditions = []
        value_array.each_with_index do |value, index|
          next if value == "Which Category" || key == :starts_at || key == :ends_at || key == :min_price || key == :max_price
          case 
          when key == :content
            new_conditions << "title_words LIKE :title#{index} OR description_words LIKE :description#{index}"
            @arguments[("title#{index}").to_sym] = "%#{value}%"
            @arguments[("description#{index}").to_sym] = "%#{value}%"
            new_conditions << " OR " unless index == ( value_array.length - 1 )
          else
            new_conditions << "#{key} = :#{key}#{index}" if !value.blank?
            new_conditions << " OR " unless index == ( value_array.length - 1 )
            @arguments[("#{key}#{index}").to_sym] = value unless key == :category_id
            @arguments[("#{key}#{index}").to_sym] = value.to_i if key == :category_id && !value.blank?
          end
        end
        @conditions << new_conditions.join
      end
    end
    @conditions << date_condition_maker(attrs, :starts_at, :ends_at) if attrs[:starts_at] != [""]
    @conditions << price_condition_maker(attrs, :min_price, :max_price) if attrs[:min_price] != [""]
  end

  def compile_queries
    @conditions.select! {|query| query != "" }
    @all_conditions = @conditions.join(' AND ')
  end

  def date_condition_maker(range, starts, ends)
    start_range = range[starts].join
    end_range = range[ends].join
    conditions = []
    today = Date.today
    @arguments[starts] = start_range
    @arguments[ends] = end_range
    if start_range == end_range
      conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} = '#{start_range}') OR (#{ends.to_s} = '#{start_range}'))"
    else
      if end_range.blank?
        conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} >= '#{start_range}'))"
      else
        conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} <= '#{end_range}' AND #{ends.to_s} >= '#{start_range}') OR ((#{starts.to_s} <= '#{end_range}' AND #{starts.to_s} >= '#{today}') AND #{ends.to_s} IS NULL) OR (#{starts.to_s} IS NULL AND #{ends.to_s} >= '#{start_range}'))"
      end
    end
    conditions
  end

  def price_condition_maker(range, starts, ends)
    start_range = range[starts].join
    end_range = range[ends].join
    conditions = []
    @arguments[starts] = start_range
    @arguments[ends] = end_range
    if start_range == end_range
      conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} = '#{start_range}') OR (#{ends.to_s} = '#{start_range}'))"
    else
      if end_range.blank?
        conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} >= '#{start_range}'))"
      else
        conditions << "((#{starts.to_s} IS NULL AND #{ends.to_s} IS NULL) OR (#{starts.to_s} >= '#{start_range}' AND #{ends.to_s} <= '#{end_range}') OR ((#{starts.to_s} >= '#{start_range}') AND #{ends.to_s} IS NULL) OR (#{starts.to_s} IS NULL AND #{ends.to_s} <= '#{end_range}'))"
      end
    end
    conditions
  end
  
  def params_check(params)
    adjust_range(params, :starts_at, :ends_at)
    update_min_price(params)
  end

  def update_min_price(params)
    params[:min_price] = 0 if (params[:min_price] == "" && params[:max_price] != "")
  end

  def adjust_range(params, start_range, end_range)
    case 
    when params[start_range] != "" && params[end_range] == ""
      params[end_range] = params[start_range]
    when params[end_range] != "" && params[start_range] == ""
      params[start_range] = params[end_range]
    else
    end
    p params
  end

end
