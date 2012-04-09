Rails.application.routes.draw do |map|
  namespace :file_upload_cache do
    resources :cached_files, :only => :show
  end
end

