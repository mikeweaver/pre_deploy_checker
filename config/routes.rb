Rails.application.routes.draw do
  # respond to root for load balancer health checks
  get '/', to: proc { [200, {}, ['OK']] }

  get '/400' => 'errors#bad_request'

  get '/404' => 'errors#not_found'

  get '/500' => 'errors#internal_server_error'

  get 'users/:id/unsubscribe/new' => 'users#new_unsubscribe'
  post 'users/:id/unsubscribe/create' => 'users#create_unsubscribe'

  resources :suppressions, except: [:show, :edit, :update, :destroy]

  namespace 'jira' do
    namespace 'status' do
      resources :push, only: [:edit, :update]
    end
  end

  namespace 'api' do
    scope '/v1' do
      namespace 'callbacks' do
        scope '/github' do
          post '/push' => 'github#push'
        end
        scope '/jira' do
          post '/hook' => 'jira#hook'
        end
      end
    end
  end
end
