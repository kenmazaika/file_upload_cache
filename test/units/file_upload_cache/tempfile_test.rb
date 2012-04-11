require 'test_helper'

module FileUploadCache

  class TempfileTest < MiniTest::Unit::TestCase
    def test_for_binmode
      file_data = "OMGOMG"

      FileUploadCache::Tempfile.for(file_data, "omg.txt") do |temp_file|
        assert_equal file_data, temp_file.read
        assert_equal "omg.txt", temp_file.original_filename
      end
    end

    def test_for_text_mode
      file_data = "OMGOMG"

      FileUploadCache::Tempfile.for(file_data, "omg.txt", :text) do |temp_file|
        assert_equal file_data, temp_file.read
        assert_equal "omg.txt", temp_file.original_filename
      end
    end
  end
end
