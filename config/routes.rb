Rails.application.routes.draw do 
  namespace :file_upload_cache do
    resources :cached_files, :only => :show
  end
end

