require 'bundler'
Bundler::GemHelper.install_tasks

# Make a console, useful when working on tests
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'simple_bayes'" }
end
