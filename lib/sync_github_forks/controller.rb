class SyncGithubForks::Controller
  def initialize(options)
    require 'octokit'

    @options = options

    Octokit.auto_paginate = true
    @github_client = Octokit::Client.new(:access_token => options.github_token)

    if @options.repo
      @forked_repos = { options.repo => options.config[options.repo] }
    else
      @forked_repos = options.config
    end
  end

  def list(options)
    repo_list = options.config.keys

    if repo_list.empty?
      puts "No repositories found in '#{options.config_file}'"
    else
      puts "Repos in '#{options.config_file}'"
      puts %(  * #{repo_list.sort.join("\n  * ")})
    end
  end

  def get_github_forks(org)
    fail('Error: You must specify an org to scan for forked repos') unless org

    require 'octokit'
  end

  def sync(options)
    require 'tmpdir'

    line_sep = %(\n#{'='*20}\n)

    @forked_repos.keys.sort.each do |repo_name|
      repo = @github_client.repo(repo_name)

      if repo[:fork]
        Dir.mktmpdir do |tmpdir|
          Dir.chdir tmpdir do
            begin

              puts line_sep

              puts "Processing #{repo_name}...\n\n"

              %x(git clone #{repo[:ssh_url]} >& /dev/null)

              Dir.chdir repo[:name] do
                remote_url = repo[:parent][:html_url]

                %x(git remote add vendor #{remote_url} >& /dev/null)
                %x(git fetch --all >& /dev/null)
                %x(git fetch --tags >& /dev/null)

                branches = @forked_repos[repo_name]['branches']
                if !branches || branches.empty?
                  branches = @github_client.branches(repo_name).map{|x| x = x[:name]}
                end

                branches.each do |branch|
                  %x(git checkout vendor/#{branch} >& /dev/null)
                  %x(git checkout #{branch} >& /dev/null)
                  %x(git pull --ff-only vendor #{branch} >& /dev/null)

                  if $?.success?
                    $stdout.puts("Updated #{branch} from #{remote_url}")
                  else
                    $stderr.puts("WARNING: Could not fast forward branch #{branch} from #{remote_url}")
                    next
                  end

                  %x(git push origin HEAD:#{branch})
                end

                if @forked_repos[repo_name]['tags']
                  %x(git push origin --tags >& /dev/null)
                end

                puts line_sep
              end

            rescue StandardError => e
              $stderr.puts("Error: Failure updating #{repo_name}: #{e}")
            end
          end
        end
      end
    end
  end
end
