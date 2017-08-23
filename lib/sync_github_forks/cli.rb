$LOAD_PATH << File.expand_path( '..', File.dirname(__FILE__) )

require 'yaml'
require 'ostruct'
require 'optparse'
require 'sync_github_forks/version'
require 'sync_github_forks/ctrl'

module SyncGithubForks; end

class SyncGithubForks::Cli
  def self.find_config
    if ENV['SYNC_GITHUB_FORKS']
      return ENV['SYNC_GITHUB_FORKS']
    end

    search_path = [
      'sync_github_forks.yaml',
      '.sync_github_forks.yaml',
      "#{ENV['HOME']}/.sync_github_forks.yaml",
      "#{ENV['HOME']}/.sync_github_forks/config.yaml"
    ]

    search_path.each do |path|
      if File.exist?(path)
        return path
      end
    end

    return nil
  end

  def self.version
    return SyncGithubForks::VERSION
  end

  private

  def self.start(args = ARGV)
    options = OpenStruct.new
    options.config_file = nil
    options.github_token = nil

    OptionParser.new do |opts|
      opts.on('-c', '--config FILE', 'Use FILE as the configuration file') do |file|
        options.config_file = file
      end

      opts.on('-t', '--github_token TOKEN', 'Your GitHub Access Token',
              'Default: GITHUB_ACCESS_TOKEN environment variable'
             ) do |token|

        options.github_token = token
      end

      opts.on('-h', '--help', 'This help message') do
        puts opts
        exit
      end
    end

    # Set option defaults

    ## Config File
    unless options.config_file
      options.config_file = find_config

      unless options.config_file
        $stderr.puts("ERROR: Could not find configuration file")
        exit 1
      end
    end

    begin
      options.config = YAML.load_file(options.config_file)
    rescue StandardError
      $stderr.puts("ERROR: Config '#{options.config_file}' is not a valid YAML file")
      exit 1
    end

    ## GitHub Token
    unless options.github_token
      options.github_token = ENV['GITHUB_ACCESS_TOKEN']
    end

    unless options.github_token
      $stderr.puts('ERROR: You must set GITHUB_ACCESS_TOKEN')
      exit 1
    end

    SyncGithubForks::Ctrl.sync(options)

    return 0
  end
end
