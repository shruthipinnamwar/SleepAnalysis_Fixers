# -*- encoding: utf-8 -*-
# stub: x-pack 6.2.3 java lib

Gem::Specification.new do |s|
  s.name = "x-pack".freeze
  s.version = "6.2.3"
  s.platform = "java".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "logstash_group" => "pack", "logstash_plugin" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["elastic".freeze]
  s.date = "2018-03-13"
  s.description = "X-Pack bundles powerful features into a single plugin pack to extend Logstash functionality.".freeze
  s.email = "dev_ops@elastic.co".freeze
  s.homepage = "https://github.com/elastic".freeze
  s.licenses = ["ELASTIC LICENSE".freeze]
  s.rubygems_version = "2.6.13".freeze
  s.summary = "X-Pack bundles powerful features into a single plugin pack to extend Logstash functionality.".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<logstash-core>.freeze, ["= 6.2.3"])
      s.add_runtime_dependency(%q<logstash-core-plugin-api>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<logstash-output-elasticsearch>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<logstash-codec-plain>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<logstash-devutils>.freeze, [">= 0"])
      s.add_development_dependency(%q<paquet>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<logstash-input-generator>.freeze, [">= 0"])
      s.add_development_dependency(%q<logstash-output-null>.freeze, [">= 0"])
      s.add_development_dependency(%q<json-schema>.freeze, [">= 0"])
      s.add_development_dependency(%q<public_suffix>.freeze, ["< 1.5"])
      s.add_development_dependency(%q<belzebuth>.freeze, [">= 0"])
      s.add_development_dependency(%q<elasticsearch>.freeze, [">= 0"])
      s.add_development_dependency(%q<stud>.freeze, [">= 0"])
    else
      s.add_dependency(%q<logstash-core>.freeze, ["= 6.2.3"])
      s.add_dependency(%q<logstash-core-plugin-api>.freeze, ["~> 2.0"])
      s.add_dependency(%q<logstash-output-elasticsearch>.freeze, [">= 0"])
      s.add_dependency(%q<logstash-codec-plain>.freeze, [">= 0"])
      s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<logstash-devutils>.freeze, [">= 0"])
      s.add_dependency(%q<paquet>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<logstash-input-generator>.freeze, [">= 0"])
      s.add_dependency(%q<logstash-output-null>.freeze, [">= 0"])
      s.add_dependency(%q<json-schema>.freeze, [">= 0"])
      s.add_dependency(%q<public_suffix>.freeze, ["< 1.5"])
      s.add_dependency(%q<belzebuth>.freeze, [">= 0"])
      s.add_dependency(%q<elasticsearch>.freeze, [">= 0"])
      s.add_dependency(%q<stud>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<logstash-core>.freeze, ["= 6.2.3"])
    s.add_dependency(%q<logstash-core-plugin-api>.freeze, ["~> 2.0"])
    s.add_dependency(%q<logstash-output-elasticsearch>.freeze, [">= 0"])
    s.add_dependency(%q<logstash-codec-plain>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<logstash-devutils>.freeze, [">= 0"])
    s.add_dependency(%q<paquet>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<logstash-input-generator>.freeze, [">= 0"])
    s.add_dependency(%q<logstash-output-null>.freeze, [">= 0"])
    s.add_dependency(%q<json-schema>.freeze, [">= 0"])
    s.add_dependency(%q<public_suffix>.freeze, ["< 1.5"])
    s.add_dependency(%q<belzebuth>.freeze, [">= 0"])
    s.add_dependency(%q<elasticsearch>.freeze, [">= 0"])
    s.add_dependency(%q<stud>.freeze, [">= 0"])
  end
end
