class ActivitiesController < ApplicationController
  caches_page :index, :show
  include ActivitiesHelper
  include PopulateSearchHelper
  include QueryHelper
  include WeatherHelper
  
  def index
    @activities = cached_front_page
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def increment
    @activity = Activity.find(params[:id])
    @activity.times_visited += 1
    @activity.save
    render json: {result: @activity.times_visited}
  end

  def populate_search
    search = params[:search]
    result = fill_form(search)
    render json: result.to_json
  end

  def search
    if params[:page]
      @page = params[:page].to_i
      @all_conditions = params[:all_conditions]
      @arguments = params[:arguments]
    else
      @page = 1
      params_check(params)
      @search = params[:search]
      @query = assemble_query(params)
    end
    @list_of_ids = []
    @activities = Activity.find(:all, :conditions => [@all_conditions, @arguments])
    @list_of_ids = @activities.map! { |activity| activity.id }
    @activities = results_to_display(@list_of_ids, @page)      
    @pages = (@list_of_ids.length - 1) / 20 + 1
    respond_to do |format|
      format.html { render :results }
      format.json { render json: {
        'action' => 'update',
        'html' => render_to_string(partial: 'results_list.html.erb', locals: { :activities => @activities, :page => @page, :pages => @pages, :all_conditions => @all_conditions, :arguments => @arguments })

        }} 
    end
  end

  def coordinates
    activity = Activity.find(params["activity_id"].to_i)
    render json: {  :lat     => activity.lat,
      :lon     => activity.long }
    end

  def weather
    api_call(params['zip'])
    render json: { :dates         => @weather[0].join(' '),
                   :maxTemp       => @weather[1].join,
                   :minTemp       => @weather[2].join,
                   :description   => @weather[3].join,
                   :imgURL        => @weather[4].join,
                   :windDirection => @weather[5].join,
                   :windSpeed     => @weather[6].join,
                   :weatherCode   => @weather[7].join }
  end

  def surprise
    session.clear
    @activities = cached_surprise.to_a.sample(30)
    render :results
  end
end
