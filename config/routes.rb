Rails.application.routes.draw do |map|
  resources :cached_files, :only => :show

end

