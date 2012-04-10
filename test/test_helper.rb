Dir.chdir File.expand_path('../..', __FILE__)
ENV['RAILS_ENV'] = 'test'
require 'rubygems'
require 'bundler'
require 'active_record'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'tester/config/environment'
require 'rails/test_help'



begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'file_upload_cache'

class MiniTest::Unit::TestCase
end

class TestMultipartFile
  attr_reader :read, :original_filename, :content_type, :file

  def initialize(file)
    @file = file
    @read = file.read
    @original_filename = file.path.split('/').last
    @content_type = file.path.split('.').last
  end

  def close
    @file.close
  end
end

class TestCacheStore
  def initialize
    @cache = Hash.new
  end

  def write(key, value)
    @cache[key] = value
  end

  def read(key)
    @cache[key]
  end
end

FileUploadCache.cache = TestCacheStore.new


# Build a mock object to do testing on.
class MockOmg
  include FileUploadCache::CachedAttributes
  include ActiveModel::Validations
  extend  ActiveModel::Callbacks

  define_model_callbacks :validation 

  attr_reader   :omg_file, :omg_file_data

  def omg_file=(file)
    @omg_file_data = file.read.dup
  end

  cached_file_for :omg_file



  class StringWithAddons < String
    def singular; "mock_omg"  end
    def plural;   "mock_omgs" end
    def i18n_key; "mock_omg"  end
  end

  def self.model_name
    StringWithAddons.new("mock_omg")
  end

  def to_key
    ["omg"]
  end

  # ActiveModel needs to explicitly run this to get the validation callbacks
  def valid?
    run_callbacks(:validation) { super }
  end
end

MiniTest::Unit.autorun
