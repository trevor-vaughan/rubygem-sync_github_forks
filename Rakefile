$: << File.expand_path( '../lib/', __FILE__ )

require 'fileutils'
require 'find'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubygems'

@package='sync_github_forks'
@rakefile_dir=File.dirname(__FILE__)

CLEAN.include "#{@package}-*.gem"
CLEAN.include 'coverage'
CLEAN.include 'dist'
CLEAN.include 'pkg'

Find.find( @rakefile_dir ) do |path|
  if File.directory? path
    CLEAN.include path if File.basename(path) == 'tmp'
  else
    Find.prune
  end
end

RSpec::Core::RakeTask.new(:spec)

task :default do
  puts %x(bundle exec rake -T)
end

desc 'Ensure gemspec-safe permissions on all files'
task :chmod do
  gemspec = File.expand_path( "#{@package}.gemspec", @rakefile_dir ).strip
  spec = Gem::Specification::load( gemspec )
  spec.files.each do |file|
    FileUtils.chmod 'go=r', file
  end
end

namespace :pkg do
  desc "build rubygem package for #{@package}"
  task :gem => :chmod do
    gem_dirs = [@rakefile_dir]
    gem_dirs += Dir.glob('ext/gems/*')

    gem_dirs.each do |gem_dir|
      Dir.chdir gem_dir do
        Dir['*.gemspec'].each do |spec_file|
          cmd = %Q{bundle exec gem build "#{spec_file}" &> /dev/null}
          sh cmd
          FileUtils.mkdir_p 'dist'
          FileUtils.mv Dir.glob('*.gem'), File.join(@rakefile_dir, 'dist')
        end
      end
    end
  end

  desc "build and install rubygem package for #{@package}"
  task :install_gem => [:clean, :gem] do
    Dir.chdir @rakefile_dir
    Dir.glob("dist/#{@package}*.gem") do |pkg|
      sh %Q{bundle exec gem install #{pkg}}
    end
  end
end
# vim: syntax=ruby
