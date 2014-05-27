# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "file_upload_cache"
  s.summary = "Restore file uploads after validation errors."
  s.description = "Restore file uploads after validation errors."
  s.license = "MIT"
  s.files = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile"]
  s.version = "1.0.5"
  s.authors = ['Ken Mazaika']

  s.add_dependency "rails", ">= 3.0.12"
  s.add_development_dependency "formtastic"
end
