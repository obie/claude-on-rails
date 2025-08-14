# ClaudeOnRails Examples

This directory contains examples of using ClaudeOnRails in different scenarios.

## Basic E-commerce Example

```bash
# In your Rails project
bundle add claude-on-rails --group development
rails generate claude_on_rails:swarm

# Start the swarm
claude-swarm
```

Once the swarm is running, in the Claude interface:
```
> Create a product catalog with categories and search
> Add a shopping cart that persists between sessions  
> Implement checkout with Stripe payment processing
> Add order history and tracking for customers
```

## API Development Example

```bash
# For an API-only Rails app
rails new my_api --api
cd my_api
bundle add claude-on-rails --group development
rails generate claude_on_rails:swarm

claude-swarm
```

Then in the Claude interface:
```
> Create a RESTful API for a task management system
> Add JWT authentication with refresh tokens
> Implement rate limiting per API key
> Add GraphQL endpoint for complex queries
```

## Performance Optimization Example

In an existing Rails app with performance issues:
```bash
claude-swarm
```

Then describe the performance issues:
```
> The dashboard is loading slowly with 500ms+ response times

The swarm will:
- Analyze database queries (Models agent)
- Optimize controller actions (Controllers agent)
- Implement caching strategies (Services agent)
- Add performance tests (Tests agent)

> Users report the search feature times out with large datasets
[Automatic optimization across the stack]
```

## Real-time Features Example

After starting the swarm:
```
> Add real-time notifications when users receive messages
> Create a live-updating dashboard with WebSocket updates
> Implement collaborative editing for documents
```

## Test-Driven Development Example

Building features test-first:
```
> Create a user registration system with email verification - write tests first

The swarm will:
1. Tests agent writes comprehensive specs
2. Models agent creates User model to pass tests
3. Controllers agent implements registration flow
4. Services agent handles email verification logic
5. Tests agent ensures 100% coverage
```

## Custom Agent Example

If your project has unique requirements, you can add custom agents:

```yaml
# claude-swarm.yml
instances:
  analytics:
    description: "Analytics and reporting specialist"
    directory: ./app/analytics
    model: claude-3-5-haiku-20250110
    allowed_tools: [Read, Edit, Write, Bash, Grep, Glob, LS]
    prompt_file: .claude-on-rails/prompts/analytics.md
    
  architect:
    connections: [models, controllers, analytics] # Add to connections
```

Then in Claude:
```
> Create a comprehensive analytics dashboard with export capabilities
```

## Debugging Workflow Example

When encountering errors:
```
> NoMethodError in ProductsController#show - undefined method 'category' for nil:NilClass

The swarm will:
- Identify the error location
- Trace through the code path
- Fix the nil check
- Add tests to prevent regression
- Suggest defensive programming practices
```

## Migration and Refactoring Example

For large-scale refactoring:
```
> Refactor our fat User model - it has 500+ lines and 30+ methods

Coordinated refactoring:
- Architect plans the refactoring strategy
- Services agent extracts business logic
- Models agent keeps data integrity
- Tests agent ensures nothing breaks
- All changes are incremental and safe
```

## Tips for Best Results

1. **Be specific about requirements**
   ```
   Good:
   > Create user authentication with email/password, remember me, and password reset
   
   Less effective:
   > Add login
   ```

2. **Provide context for complex features**
   ```
   > We're building a SaaS app. Add multi-tenant support with subdomain isolation
   ```

3. **Mention constraints or preferences**
   ```
   > Build an admin panel using our existing ViewComponent architecture
   ```

4. **Ask for specific approaches**
   ```
   > Implement caching using Redis for our product recommendations
   ```

Remember: The swarm works best when you describe what you want to achieve, not how to implement it. Let the specialized agents handle the implementation details!