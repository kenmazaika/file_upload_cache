module FileUploadCache
  module CachedAttributes
    extend ActiveSupport::Concern

    module ClassMethods

      def cached_file_for(field)
        attr_accessor :"#{field}_cache_id", :"cached_#{field}"
        define_method "#{field}_with_cache=" do |value|
          instance_variable_set("@#{field}_original", value)
          self.send("#{field}_without_cache=", value)
        end

        alias_method_chain :"#{field}=", :cache

        before_validation lambda { 
          original = self.instance_variable_get("@#{field}_original")
          original.rewind if original && original.respond_to?(:rewind)

          self.send("cached_#{field}=", CachedFile.store(original)) if original.respond_to?(:read)
          if( ! self.send("#{field}_cache_id").blank? && original.blank? )
            cached_file = CachedFile.find(self.send("#{field}_cache_id"))

            FileUploadCache::Tempfile.for(cached_file.read, cached_file.original_filename) do |tf|
              self.send("#{field}=", tf)
              self.send("cached_#{field}=", cached_file)
            end

          end
        }
      end
    end
  end

end

ActiveRecord::Base.send(:include, FileUploadCache::CachedAttributes)
