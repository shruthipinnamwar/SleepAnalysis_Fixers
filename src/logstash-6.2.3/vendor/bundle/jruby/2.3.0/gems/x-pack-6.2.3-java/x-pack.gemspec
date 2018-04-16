# encoding: utf-8
path = File.expand_path("../VERSION", __FILE__)
version = File.read(path).chomp.gsub('-', '.')

Gem::Specification.new do |s|
  s.name          = 'x-pack'
  s.version       = version
  s.licenses      = ['ELASTIC LICENSE']
  s.summary       = 'X-Pack bundles powerful features into a single plugin pack to extend Logstash functionality.'
  s.description   = 'X-Pack bundles powerful features into a single plugin pack to extend Logstash functionality.'
  s.homepage      = 'https://github.com/elastic'
  s.authors       = ['elastic']
  s.email         = 'dev_ops@elastic.co'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','*.gemspec','*.md','Gemfile','LICENSE.txt','NOTICE.txt', 'modules/**/*']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "pack" }
  s.platform = 'java'

  # Gem dependencies
  # We never use snapshot on the logstash version
  s.add_runtime_dependency "logstash-core", version.gsub('.SNAPSHOT', '')
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "logstash-output-elasticsearch"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_runtime_dependency "concurrent-ruby"

  s.add_development_dependency "rspec"
  s.add_development_dependency "logstash-devutils"
  s.add_development_dependency "paquet"
  s.add_development_dependency "rake"
  s.add_development_dependency "logstash-input-generator"
  s.add_development_dependency "logstash-output-null"
  s.add_development_dependency "json-schema"
  s.add_development_dependency "public_suffix", "< 1.5" # ruby 1.9 compat
  s.add_development_dependency "belzebuth"
  s.add_development_dependency "elasticsearch"
  s.add_development_dependency "stud"
end
