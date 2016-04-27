# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Available Rake tasks:
#
# $ rake -T
# rake integration:docker[regexp,action]   # Run tests with kitchen-docker
# rake integration:vagrant[regexp,action]  # Run tests with kitchen-vagrant
#
# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc
#

require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'
require 'rspec/core/rake_task'

desc 'Run linting'
namespace :linting do
  desc 'Run FoodCritic linting'
  FoodCritic::Rake::LintTask.new(:foodcritic) do |task|
    task.options = {
      fail_tags: %w(~FC059)
    }
  end

  desc 'Run RuboCop linting'
  RuboCop::RakeTask.new(:rubocop) do |task|
    # Abort rake on failure
    task.fail_on_error = true
  end
end

desc 'Run rspec/chefspec'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--format documentation'
end

desc 'Run Test Kitchen integration tests'
namespace :integration do
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    return instances if regexp.nil? || regexp == 'all'
    instances.get_all(Regexp.new(regexp))
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }
    kitchen_instances(regexp, config).each { |i| i.send(action) }
  end

  desc 'Run integration tests with kitchen-vagrant'
  task :vagrant, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp)
  end

  desc 'Run integration tests with kitchen-docker'
  task :docker, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp, local_config: '.kitchen.docker.yml')
  end
end

task default: %w(linting:foodcritic linting:rubocop spec integration:docker)
task local_default: %w(linting:foodcritic linting:rubocop spec)

desc 'Release the software artifact'
task release: [:local_default] do
  date = Time.now.strftime('%Y-%m-%d')
  text = File.read('./metadata.rb')
  b = 1
  b += text.match(/version\D+(((?:\d+\.)+)(\d+))/)[3].to_i
  find = Regexp.last_match(1)
  new_version = "#{Regexp.last_match(2)}#{b}"
  text.gsub!(/#{find}/, new_version)
  name = text.match(/name\s*\S(.*)\S/)[1].to_s
  pr_title = `git log --merges --pretty=format:"%b" | grep -v '^$' | head -n 1`
  puts 'Rake Release: Updating CHANGELOG.md'
  original_file = './CHANGELOG.md'
  new_file = original_file + '.new'
  File.open(new_file, 'w') do |fo|
    fo << "#{new_version} (#{date})\n"
    fo << "-------------------\n"
    fo << "#{pr_title}\n"
    File.foreach(original_file) do |li|
      fo.puts li
    end
  end
  File.rename(new_file, original_file)
  puts "Rake Release: Updating version from #{find} to #{new_version}"
  File.open('./metadata.rb', 'w') { |file| file.puts text }
  sh('git', 'commit', './metadata.rb', './CHANGELOG.md', '-m', "'Version bump to #{new_version}'")
  sh('git', 'push')
  sh('git', 'tag', '-a', "v#{new_version}", '-m', "'rake released #{new_version}'")
  sh('git', 'push', '--tags')
  sh('berks', 'install')
  sh('berks', 'upload', name)
end
