module FileUploadCache
  class Tempfile < ::Tempfile
    attr_accessor :original_filename

    # mode should be :binmode or :text
    def self.for(data, filename, mode = :binmode, &block)
      file = self.new(filename)
      file.original_filename = filename

      begin
        file.binmode if mode == :binmode
        file.write(data)

        file.rewind
        block.call(file)
      ensure
        file.close
      end
    end

  end
end
