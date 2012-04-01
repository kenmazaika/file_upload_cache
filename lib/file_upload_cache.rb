require 'uuid'
require 'active_support/core_ext/module/attribute_accessors.rb'

require 'file_upload_cache/cached_file'


module FileUploadCache
  mattr_accessor :cache

  def self.file_cache
    if cache
      cache
    elsif defined(Rails)
      Rails.cache
    else
      raise "Unspecified Cache Store for File Upload Cache"
    end
  end

end
