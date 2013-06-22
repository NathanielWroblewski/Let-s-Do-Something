Synthesis::Application.routes.draw do

  post  'activities/search'         => 'activities#search'
  get   'surprise'                  => 'activities#surprise'
  get   'activities/results'        => 'activities#results'
  resources :activities, :only => [:index, :show]
  resources :categories, :only => [:index, :show] do
    get 'about', :on => :member
  end
  resources :admin, :except => [:new, :create, :show] do
    post 'edit_multiple', :on => :collection
    put  'update_multiple', :on => :collection
  end

  post  'activities/:id/coordinates'  => 'activities#coordinates'
  post  'activities/:id/increment'    => 'activities#increment'
  post  'activities/populate'         => 'activities#populate_search'
  match 'activities/:id/:url_slug'    => 'activities#show'
  match 'categories/:id/:url_slug'    => 'categories#show'
  post  'weather'                     => 'activities#weather'
  get   'admin/scubasteve'            => 'admin#scubasteve'

  root :to => 'activities#index'

end
