# frozen_string_literal: true

require 'rails/railtie'

module ClaudeOnRails
  # Railtie to load rake tasks in Rails applications
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/claude_on_rails.rake', __dir__)
    end
  end
end
