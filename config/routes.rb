Rails.application.routes.draw do
  
  get 'updater/index'

  resources :items do
    collection do
      get 'list'
    end 
    resources :pictures
    resources :locations
    resources :attributes
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
