$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exes_poster/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exes_poster"
  s.version     = ExesPoster::VERSION
  s.authors     = ["Takahiro HAMAGUCHI"]
  s.email       = ["tk.hamaguchi@gmail.com"]
  s.homepage    = ""
  s.summary     = "Exception post to Elasticsearch"
  s.description = "Exception post to Elasticsearch."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "elasticsearch", "~> 2.0.0"
end
