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
      # These require :service_name as a query string param
      resources :push, only: [:edit, :update]
    end
  end

  # Push routes
  get  ':service_name/sha/:id'          => 'jira/status/push#edit'
  get  ':service_name/deploy_email/:id' => 'jira/status/push#deploy_email'

  get  'branch/:branch' => 'jira/status/push#branch'
  get  'summary'        => 'jira/status/push#summary'

  namespace 'api' do
    scope '/v1' do
      namespace 'callbacks' do
        match 'ancestor_ref/:service_name', to: 'ancestor_ref#update', via: :post
        scope '/github' do
          post '/push' => 'github#push'
        end
        scope '/jira' do
          post '/hook' => 'jira#hook'
        end
      end
    end
  end

  # catch all route
  match ':all' => 'errors#not_found', via: [:all]
end
