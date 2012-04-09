class CachedFilesController < ActionController::Base
  before_filter :require_current_cached_file, :only => :show

  def show
    send_data current_cached_file.read, 
      :type => current_cached_file.content_type,  
      :disposition => 'inline'
  end

  private

  def current_cached_file
    @current_cached_file ||= FileUploadCache::CachedFile.find(params[:id])
  end

  def require_current_cached_file
    render :text => 'not found', :status => :not_found unless current_cached_file
  end
end
