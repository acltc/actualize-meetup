Rails.application.routes.draw do
  get '/' => 'datas#index'
  get '/contacts' => 'datas#index'
  post '/contacts' => 'datas#create'

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  get "/logout" => "sessions#destroy"

  get '/admin' => 'datas#admin'
  get '/events' => 'datas#events'
  get '/events/:id' => 'datas#event_csv'
  get '/contacts/:id/edit' => 'datas#edit'
  patch '/contacts/:id' => 'datas#update'
end
