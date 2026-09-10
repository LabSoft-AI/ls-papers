# Subagent Strategy Guide

## What Are Subagents?

Subagents are temporary, specialized agents spawned during a conversation to handle specific subtasks. They run with isolated context and can execute in parallel (up to 4 simultaneously).

## Subagents vs Custom Agents

| Aspect | Custom Agents | Subagents |
|--------|--------------|-----------|
| Lifecycle | Persistent, user switches between them | Temporary, spawned for specific tasks |
| Context | Maintains conversation history | Isolated context per invocation |
| Usage | Interactive chat sessions | Programmatic delegation |
| Configuration | JSON files in `.kiro/agents/` | Invoked via `use_subagent` tool |

## When to Use Subagents

### ✅ Good Use Cases

1. **Parallel independent tasks**
   - Analyzing multiple services simultaneously
   - Running tests while generating documentation
   - Checking different parts of codebase in parallel

2. **Complex multi-step workflows**
   - Step 1: Subagent analyzes requirements
   - Step 2: Subagent designs architecture
   - Step 3: Subagent implements code
   - Step 4: Subagent writes tests

3. **Specialized analysis without context pollution**
   - Deep AWS infrastructure audit (delegate to `ls-infra`)
   - Security review (delegate to security specialist)
   - Performance analysis (delegate to performance expert)

4. **Auxiliary tasks**
   - Fetching external documentation
   - Running background checks
   - Gathering system information

5. **Breaking cognitive load**
   - Main agent coordinates high-level strategy
   - Subagents handle detailed implementation
   - Prevents overwhelming single conversation context

### ❌ When NOT to Use Subagents

1. **Simple, single-step tasks** - Just do it directly
2. **Tasks requiring conversation continuity** - Use main agent
3. **Dependent sequential tasks** - Spawn subagents sequentially, not in parallel
4. **Interactive user guidance** - Main agent should handle this

## Subagent Invocation Patterns

### Pattern 1: Parallel Analysis
```json
{
  "command": "InvokeSubagents",
  "content": {
    "subagents": [
      {
        "query": "Analyze Lambda functions for performance issues",
        "agent_name": "ls-infra",
        "relevant_context": "Focus on cold starts and memory usage"
      },
      {
        "query": "Review DynamoDB table designs",
        "agent_name": "ls-infra",
        "relevant_context": "Check partition key distribution"
      },
      {
        "query": "Audit S3 bucket policies",
        "agent_name": "ls-infra",
        "relevant_context": "Security and access control"
      }
    ]
  }
}
```

### Pattern 2: Sequential Delegation
```json
// First subagent
{
  "command": "InvokeSubagents",
  "content": {
    "subagents": [
      {
        "query": "Design API schema for user service",
        "agent_name": "ls-software-architect"
      }
    ]
  }
}

// Wait for result, then spawn next
{
  "command": "InvokeSubagents",
  "content": {
    "subagents": [
      {
        "query": "Implement the API based on this schema: [schema]",
        "agent_name": "ls-tdd-bdd-developer"
      }
    ]
  }
}
```

### Pattern 3: Specialized Deep Dive
```json
{
  "command": "InvokeSubagents",
  "content": {
    "subagents": [
      {
        "query": "Perform comprehensive bash script audit for security vulnerabilities",
        "agent_name": "ls-git",
        "relevant_context": "Check scripts in ./scripts/ directory"
      }
    ]
  }
}
```

## Building Agents That Use Subagents

When creating an agent that will coordinate subagents:

### Required Tool Access
```json
{
  "tools": ["use_subagent", "fs_read", "grep"],
  "allowedTools": ["fs_read", "grep"]
}
```

### Coordinator Agent Pattern
```json
{
  "name": "ls-project-coordinator",
  "description": "Coordinates complex multi-agent workflows",
  "prompt": "You coordinate complex tasks by delegating to specialized subagents. Break down user requests into parallel or sequential subtasks and invoke appropriate agents.",
  "tools": ["*"],
  "allowedTools": ["fs_read", "grep", "glob", "use_subagent"],
  "resources": [
    "file://README.md",
    "file://.kiro/agents/**/*.json"
  ]
}
```

## Complexity Breakdown Decision Tree

```
User Request
    |
    ├─ Single domain? ────────────────────────────────┐
    │   └─ Use specialized agent directly              │
    │                                                   │
    ├─ Multiple independent domains? ──────────────────┤
    │   └─ Spawn parallel subagents                    │
    │                                                   │
    ├─ Sequential dependencies? ───────────────────────┤
    │   └─ Spawn subagents sequentially                │
    │                                                   │
    ├─ Deep analysis + implementation? ────────────────┤
    │   └─ Analysis subagent → Implementation subagent │
    │                                                   │
    └─ Simple task? ───────────────────────────────────┘
        └─ Handle directly, no subagents needed
```

## Best Practices

1. **Clear delegation**: Provide specific, focused queries to subagents
2. **Relevant context**: Include necessary context but keep it minimal
3. **Agent selection**: Choose the right specialized agent for each subtask
4. **Parallel when possible**: Spawn independent tasks together
5. **Sequential when dependent**: Wait for results before spawning dependent tasks
6. **Aggregate results**: Main agent synthesizes subagent outputs
7. **Error handling**: Check subagent results and retry if needed

## Example: Complex Migration Project

Main agent receives: "Migrate our monolith to microservices"

**Breakdown:**
1. **Parallel Phase 1** (Analysis):
   - Subagent 1: Analyze current architecture (`ls-software-architect`)
   - Subagent 2: Identify domain boundaries (`ls-software-architect`)
   - Subagent 3: Review infrastructure requirements (`ls-infra`)

2. **Sequential Phase 2** (Design):
   - Subagent: Design microservice architecture based on analysis

3. **Parallel Phase 3** (Implementation):
   - Subagent 1: Implement user service (`ls-tdd-bdd-developer`)
   - Subagent 2: Implement order service (`ls-tdd-bdd-developer`)
   - Subagent 3: Set up infrastructure (`ls-infra`)

4. **Sequential Phase 4** (Migration):
   - Subagent: Create migration plan (manual)

## Listing Available Agents

Before delegating, check available agents:
```json
{
  "command": "ListAgents"
}
```

This returns all configured agents and their capabilities, helping you choose the right subagent for each task.

## Anti-Patterns to Avoid

❌ **Over-delegation**: Spawning subagents for trivial tasks
❌ **Context dumping**: Passing entire conversation history to subagents
❌ **Parallel dependencies**: Spawning dependent tasks in parallel
❌ **No aggregation**: Not synthesizing subagent results
❌ **Wrong agent**: Using generic agent when specialist exists
