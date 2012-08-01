
AspirinAnalysis::Application.routes.draw do

  resources :peptides, :only => [:index,:show]

  match ':page' => 'viewer#show', :as => :view_page, :format => "html"

  root :to => 'peptides#index'

end
