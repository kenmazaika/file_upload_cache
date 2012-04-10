require 'test_helper'

module FileUploadCache
  class CachedAttributesTest < MiniTest::Unit::TestCase
    # See test_helper for MockOmg declaration

    def test_accessors_created_by_cached_file_for
      omg = MockOmg.new
      assert_equal nil, omg.omg_file_cache_id
      assert_equal nil, omg.cached_omg_file

      uuid = UUID.generate(:compact)
      omg.omg_file_cache_id = uuid
      assert_equal uuid, omg.omg_file_cache_id

      cached_file = FileUploadCache::CachedFile.new(:read => "OMG",
                                                    :id => 'id',
                                                    :original_filename => 'omg.omg',
                                                    :content_type => 'text')

      omg.cached_omg_file = cached_file
      assert_equal cached_file, omg.cached_omg_file
    end

    def test_alias_method_chain_will_cache_value_set_for_field
      omg = MockOmg.new

      file = TestMultipartFile.new(File.open(File.expand_path('test/fixtures/sadface.jpg'))) 
      omg.omg_file = file
      assert_equal file.read, omg.omg_file_data
      assert_equal file, omg.instance_eval { @omg_file_original }
    end

    def test_validation_works_if_no_image_data_is_present
      omg = MockOmg.new
      omg.valid?
    end

    def test_validation_stores_item_in_cache
      omg = MockOmg.new
      file = TestMultipartFile.new(File.open(File.expand_path('test/fixtures/sadface.jpg'))) 
      omg.omg_file = file

      cached_file = omg.cached_omg_file
      assert_equal nil, cached_file

      omg.valid?

      cached_file = omg.cached_omg_file
      assert cached_file.is_a?(FileUploadCache::CachedFile)
      
      assert ! cached_file.id.blank?
      fetched_cached_file = FileUploadCache::CachedFile.find(cached_file.id)
      assert_equal cached_file, fetched_cached_file
    end

    def test_validation_restores_item_from_cache_id
      file = TestMultipartFile.new(File.open(File.expand_path('test/fixtures/sadface.jpg'))) 
      cached_file = FileUploadCache::CachedFile.store(file)      
      assert ! cached_file.id.nil?

      omg = MockOmg.new
      omg.omg_file_cache_id = cached_file.id

      v = omg.valid?
      fetched_file = omg.omg_file_data

      tf = Tempfile.new("temp_file2")

      begin
        tf.binmode
        tf.write(cached_file.read)
        tf.rewind
        assert_equal tf.read, fetched_file
      ensure
        tf.close
      end
    end
  end
end
