AspirinAnalysis::Application.routes.draw do

  get "viewer/show"

  get "peptides/show"

  match ':name' => 'viewer#show', :as => :view_page
  
  root :to => 'peptides#index'
  
end
