module FileUploadCache
  class Tempfile < ::Tempfile

    # mode should be :binmode or :text
    def self.for(data, mode = :binmode, &block)
      file = self.new("tempfile")
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
