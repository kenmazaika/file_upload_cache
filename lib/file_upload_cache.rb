require 'file_upload_cache/engine.rb'
require 'active_support/core_ext/module/attribute_accessors.rb'
require 'file_upload_cache/cached_attributes.rb'
require 'securerandom'

module FileUploadCache
  mattr_accessor :cache

  def self.file_cache
    if cache
      cache
    elsif defined?(Rails)
      Rails.cache
    else
      raise "Unspecified Cache Store for File Upload Cache"
    end
  end

end

