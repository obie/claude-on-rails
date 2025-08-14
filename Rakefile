# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# RSpec task
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop_ci)

task ci: %i[spec rubocop_ci]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--autocorrect']
end

task default: %i[spec rubocop]
