
AspirinAnalysis::Application.routes.draw do

  resources :peptides, :only => [:index,:show]

  # resources :proteins, :only => [:index,:show]

  resources :proteins do
    resources :psms
  end

  match '/pages/:page' => 'viewer#show', :as => :view_page, :format => "html"

  root :to => 'peptides#index'

end
