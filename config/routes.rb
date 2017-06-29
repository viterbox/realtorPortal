Rails.application.routes.draw do
  resources :items do
    collection do
      get 'list'
    end 
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
