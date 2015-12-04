require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "app/features --require app/features/support/ --require app/features/step_definitions --format pretty"
end
