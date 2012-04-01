module FileUploadCache
  class CachedFile
    attr_accessor :read, :id, :original_filename, :content_type

    def initialize(attributes)
      attributes.each do |k, v|
        self.send("#{k}=", v)
      end
    end

    def self.store(image)
      id = UUID.generate(:compact)
      cached_file = self.new(:read => image.read, 
                             :original_filename => image.original_filename, 
                             :id => id, 
                             :content_type => image.content_type)

      FileUploadCache.cache.write("FileUploadCache::#{id}", cached_file) 

      cached_file
    end

    def self.find(id)
      FileUploadCache.cache.read("FileUploadCache::#{id}")
    end

  end

end
