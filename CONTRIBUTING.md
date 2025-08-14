# Contributing to ClaudeOnRails

We love your input! We want to make contributing to ClaudeOnRails as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [Github Flow](https://guides.github.com/introduction/flow/index.html)

Pull requests are the best way to propose changes to the codebase:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project.

## Report bugs using Github's [issues](https://github.com/obie/claude-on-rails/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/obie/claude-on-rails/issues/new).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/obie/claude-on-rails.git
   cd claude-on-rails
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Run tests:
   ```bash
   bundle exec rspec
   ```

4. Run linting:
   ```bash
   bundle exec rubocop
   ```

## Testing Your Changes

Before submitting a PR, test your changes in a real Rails project:

1. Create a test Rails app:
   ```bash
   rails new test_app
   cd test_app
   ```

2. Add your local gem:
   ```ruby
   # Gemfile
   gem 'claude-on-rails', path: '/path/to/your/claude-on-rails'
   ```

3. Run the generator:
   ```bash
   bundle install
   rails generate claude_on_rails:swarm
   ```

4. Verify the generated files work correctly

## Code Style

We use RuboCop with Rails-specific cops. Please ensure your code passes linting:

```bash
bundle exec rubocop
```

To auto-fix issues:
```bash
bundle exec rubocop -a
```

## Adding New Agent Types

If you want to add a new specialized agent:

1. Add detection logic to `ProjectAnalyzer`
2. Update `SwarmBuilder` to include the new agent
3. Create a prompt template in `lib/generators/claude_on_rails/swarm/templates/prompts/`
4. Update the generator to handle the new agent type
5. Add tests for your changes

Example:
```ruby
# In project_analyzer.rb
def has_action_cable?
  File.exist?(File.join(root_path, 'app', 'channels'))
end

# In swarm_builder.rb
if project_analysis[:has_action_cable]
  instances[:channels] = build_channels_agent
end
```

## Improving Agent Prompts

Agent prompts are crucial for swarm effectiveness. When improving prompts:

1. Keep them focused on their specific domain
2. Include Rails best practices
3. Add examples of good patterns
4. Specify what they should NOT do
5. Test with real-world scenarios

## Documentation

- Update README.md for user-facing changes
- Add examples to the examples/ directory
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)
- Use YARD format for code documentation

## Pull Request Process

1. Update the README.md with details of changes to the interface
2. Update the CHANGELOG.md with your changes
3. The PR will be merged once you have the sign-off of at least one maintainer

## Questions?

Feel free to open an issue for any questions about contributing!