# ClaudeOnRails Context

This project uses ClaudeOnRails with a swarm of specialized agents for Rails development.

## Project Information
- **Rails Version**: <%= Rails.version %>
- **Ruby Version**: <%= RUBY_VERSION %>
- **Project Type**: <%= @api_only ? 'API-only' : 'Full-stack Rails' %>
- **Test Framework**: <%= @test_framework || 'Not detected' %>
<% if @has_graphql -%>
- **GraphQL**: Enabled
<% end -%>
<% if @has_turbo && !@api_only -%>
- **Turbo/Stimulus**: Enabled
<% end -%>

## Swarm Configuration

The claude-swarm.yml file defines specialized agents for different aspects of Rails development:
- Each agent has specific expertise and works in designated directories
- Agents collaborate to implement features across all layers
- The architect agent coordinates the team

## Development Guidelines

When working on this project:
- Follow Rails conventions and best practices
- Write tests for all new functionality
- Use strong parameters in controllers
- Keep models focused with single responsibilities
- Extract complex business logic to service objects
- Ensure proper database indexing for foreign keys and queries