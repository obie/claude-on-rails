# ClaudeOnRails Setup Guide

This guide covers the complete setup process for ClaudeOnRails, including the optional Rails MCP Server integration.

## Quick Start

```bash
# Add to your Gemfile
gem 'claude-on-rails', group: :development

# Install the gem
bundle install

# Generate swarm configuration (includes optional MCP setup)
rails generate claude_on_rails:swarm
# Press Y when prompted to set up Rails MCP Server!

# Start your AI development team
claude-swarm
```

## Enhanced Setup with Rails MCP Server

Rails MCP Server provides your AI agents with real-time access to Rails documentation. While optional, it significantly improves the quality and accuracy of generated code.

### Automated Setup

The easiest way is during initial generation - just press Y when prompted!

If you skipped it or want to set it up later:

```bash
bundle exec rake claude_on_rails:setup_mcp
```

This interactive command will:
- Install the Rails MCP Server gem globally
- Configure your environment for enhanced documentation access

### Manual Setup

If you prefer manual installation:

1. **Install Rails MCP Server**
   ```bash
   gem install rails-mcp-server
   ```

2. **Regenerate Swarm Configuration**
   ```bash
   rails generate claude_on_rails:swarm
   ```

### Checking MCP Status

To verify your Rails MCP Server setup:

```bash
bundle exec rake claude_on_rails:mcp_status
```

This shows:
- Installation status
- Downloaded resources
- Missing resources

## Configuration Options

### Generator Options

```bash
# Skip MCP Server integration
rails generate claude_on_rails:swarm --no-mcp-server

# API-only application
rails generate claude_on_rails:swarm --api-only

# Skip test agent
rails generate claude_on_rails:swarm --skip-tests

# Include GraphQL support
rails generate claude_on_rails:swarm --graphql
```

## Troubleshooting

### Rails MCP Server Not Found

If the generator doesn't detect Rails MCP Server:

1. Verify installation: `gem list rails-mcp-server`
2. Check PATH: `which rails-mcp-server`
3. Reinstall: `gem install rails-mcp-server`

### Documentation Access

The Rails MCP Server gem includes built-in documentation for:
- Rails framework and guides
- Turbo and Stimulus frameworks
- Kamal deployment tool

No separate download steps are required!

### Multiple Rails Projects

MCP Server resources are shared globally, benefiting all your Rails projects:

```bash
# Install once
bundle exec rake claude_on_rails:setup_mcp

# Use in any Rails project
cd my-rails-app
rails generate claude_on_rails:swarm
```

## Getting Help

- Check status: `bundle exec rake claude_on_rails:mcp_status`
- View logs: `claude-swarm.log`
- Report issues: [GitHub Issues](https://github.com/obie/claude-on-rails/issues)
- Documentation: [README.md](./README.md)

## Next Steps

After setup:

1. Review generated `claude-swarm.yml`
2. Customize agent prompts in `.claude-on-rails/prompts/`
3. Start building with `claude-swarm`
4. Describe features in natural language
5. Let your AI team implement them!
