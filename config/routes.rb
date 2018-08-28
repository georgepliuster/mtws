Rails.application.routes.draw do
  resources :city_statuses
  resources :cities
  resources :devices
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'CityList', to: 'cities#getcitieslist'

  get 'SubscriptionList', to: 'devices#getSubscriptionListFor'

  post 'CreateCitySubscription', to: 'devices#createSubscriptionList'

  get 'SendNotification', to: 'devices#sntd'		# sendNotificationsToDevices

  get 'SubmitToNotifier', to: 'devices#sendNotification'

  get 'CityStatuses', to: 'city_statuses#getCityStatusesFor'
end
