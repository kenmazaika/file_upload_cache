require 'test_helper'

module FileUploadCache

  class TempfileTest < MiniTest::Unit::TestCase
    def test_for_binmode
      file_data = "OMGOMG"

      FileUploadCache::Tempfile.for(file_data) do |temp_file|
        assert_equal file_data, temp_file.read
      end
    end

    def test_for_text_mode
      file_data = "OMG"
      FileUploadCache::Tempfile.for(file_data, :text) do |temp_file|
        assert_equal file_data, temp_file.read
      end
    end
  end
end
