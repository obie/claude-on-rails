# frozen_string_literal: true

require 'rails/generators/base'
require 'claude_on_rails'

module ClaudeOnRails
  module Generators
    class SwarmGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :api_only, type: :boolean, default: false,
                              desc: 'Generate swarm for API-only Rails application'

      class_option :skip_tests, type: :boolean, default: false,
                                desc: 'Skip test agent in swarm configuration'

      class_option :graphql, type: :boolean, default: false,
                             desc: 'Include GraphQL specialist agent'

      class_option :turbo, type: :boolean, default: true,
                           desc: 'Include Turbo/Stimulus specialist agents'

      class_option :mcp_server, type: :boolean, default: true,
                                desc: 'Include Rails MCP Server for enhanced documentation access'

      class_option :dev_mcp, type: :boolean, default: true,
                             desc: 'Include Rails Dev MCP Server for development server management'

      def analyze_project
        say 'Analyzing Rails project structure...', :green
        @project_analysis = ClaudeOnRails.analyze_project(Rails.root)

        # Auto-detect features
        @api_only = options[:api_only] || @project_analysis[:api_only]
        @has_graphql = options[:graphql] || @project_analysis[:has_graphql]
        @has_turbo = options[:turbo] && !@api_only
        @skip_tests = options[:skip_tests]
        @test_framework = @project_analysis[:test_framework]

        # Check for Rails MCP Server
        @include_mcp_server = options[:mcp_server] && ClaudeOnRails::MCPSupport.available?

        # Check for Rails Dev MCP
        @include_dev_mcp = options[:dev_mcp] && check_rails_dev_mcp_availability

        # Check for Git repository
        @has_git = @project_analysis[:has_git]

        say "Project type: #{@api_only ? 'API-only' : 'Full-stack Rails'}", :cyan
        say "Test framework: #{@test_framework}", :cyan if @test_framework
        say "GraphQL detected: #{@has_graphql ? 'Yes' : 'No'}", :cyan
        say "Rails MCP Server: #{@include_mcp_server ? 'Available' : 'Not available'}", :cyan
        say "Rails Dev MCP: #{@include_dev_mcp ? 'Available' : 'Not available'}", :cyan
        say "Git repository: #{@has_git ? 'Yes' : 'No'}", :cyan

        # Offer MCP setup if enabled but not available
        offer_mcp_setup if options[:mcp_server] && !@include_mcp_server

        # Show which agents will be created
        say "\nAgents to be created:", :yellow
        agents.each do |agent|
          say "  - #{agent}", :cyan
        end
      end

      def create_swarm_config
        say 'Generating swarm configuration...', :green
        template 'swarm.yml.erb', 'claude-swarm.yml'
      end

      def create_claude_md
        # Always create the ClaudeOnRails context file
        template 'claude_on_rails_context.md', '.claude-on-rails/context.md'

        if File.exist?('CLAUDE.md')
          say 'CLAUDE.md already exists - adding ClaudeOnRails file reference...', :yellow

          existing_content = File.read('CLAUDE.md')

          # Check if file reference already exists
          if existing_content.include?('.claude-on-rails/context.md')
            say '✓ CLAUDE.md already references ClaudeOnRails context', :green
          else
            file_reference = "\n/file:.claude-on-rails/context.md\n"
            append_to_file 'CLAUDE.md', file_reference
            say '✓ Added ClaudeOnRails context reference to existing CLAUDE.md', :green
          end
        else
          say 'Creating CLAUDE.md configuration...', :green
          template 'CLAUDE.md.erb', 'CLAUDE.md'
        end
      end

      def create_agent_prompts
        say 'Setting up agent-specific prompts...', :green

        dest_dir = '.claude-on-rails/prompts'
        empty_directory dest_dir

        Dir[File.join(self.class.source_root, 'prompts', '*')].each do |source_path|
          filename = File.basename(source_path)
          relative_source = File.join('prompts', filename)
          destination_filename = filename.sub(/\.erb\z/, '')
          destination_path = File.join(dest_dir, destination_filename)

          if filename.end_with?('.erb')
            template relative_source, destination_path
          else
            copy_file relative_source, destination_path
          end
        end
      end

      def update_gitignore
        say 'Updating .gitignore...', :green
        gitignore_path = Rails.root.join('.gitignore')

        # Create .gitignore if it doesn't exist
        create_file '.gitignore', '' unless File.exist?(gitignore_path)

        append_to_file '.gitignore', "\n# ClaudeOnRails\n.claude-on-rails/sessions/\n.claude-swarm/\nclaude-swarm.log\n"
      end

      def display_next_steps
        say "\n✅ ClaudeOnRails swarm configuration created!", :green
        say "\nNext steps:", :yellow

        # Remove this section since we now handle it interactively in analyze_project

        say '1. Review and customize claude-swarm.yml for your project'
        say '2. Start your Rails development swarm:'
        say '   claude-swarm', :cyan
        say "\nOnce the swarm is running, just describe what you want to build:"
        say '   > Add user authentication with social login', :cyan
        say "\nThe swarm will automatically coordinate the implementation across all layers!"
      end

      private

      def agents
        @agents ||= build_agent_list
      end

      def build_agent_list
        list = ['architect']
        list << 'models' if File.directory?(Rails.root.join('app/models'))
        list << 'controllers' if File.directory?(Rails.root.join('app/controllers'))
        list << 'views' if !@api_only && File.directory?(Rails.root.join('app/views'))
        list << 'api' if @api_only && File.directory?(Rails.root.join('app/controllers/api'))
        list << 'graphql' if @has_graphql && File.directory?(Rails.root.join('app/graphql'))
        list << 'stimulus' if @has_turbo && File.directory?(Rails.root.join('app/javascript'))
        list << 'services' if File.directory?(Rails.root.join('app/services'))
        list << 'jobs' if File.directory?(Rails.root.join('app/jobs'))

        unless @skip_tests
          case @test_framework
          when 'RSpec'
            list << 'tests' if File.directory?(Rails.root.join('spec'))
          when 'Minitest'
            list << 'tests' if File.directory?(Rails.root.join('test'))
          end
        end

        list << 'devops' if File.directory?(Rails.root.join('config'))
        list << 'git' if @has_git
        list
      end

      def offer_mcp_setup
        say "\n🎯 Rails MCP Server Enhancement Available!", :yellow
        say "Rails MCP Server provides your AI agents with real-time Rails documentation.", :cyan

        if yes?("Would you like to set it up now? (Y/n)", :green)
          say "\nStarting Rails MCP Server setup...", :green
          system('bundle exec rake claude_on_rails:setup_mcp')

          # Re-check availability after setup
          @include_mcp_server = ClaudeOnRails::MCPSupport.available?

          if @include_mcp_server
            say "\n✓ Rails MCP Server is now available!", :green
          else
            say "\nSetup was not completed. Continuing without MCP Server.", :yellow
          end
        else
          say "\nYou can set it up later with: bundle exec rake claude_on_rails:setup_mcp", :cyan
        end
      end

      def check_rails_dev_mcp_availability
        system('gem list -i rails-dev-mcp > /dev/null 2>&1') ||
          system('which rails-dev-mcp > /dev/null 2>&1')
      rescue StandardError
        false
      end
    end
  end
end
