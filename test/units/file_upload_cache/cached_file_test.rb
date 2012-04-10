require 'test_helper'
module FileUploadCache
  class CachedFileTest < MiniTest::Unit::TestCase
    def test_initializer
      file = FileUploadCache::CachedFile.new(:read => 'OMG', 
                            :id => 'id', 
                            :original_filename => 'omg.jpg',
                            :content_type => 'image/jpeg')

      assert_equal 'OMG', file.read
      assert_equal 'id', file.id
      assert_equal 'omg.jpg', file.original_filename
      assert_equal 'image/jpeg', file.content_type
    end

    def test_store_and_file

      file = TestMultipartFile.new(File.open(File.expand_path('test/fixtures/sadface.jpg')))
      file_data = file.read

      cached_file = FileUploadCache::CachedFile.store(file)
      assert_equal file.original_filename, cached_file.original_filename
      assert_equal file.content_type, cached_file.content_type
      assert ! cached_file.id.nil?
      assert_equal file_data, cached_file.read

      cached_file = FileUploadCache::CachedFile.find(cached_file.id)

      assert ! cached_file.nil?, 'Could not fetch cached file; is memcache running?'

      assert_equal file.original_filename, cached_file.original_filename
      assert_equal file.content_type, cached_file.content_type
      assert ! cached_file.id.nil?
      assert_equal file_data, cached_file.read

      file.close
    end

  end
end
