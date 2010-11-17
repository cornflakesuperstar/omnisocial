Rails::Application.routes.draw do
  match '/login'                  => 'omnisocial/auth#new',      :as => :login
  match '/auth/:service/callback' => 'omnisocial/auth#callback'
  match '/auth/confirm/:account_id' => 'omnisocial/auth#confirm', :as => :confirm
  match '/auth/failure'           => 'omnisocial/auth#failure'
  match '/logout'                 => 'omnisocial/auth#destroy',  :as => :logout
end
