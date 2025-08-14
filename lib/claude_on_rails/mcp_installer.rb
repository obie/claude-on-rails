# frozen_string_literal: true

module ClaudeOnRails
  # Interactive installer for Rails MCP Server
  class MCPInstaller
    def run
      puts "\e[32m🚀 ClaudeOnRails MCP Server Setup\e[0m"
      puts "\e[32m#{'=' * 50}\e[0m"

      if MCPSupport.available?
        puts "\e[32m✓ Rails MCP Server is already installed\e[0m"
      else
        handle_installation
      end

      puts "\n\e[32m✅ Setup complete!\e[0m"
      show_next_steps
    end

    private

    def handle_installation
      puts "\n\e[33mRails MCP Server provides your AI agents with:\e[0m"
      puts "\e[36m  • Real-time Rails documentation access\e[0m"
      puts "\e[36m  • Version-specific API references\e[0m"
      puts "\e[36m  • Framework guides (Turbo, Stimulus, Kamal)\e[0m"
      puts "\e[36m  • Best practices and examples\e[0m"

      if prompt_yes_no?("\nWould you like to install Rails MCP Server? (Y/n)")
        install_mcp_server
      else
        puts "\n\e[33mSkipping Rails MCP Server installation.\e[0m"
        puts "\e[36mYou can run 'bundle exec rake claude_on_rails:setup_mcp' later to set it up.\e[0m"
      end
    end

    def install_mcp_server
      puts "\n\e[32mInstalling Rails MCP Server globally...\e[0m"

      # Install without documentation to avoid RDoc conflicts
      if system('gem install rails-mcp-server --no-document')
        puts "\e[32m✓ Rails MCP Server installed successfully!\e[0m"
      else
        puts "\n\e[31m❌ Failed to install Rails MCP Server\e[0m"
        puts "\e[33mPlease try running manually:\e[0m"
        puts "\e[36m  gem install rails-mcp-server --no-document\e[0m"
        exit 1
      end
    end

    def show_next_steps
      puts "\n\e[33mNext steps:\e[0m"

      if MCPSupport.available?
        puts "\e[36m1. Run the swarm generator to update your configuration:\e[0m"
        puts "\e[36m   rails generate claude_on_rails:swarm\e[0m"
        puts "\n\e[36m2. Start your enhanced Rails development swarm:\e[0m"
        puts "\e[36m   claude-swarm\e[0m"
        puts "\n\e[32mYour AI agents now have access to Rails documentation! 🎉\e[0m"
      else
        puts "\e[36m1. Complete the MCP Server setup when ready:\e[0m"
        puts "\e[36m   bundle exec rake claude_on_rails:setup_mcp\e[0m"
        puts "\n\e[36m2. Then run the swarm generator:\e[0m"
        puts "\e[36m   rails generate claude_on_rails:swarm\e[0m"
      end

      puts "\n\e[36mFor more information:\e[0m"
      puts "\e[36m  • Check status: bundle exec rake claude_on_rails:mcp_status\e[0m"
      puts "\e[36m  • View documentation: https://github.com/obie/claude-on-rails\e[0m"
    end

    def prompt_yes_no?(question)
      print "\e[32m#{question} \e[0m"
      response = $stdin.gets.chomp.downcase
      response.empty? || response.start_with?('y')
    end
  end
end
