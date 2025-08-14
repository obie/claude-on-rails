# frozen_string_literal: true

module ClaudeOnRails
  class SwarmBuilder
    attr_reader :project_analysis

    def initialize(project_analysis)
      @project_analysis = project_analysis
    end

    def build
      {
        version: 1,
        swarm: {
          name: 'Rails Development Team',
          main: 'architect',
          instances: build_instances
        }
      }
    end

    private

    def build_instances
      instances = {}

      # Always include architect
      instances[:architect] = build_architect

      # Core agents
      instances[:models] = build_models_agent
      instances[:controllers] = build_controllers_agent

      # Conditional agents
      instances[:views] = build_views_agent unless project_analysis[:api_only]

      instances[:api] = build_api_agent if project_analysis[:api_only]

      instances[:graphql] = build_graphql_agent if project_analysis[:has_graphql]

      instances[:stimulus] = build_stimulus_agent if project_analysis[:has_turbo] && !project_analysis[:api_only]

      # Supporting agents
      instances[:services] = build_services_agent
      instances[:jobs] = build_jobs_agent

      instances[:tests] = build_tests_agent if project_analysis[:test_framework]

      instances[:devops] = build_devops_agent

      instances
    end

    def build_architect
      connections = %w[models controllers]
      connections << 'views' unless project_analysis[:api_only]
      connections << 'api' if project_analysis[:api_only]
      connections << 'graphql' if project_analysis[:has_graphql]
      connections << 'services'
      connections << 'jobs'
      connections << 'tests' if project_analysis[:test_framework]
      connections << 'devops'

      {
        description: "Rails architect coordinating #{project_analysis[:api_only] ? 'API' : 'full-stack'} development",
        directory: '.',
        model: ClaudeOnRails.configuration.default_model,
        connections: connections,
        prompt_file: '.claude-on-rails/prompts/architect.md',
        vibe: ClaudeOnRails.configuration.vibe_mode
      }
    end

    def build_models_agent
      {
        description: 'ActiveRecord models, migrations, and database optimization specialist',
        directory: './app/models',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/models.md'
      }
    end

    def build_controllers_agent
      connections = ['services']
      connections << 'api' if project_analysis[:api_only]

      {
        description: 'Rails controllers, routing, and request handling specialist',
        directory: './app/controllers',
        model: ClaudeOnRails.configuration.default_model,
        connections: connections.empty? ? nil : connections,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/controllers.md'
      }.compact
    end

    def build_views_agent
      connections = []
      connections << 'stimulus' if project_analysis[:has_turbo]

      {
        description: 'Rails views, layouts, partials, and asset pipeline specialist',
        directory: './app/views',
        model: ClaudeOnRails.configuration.default_model,
        connections: connections.empty? ? nil : connections,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/views.md'
      }.compact
    end

    def build_api_agent
      {
        description: 'RESTful API design, serialization, and versioning specialist',
        directory: './app/controllers/api',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/api.md'
      }
    end

    def build_graphql_agent
      {
        description: 'GraphQL schema, resolvers, and mutations specialist',
        directory: './app/graphql',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/graphql.md'
      }
    end

    def build_stimulus_agent
      {
        description: 'Stimulus.js controllers and Turbo integration specialist',
        directory: './app/javascript',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/stimulus.md'
      }
    end

    def build_services_agent
      {
        description: 'Service objects, business logic, and design patterns specialist',
        directory: './app/services',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/services.md'
      }
    end

    def build_jobs_agent
      {
        description: 'Background jobs, ActiveJob, and async processing specialist',
        directory: './app/jobs',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/jobs.md'
      }
    end

    def build_tests_agent
      test_dir = project_analysis[:test_framework] == 'RSpec' ? './spec' : './test'

      {
        description: "#{project_analysis[:test_framework]} testing, factories, and test coverage specialist",
        directory: test_dir,
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/tests.md'
      }
    end

    def build_devops_agent
      {
        description: 'Deployment, Docker, CI/CD, and production configuration specialist',
        directory: './config',
        model: ClaudeOnRails.configuration.default_model,
        allowed_tools: %w[Read Edit Write Bash Grep Glob LS],
        prompt_file: '.claude-on-rails/prompts/devops.md'
      }
    end
  end
end
