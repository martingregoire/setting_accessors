# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'setting_accessors/version'

Gem::Specification.new do |spec|
  spec.name          = 'setting_accessors'
  spec.version       = SettingAccessors::VERSION
  spec.authors       = ['Stefan Exner']
  spec.email         = ['stex@sterex.de']
  spec.summary       = %q{A global key-value-store and virtual model columns}
  spec.description   = %q{Adds a global key-value-store to Rails applications and allows adding typed columns
                          to model classes without having to change the database layout.}
  spec.homepage      = 'https://www.github.com/stex/setting_accessors'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2'

  spec.add_development_dependency 'bundler',                   '~> 1.6'
  spec.add_development_dependency 'rake',                      '~> 10.4'
  spec.add_development_dependency 'sqlite3',                   '~> 1.3'
  spec.add_development_dependency 'pry',                       '~> 0.10' # IRB replacement
  spec.add_development_dependency 'byebug',                    '~> 3.5'

  spec.add_development_dependency 'rspec',                     '~> 3.4'
  spec.add_development_dependency 'generator_spec',            '~> 0.9'  # Test generators with RSpec
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.1'  # RSpec collection matchers
  spec.add_development_dependency 'temping',                   '~> 3.4'  # Temporary AR classes
  spec.add_development_dependency 'database_cleaner',          '~> 1.5'  # Clean the temping database tables

  spec.add_dependency 'rails', '~> 4'
end
