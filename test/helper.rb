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


MiniTest::Unit.autorun
