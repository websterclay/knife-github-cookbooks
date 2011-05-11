# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-github-cookbooks/version"

Gem::Specification.new do |s|
  s.name              = "knife-github-cookbooks"
  s.version           = Knife::GithubCookbooks::VERSION
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = false
  s.extra_rdoc_files  = ["LICENSE" ]
  s.authors           = ["Jesse Newland"]
  s.email             = ["jesse@websterclay.com"]
  s.homepage          = "https://github.com/websterclay/knife-github-cookbooks"
  s.summary           = %q{Github Cookbook installation support for Chef's Knife Command}
  s.description       = s.summary
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]
end