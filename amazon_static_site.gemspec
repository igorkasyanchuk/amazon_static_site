
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "amazon_static_site/version"

Gem::Specification.new do |spec|
  spec.name          = "amazon_static_site"
  spec.version       = AmazonStaticSite::VERSION
  spec.authors       = ["Igor Kasyanchuk"]
  spec.email         = ["igorkasyanchuk@gmail.com"]

  spec.summary       = %q{Upload static website to S3}
  spec.description   = %q{Upload static website to S3}
  spec.homepage      = "https://github.com/igorkasyanchuk/amazon_static_site"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,spec,sample}/**/*", "Gemfile", "Gemfile.lock", "MIT-LICENSE", "Rakefile", "README.rdoc", "bin/amazon_static_site"]

  spec.executables   = ["amazon_static_site"]
  spec.bindir        = "bin"
  spec.require_paths = ["lib", "bin"]  

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"  
end
