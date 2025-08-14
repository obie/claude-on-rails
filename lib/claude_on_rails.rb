# frozen_string_literal: true

require 'claude_on_rails/version'
require 'claude_on_rails/configuration'
require 'claude_on_rails/project_analyzer'
require 'claude_on_rails/swarm_builder'
require 'claude_on_rails/mcp_support'

# Load railtie if Rails is defined
require 'claude_on_rails/railtie' if defined?(Rails::Railtie)

module ClaudeOnRails
  class Error < StandardError; end

  class << self
    def configure
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def analyze_project(root_path = Rails.root)
      ProjectAnalyzer.new(root_path).analyze
    end

    def build_swarm(project_analysis)
      SwarmBuilder.new(project_analysis).build
    end
  end
end
