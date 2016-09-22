begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

default_tasks = []

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "-fd"
  end
  default_tasks << :spec
rescue LoadError
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
  end
  default_tasks << :features
rescue LoadError
end

begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['app/controllers/**/*.rb','app/helpers/**/*.rb', 'app/mailers/**/*.rb', 'app/models/**/*.rb', 'lib/**/*.rb']
    t.options = []
    t.options << '--debug' << '--verbose' if $trace
  end
  default_tasks << :yard
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  default_tasks << :rubocop
rescue LoadError
end

desc 'Generate docs'
task :docs do
  system 'rm -rf docs'
  system 'rspec spec -fh -o docs/rspec/index.html'
  system 'mv coverage docs'
  system 'mkdir -p docs/cucumber/'
  system 'cucumber features -f html -o docs/cucumber/index.html'
  system 'yardoc -o docs/yard'
  system 'rubocop -fh -o docs/rubocop/index.html'
end

task default: default_tasks

