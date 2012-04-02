require 'active_support/core_ext/module/attribute_accessors.rb'
require 'app/models/cached_file.rb'
require 'app/inputs/uploader_input.rb'
require 'uuid'

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

