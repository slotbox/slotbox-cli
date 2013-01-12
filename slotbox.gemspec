Gem::Specification.new do |gem|
  gem.name    = "slotbox"
  gem.version = "0.0.2"

  gem.author      = "Tom BUckley-Houston"
  gem.email       = "tom@tombh.co.uk"
  gem.homepage    = "http://slotbox.es"
  gem.summary     = "CLI to deploy and manage apps on Slotbox."
  gem.description = "Command-line tool to deploy and manage apps on Slotbox."
  gem.license     = "MIT"

  gem.executables = "slotbox"

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(License|README|bin/|plugin/|lib/|spec/|test/)} }
  gem.require_paths = ["lib"]
end