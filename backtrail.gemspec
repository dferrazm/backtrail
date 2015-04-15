$:.push File.expand_path("../lib", __FILE__)

require "backtrail/version"

Gem::Specification.new do |s|
  s.name        = "backtrail"
  s.version     = Backtrail::VERSION
  s.authors     = ["Daniel Ferraz"]
  s.email       = ["d.ferrazm@gmail.com"]
  s.homepage    = "https://github.com/dferrazm/backtrail"
  s.summary     = "Keep a trail of requests for your Rails application"
  s.description = "Keep a trail of requests for your Rails application"
  s.license     = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'railties', '>= 4.0'
  s.add_development_dependency 'mocha'
end
