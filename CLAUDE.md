# ClaudeOnRails Development

## Project Overview

ClaudeOnRails is a Ruby gem that leverages claude-swarm to create intelligent AI agent teams for Rails development. It generates swarm configurations that allow developers to describe what they want to build in natural language, and the swarm coordinates implementation across all Rails layers.

## Guidelines

### 1. File References in Claude
- Use `@filepath` syntax for file references, not `/file:filepath`
- File references are the preferred way to include content without duplicating it

### 2. Never Overwrite User Configuration
- Always check if CLAUDE.md exists before writing to it
- Use file references to include framework content rather than appending
- Store framework-specific content in separate files (e.g., `.claude-on-rails/context.md`)

### 3. Claude-Swarm Integration
- The default configuration file is `claude-swarm.yml`, not `swarm.yml`
- Command is simply `claude-swarm`, not `claude-swarm orchestrate`
- claude-swarm is a dependency, so no need to tell users to install it separately

### 4. Documentation Clarity
- Clearly distinguish between shell commands and Claude prompts
- Use `>` prefix for Claude prompts to avoid confusion with bash commands
- Be explicit about where commands should be run vs where prompts should be typed

### 5. Ruby Gem Best Practices
- Keep development dependencies in Gemfile, not gemspec (RuboCop rule)
- Always run `bundle exec rake` before committing changes to catch syntax and style issues
- Use `bundle exec rake release` for gem releases (creates tag, pushes to RubyGems)
- ...then create GitHub releases separately with `gh release create`

### 6. Generator Best Practices
- Check for directory existence before creating agents
- Make generators idempotent (running multiple times shouldn't duplicate content)
- Provide clear next steps after generation
- Show what will be created during the analysis phase

### 7. Testing Considerations
- Make sure that user confirms that they have tested changes with a real Rails project before releasing
- Consider different Rails configurations (API-only, full-stack, with/without GraphQL)
- **IMPORTANT**: This project uses RSpec exclusively for testing. NEVER use Minitest or any other testing framework. Do not add minitest gems, create test/ directories, or write any Minitest-style tests. All tests must be written in RSpec format and placed in the spec/ directory.

## Workflow Guidance

- For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
- When you're tempted to respond and return control to me with a message like "The codebase is now in excellent shape with 859 passing tests, 1 failing test, and 5 pending tests. The project is ready for the v0.2.0 release once the team decides how to handle the final test (either fix it or mark it as pending)." then instead, you should  decide how to handle the final test _first_.

## Release Guidance

- Note that releases are never ready if there are any tests failing in the test suites. Never tell me that a release is ready unless we have a clean build.

## Architecture Notes

- The gem analyzes Rails projects to detect patterns and frameworks
- It generates customized swarm configurations based on project structure
- Each agent works in a specific directory (MVC separation)
- Agents communicate via MCP protocol in claude-swarm
