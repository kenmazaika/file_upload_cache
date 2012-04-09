require 'helper'
require 'active_record'
require 'file_upload_cache/cached_attributes.rb'
require 'file_upload_cache/engine.rb'

class UploaderInputTest < ActionController::TestCase
  # Include what is needed to actually make test calls to semantic form for
  include Formtastic::Helpers::FormHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Context
  include ActionController::RecordIdentifier

  def mock_omg_path(omg)
    "/omgs/#{omg.object_id}"
  end
  def protect_against_forgery?
    false
  end

  # Build a mock object to do testing on.
  class MockOmg
    include FileUploadCache::CachedAttributes
    include ActiveModel::Validations
    extend ActiveModel::Callbacks
    define_model_callbacks :validation   
    

    attr_accessor :omg_file
    cached_file_for :omg_file

    class StringWithAddons < String

      def singular
        "mock_omg"
      end

      def plural
        "mock_omgs"
      end

      def i18n_key
        "mock_omg"
      end
    end

    def self.model_name
      StringWithAddons.new("mock_omg")
    end

    def to_key
      ["omg"]
    end
  end

  def test_form_without_cache_id
    momg = MockOmg.new
    form = semantic_form_for(momg) do |f|
      f.input :omg_file, :as => :uploader
    end

    expected = '<li class="uploader input optional" id="mock_omg_omg_file_input"><label class=" label" for="mock_omg_omg_file">Omg file</label><input id="omg_file_cache" name="mock_omg[omg_file_cache_id]" type="hidden" /><input class="cached_file" id="omg_file" name="mock_omg[omg_file]" type="file" />'

    assert form.include?(expected)
  end

  def test_form_with_cache_id
    momg = MockOmg.new
    item_id = 'bf67b40064c1012ffb763c07542042b7'
    cached_file = FileUploadCache::CachedFile.new(:read => 'OMG',
      :id => item_id,
      :original_filename => 'omgomg.jpg',
      :content_type => 'image/jpg')

    momg.cached_omg_file = cached_file

    form = semantic_form_for(momg) do |f|
      f.input :omg_file, :as => :uploader
    end

    expected = "<li class=\"uploader input optional\" id=\"mock_omg_omg_file_input\"><label class=\" label\" for=\"mock_omg_omg_file\">Omg file</label><input id=\"omg_file_cache\" name=\"mock_omg[omg_file_cache_id]\" type=\"hidden\" value=\"#{item_id}\" /><input class=\"cached_file\" id=\"omg_file\" name=\"mock_omg[omg_file]\" type=\"file\" />"

    assert form.include?(expected)
  end

end

