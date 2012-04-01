require 'uuid'
require 'active_support/core_ext/module/attribute_accessors.rb'

require 'file_upload_cache/cached_file'


module FileUploadCache
  mattr_accessor :cache


end
