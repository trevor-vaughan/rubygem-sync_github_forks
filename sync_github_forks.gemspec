$: << File.expand_path( '../lib/', __FILE__ )
require 'sync_github_forks/version'
require 'date'

Gem::Specification.new do |s|
  s.name     = 'sync_github_forks'
  s.date     = Date.today.to_s
  s.summary  = 'A simple tool for synchronizing GitHub forked repositories'
  s.description = <<-EOF
    A tool, that will synchronize specific forked GitHub repositories.

    Includes capabilities for pinning branches to be syncronized as well as tag synchronization.
  EOF
  s.version  = SyncGithubForks::VERSION
  s.license  = 'Apache-2.0'
  s.email    = 'tvaughan@onyxpoint.com'
  s.homepage = 'https://github.com/onyxpoint/rubygem-sync_github_forks'
  s.authors  = [ 'Trevor Vaughan' ]
  s.metadata = { 'issue_tracker' => 'https://github.com/onyxpoint/rubygem-sync_github_forks' }

  s.executables = 'sync_github_forks'

  s.required_ruby_version = '>= 2.1.9'

  # gem dependencies
  #   for the published gem
  s.add_runtime_dependency 'octokit', '>= 4.6.2', '< 5.0.0'

  # for development
  s.add_development_dependency 'rake',        '~> 10'
  s.add_development_dependency 'dotenv',      '~> 1'
  s.add_development_dependency 'rubocop',     '~> 0.29'
  s.add_development_dependency 'rspec'

  # simple text description of external requirements (for humans to read)
  s.requirements << 'GitHub OctoKit'

  # ensure the gem is built out of versioned files
  s.files = Dir['Rakefile', '{bin,lib,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z .`.split("\0")
end
