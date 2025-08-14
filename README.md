# ClaudeOnRails

[![Gem Version](https://badge.fury.io/rb/claude-on-rails.svg?cache_bust=0.1.4)](https://badge.fury.io/rb/claude-on-rails)
[![CI](https://github.com/obie/claude-on-rails/actions/workflows/main.yml/badge.svg)](https://github.com/obie/claude-on-rails/actions/workflows/main.yml)


A Rails development framework that leverages [claude-swarm](https://github.com/parruda/claude-swarm) to create an intelligent team of AI agents specialized in different aspects of Rails development.

Instead of managing personas manually, ClaudeOnRails automatically orchestrates a swarm of specialized agents that work together like a real development team. Simply describe what you want to build, and the swarm handles the rest.

## How It Works

ClaudeOnRails creates a team of specialized AI agents:

- **Architect**: Coordinates development and makes high-level decisions
- **Models**: Handles ActiveRecord, migrations, and database design
- **Controllers**: Manages routing and request handling
- **Views**: Creates UI templates and manages assets
- **Services**: Implements business logic and service objects
- **Tests**: Ensures comprehensive test coverage
- **DevOps**: Handles deployment and infrastructure
- **Git**: Manages version control and collaboration (when Git repository is detected)

Each agent works in their specific domain (directory) and can collaborate with other agents to implement complex features.

## Installation

Add to your Rails application's Gemfile:

```ruby
group :development do
  gem 'claude-on-rails'
end
```

Then run:

```bash
bundle install
rails generate claude_on_rails:swarm
```

During generation, you'll be offered to set up Rails MCP Server for enhanced documentation access. Simply press Y when prompted!

This will:
- Analyze your Rails project structure
- Optionally set up Rails MCP Server (recommended)
- Generate a customized swarm configuration
- Create agent-specific prompts
- Set up your development environment

For detailed setup instructions, see [SETUP.md](./SETUP.md).

## Usage

### Start Your Development Swarm

```bash
# In your Rails project directory
claude-swarm
```

### Natural Language Development

Once the swarm is running, just describe what you want to build in the Claude interface:

```
> Add user authentication with email confirmation
[The architect coordinates the implementation across all agents]

> Create a shopping cart with Stripe payment integration
[Complex features are automatically broken down and implemented]

> Optimize the dashboard - it's loading too slowly
[Performance improvements across the stack]

> Build a RESTful API for our mobile app with JWT auth
[API development with authentication]

> Commit these changes and create a release branch for v2.0

> Review the commit history for the user model changes
```

The swarm automatically:
- Analyzes your request
- Delegates to appropriate specialists
- Implements across all layers (models, controllers, views, tests)
- Follows Rails best practices
- Ensures test coverage

## How It's Different

### Traditional Rails Development with AI
When using AI assistants for Rails development, you typically need to:
- Manually coordinate different aspects of implementation
- Switch contexts between models, controllers, views, and tests
- Ensure consistency across different parts of your application
- Remember to implement tests, security, and performance considerations

### ClaudeOnRails Approach
With ClaudeOnRails, you simply describe what you want in natural language:
```
> Create a user system with social login
```

The swarm automatically:
- Creates models with proper validations and associations
- Implements controllers with authentication logic
- Builds views with forms and UI components
- Adds comprehensive test coverage
- Handles security considerations
- Optimizes database queries

All coordinated by specialized agents working together.

## Project Structure

After running the generator, you'll have:

```
your-rails-app/
├── claude-swarm.yml             # Swarm configuration
├── CLAUDE.md                    # Project-specific Claude config (imports context.md)
└── .claude-on-rails/
    ├── context.md               # Rails project context imported by CLAUDE.md
    └── prompts/                 # Agent-specific prompts
        ├── architect.md
        ├── models.md
        ├── controllers.md
        └── ...
```

## Customization

### Swarm Configuration

The generated `claude-swarm.yml` can be customized:

```yaml
instances:
  architect:
    description: "Your project-specific architect description"
    connections: [models, controllers, custom_agent]

  custom_agent:
    description: "Specialized agent for your domain"
    directory: ./app/custom
    prompt_file: .claude-on-rails/prompts/custom.md
```

### Agent Prompts

Customize agent behavior by editing prompts in `.claude-on-rails/prompts/`:
- Add project-specific conventions
- Include domain knowledge
- Define coding standards

## Features

- **Automatic Agent Selection**: No need to choose which persona to use
- **Collaborative Implementation**: Agents work together like a real team
- **Rails-Aware**: Deep understanding of Rails conventions and best practices
- **Project Adaptation**: Detects your project structure and adapts accordingly
- **Test-Driven**: Automatic test generation for all code
- **Performance Focus**: Built-in optimization capabilities

## Enhanced Documentation with Rails MCP Server

ClaudeOnRails integrates with [Rails MCP Server](https://github.com/maquina-app/rails-mcp-server) to provide your AI agents with real-time access to Rails documentation and best practices.

### Benefits

- **Up-to-date Documentation**: Agents access current Rails guides matching your version
- **Framework Resources**: Includes Turbo, Stimulus, and Kamal documentation
- **Consistent Standards**: All agents share the same documentation source
- **Reduced Hallucination**: Agents verify patterns against official documentation

### Automated Setup

When you run `rails generate claude_on_rails:swarm`, you'll be prompted to set up Rails MCP Server automatically. Just press Y!

If you skipped it initially, you can set it up anytime:

```bash
bundle exec rake claude_on_rails:setup_mcp
```

This interactive command will:
- Install the Rails MCP Server gem
- Configure your environment for enhanced documentation access

### Check Status

To verify your Rails MCP Server installation:

```bash
bundle exec rake claude_on_rails:mcp_status
```

### How It Works

When Rails MCP Server is available:
- Each agent can query Rails documentation in real-time
- Version-specific guidance ensures compatibility
- Agents reference canonical implementations
- Complex features follow official patterns

## Git Repository Management

When your Rails project is a Git repository, ClaudeOnRails automatically includes a Git specialist agent that can help with:

- **Version Control**: Commit changes, create branches, manage repository history
- **Code Reviews**: Analyze diffs, review commit history, and track changes
- **Branch Management**: Implement Git flow patterns, manage feature branches
- **Collaboration**: Support team workflows and best practices
- **Release Management**: Tag releases and coordinate deployment branches

The Git agent uses standard Git commands through the Bash tool and follows established Git best practices and workflows.


## Requirements

- Ruby 2.7+
- Rails 6.0+
- [claude-swarm](https://github.com/parruda/claude-swarm) gem (automatically installed as a dependency)
- Claude Code CLI

## Examples

See the [examples](./examples) directory for:
- E-commerce platform development
- API-only applications
- Real-time features with Turbo/Stimulus
- Performance optimization workflows

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Acknowledgments

- Powered by [claude-swarm](https://github.com/parruda/claude-swarm)
- Built for [Claude Code](https://github.com/anthropics/claude-code)
- Integrates with [Rails MCP Server](https://github.com/maquina-app/rails-mcp-server)
