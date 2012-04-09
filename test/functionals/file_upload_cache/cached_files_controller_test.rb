require 'helper'

class FileUploadCache::CachedFilesControllerTest < ActionController::TestCase
  test "show not found" do
    nonexistant_id = UUID.generate(:compact)
    get :show, :id => nonexistant_id
    assert_response :not_found
  end

  test "show exists" do
    file = File.open(File.expand_path('test/fixtures/sadface.jpg'))
    cached_file = FileUploadCache::CachedFile.store(file)
    file.close

    get :show, :id => cached_file.id
    assert_response :success
  end

end
