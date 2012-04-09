module FileUploadCache
  class CachedFilesController < ActionController::Base
    before_filter :require_current_cached_file, :only => :show

    def show
      options = {:disposition => 'inline'}
      options.merge!({:type => current_cached_file.content_type}) if current_cached_file.content_type
      send_data current_cached_file.read, options
    end

    private

    def current_cached_file
      @current_cached_file ||= FileUploadCache::CachedFile.find(params[:id])
    end

    def require_current_cached_file
      render :text => 'not found', :status => :not_found unless current_cached_file
    end
  end
end
