AspirinAnalysis::Application.routes.draw do

  # get "viewer/show"

  # get "peptides/show"
  resources :peptides, :only => [:index,:show]


  match ':name' => 'viewer#show', :as => :view_page, :format => "html"

  root :to => 'peptides#index'

end
