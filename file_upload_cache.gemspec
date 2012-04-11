# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "file_upload_cache"
  s.summary = "Insert FileUploadCache summary."
  s.description = "Insert FileUploadCache description."
  s.files = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile"]
  s.version = "1.0.1"
  s.authors = ['Ken Mazaika']
  s.add_dependency 'uuid'
  s.add_dependency 'rails'

end
