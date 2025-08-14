# frozen_string_literal: true

module ClaudeOnRails
  class ProjectAnalyzer
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def analyze
      {
        api_only: api_only?,
        test_framework: detect_test_framework,
        has_graphql: graphql?,
        has_turbo: turbo?,
        has_devise: devise?,
        has_sidekiq: sidekiq?,
        has_git: git_repository?,
        javascript_framework: detect_javascript_framework,
        database: detect_database,
        deployment: detect_deployment_method,
        custom_patterns: detect_custom_patterns
      }
    end

    private

    def api_only?
      application_rb = File.join(root_path, 'config', 'application.rb')
      return false unless File.exist?(application_rb)

      File.read(application_rb).include?('config.api_only = true')
    end

    def detect_test_framework
      if File.exist?(File.join(root_path, 'spec'))
        'RSpec'
      elsif File.exist?(File.join(root_path, 'test'))
        'Minitest'
      end
    end

    def graphql?
      gemfile_path = File.join(root_path, 'Gemfile')
      return false unless File.exist?(gemfile_path)

      gemfile_content = File.read(gemfile_path)
      gemfile_content.include?('graphql') ||
        File.exist?(File.join(root_path, 'app', 'graphql'))
    end

    def turbo?
      gemfile_path = File.join(root_path, 'Gemfile')
      return false unless File.exist?(gemfile_path)

      gemfile_content = File.read(gemfile_path)
      gemfile_content.include?('turbo-rails') ||
        gemfile_content.include?('stimulus-rails') ||
        File.exist?(File.join(root_path, 'app', 'javascript', 'controllers'))
    end

    def devise?
      gemfile_path = File.join(root_path, 'Gemfile')
      return false unless File.exist?(gemfile_path)

      File.read(gemfile_path).include?('devise')
    end

    def sidekiq?
      gemfile_path = File.join(root_path, 'Gemfile')
      return false unless File.exist?(gemfile_path)

      File.read(gemfile_path).include?('sidekiq')
    end

    def git_repository?
      # Check if .git directory exists
      git_dir = File.join(root_path, '.git')
      return true if File.directory?(git_dir)

      # Check if we're in a Git repository (could be a subdirectory)
      Dir.chdir(root_path) { system('git rev-parse --git-dir > /dev/null 2>&1') }
    rescue StandardError
      false
    end

    def detect_javascript_framework
      package_json = File.join(root_path, 'package.json')
      return 'importmap' unless File.exist?(package_json)

      content = File.read(package_json)
      if content.include?('webpack')
        'webpack'
      elsif content.include?('esbuild')
        'esbuild'
      elsif content.include?('vite')
        'vite'
      else
        'importmap'
      end
    end

    def detect_database
      database_yml = File.join(root_path, 'config', 'database.yml')
      return 'sqlite3' unless File.exist?(database_yml)

      content = File.read(database_yml)
      if content.include?('postgresql')
        'postgresql'
      elsif content.include?('mysql2')
        'mysql'
      elsif content.include?('sqlite3')
        'sqlite3'
      else
        'unknown'
      end
    end

    def detect_deployment_method
      # Check for various deployment configurations
      return 'kubernetes' if File.exist?(File.join(root_path, 'k8s')) ||
                             File.exist?(File.join(root_path, 'kubernetes'))
      return 'docker' if File.exist?(File.join(root_path, 'Dockerfile'))
      return 'capistrano' if File.exist?(File.join(root_path, 'Capfile'))
      return 'heroku' if File.exist?(File.join(root_path, 'Procfile'))
      return 'kamal' if File.exist?(File.join(root_path, 'config', 'deploy.yml'))

      'unknown'
    end

    def detect_custom_patterns
      patterns = {}

      # Check for service objects
      patterns[:has_services] = true if File.directory?(File.join(root_path, 'app', 'services'))

      # Check for form objects
      patterns[:has_forms] = true if File.directory?(File.join(root_path, 'app', 'forms'))

      # Check for presenters/decorators
      if File.directory?(File.join(root_path, 'app', 'presenters')) ||
         File.directory?(File.join(root_path, 'app', 'decorators'))
        patterns[:has_presenters] = true
      end

      # Check for query objects
      patterns[:has_queries] = true if File.directory?(File.join(root_path, 'app', 'queries'))

      # Check for policies (authorization)
      patterns[:has_policies] = true if File.directory?(File.join(root_path, 'app', 'policies'))

      # Check for serializers
      patterns[:has_serializers] = true if File.directory?(File.join(root_path, 'app', 'serializers'))

      patterns
    end
  end
end
