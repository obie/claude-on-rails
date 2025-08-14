# frozen_string_literal: true

module ClaudeOnRails
  # Support module for Rails MCP Server integration
  module MCPSupport
    class << self
      # Check if Rails MCP Server gem is available on the system
      def available?
        # Check if the gem is installed
        system('gem list -i rails-mcp-server > /dev/null 2>&1') ||
          # Also check if the executable is available
          system('which rails-mcp-server > /dev/null 2>&1')
      rescue StandardError
        false
      end

      # Check if a specific resource is downloaded
      def resource_available?(_resource_name)
        # Rails MCP Server includes all resources in the gem
        available?
      end

      # Get the MCP server configuration for swarm
      def server_config(rails_env = 'development')
        {
          name: 'rails',
          type: 'stdio',
          command: 'rails-mcp-server',
          args: [],
          env: { 'RAILS_ENV' => rails_env }
        }
      end

      # Check if we can download a resource (always true for gem-based server)
      def download_resource?(_resource_name)
        return false unless available?

        # Rails MCP Server doesn't require separate resource downloads
        # Documentation is built-in to the gem
        true
      end

      # Get available resources that can be downloaded
      def available_resources
        %w[rails turbo stimulus kamal]
      end

      # Check which resources are currently downloaded
      def downloaded_resources
        # All resources are included in the gem
        available? ? available_resources : []
      end

      # Check which resources are missing
      def missing_resources
        # No resources are missing if the gem is installed
        available? ? [] : available_resources
      end

      # Check if common resources are set up
      def common_resources_setup?
        # No separate resource setup needed
        available?
      end

      # Generate installation instructions
      def installation_instructions
        instructions = []

        unless available?
          instructions << "Install Rails MCP Server:"
          instructions << "  gem install rails-mcp-server --no-document"
          instructions << ""
        end

        instructions
      end
    end
  end
end
