# frozen_string_literal: true

require_relative "lib/informix_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "informix_rails"
  spec.version       = InformixRails::VERSION
  spec.authors       = ["Michael Pope"]
  spec.email         = ["michael@dtcorp.com.au"]

  spec.summary       = "Convert Informix to Rails"
  spec.description   = "Convert Informix 7.x forms (per files) to Rails views (erb files)."
  spec.homepage      = "https://github.com/map7/informix_rails"
  spec.required_ruby_version = ">= 2.4.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/map7/informix_rails"
  spec.metadata["changelog_uri"] = "https://github.com/map7/informix_rails/changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "thor", "~> 1.2.1"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
