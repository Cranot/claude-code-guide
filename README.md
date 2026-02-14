# The Complete Claude Code CLI Guide

[![Official Docs](https://img.shields.io/badge/Official_Docs-code.claude.com-blue)](https://code.claude.com/docs/en/overview) [![GitHub](https://img.shields.io/badge/GitHub-anthropics%2Fclaude--code-black)](https://github.com/anthropics/claude-code) [![NPM](https://img.shields.io/badge/NPM-@anthropic--ai%2Fclaude--code-red)](https://www.npmjs.com/package/@anthropic-ai/claude-code) [![Auto-Updated](https://img.shields.io/badge/Auto--Updated-Every%202%20Days-brightgreen)](#auto-update-pipeline)

**Quick Links:** [Get Started](#what-is-claude-code) · [Commands](#quick-reference) · [MCP Setup](https://code.claude.com/docs/en/mcp) · [Settings](https://code.claude.com/docs/en/settings) · [SDK](https://code.claude.com/docs/en/sdk) · [Changelog](#changelog)

> **🔄 Live Guide**: Auto-updated every 2 days from [official docs](https://code.claude.com/docs/en/overview), [GitHub releases](https://github.com/anthropics/claude-code/releases), and [Anthropic changelog](https://www.anthropic.com/changelog). See [update-log.md](./update-log.md).

> **🤖 For AI Agents**: Optimized for both humans and AI. `[OFFICIAL]` = from code.claude.com. `[COMMUNITY]` = observed patterns. `[EXPERIMENTAL]` = unverified.

---

## What is Claude Code?

**Claude Code is an agentic AI coding assistant that lives in your terminal.** It understands your codebase, edits files directly, runs commands, and helps you code faster through natural language conversation.

**Key Capabilities:**
- 💬 Natural language interface in your terminal
- 📝 Direct file editing and command execution
- 🔍 Full project context awareness
- 🔗 External integrations via MCP (Model Context Protocol)
- 🤖 Extensible via Skills, Hooks, and Plugins
- 🛡️ Sandboxed execution for security

**Installation:**
```bash
# Quick Install (macOS, Linux, WSL)
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Windows CMD
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd

# Alternative: Homebrew (macOS/Linux)
brew install --cask claude-code

# Alternative: WinGet (Windows)
winget install Anthropic.ClaudeCode

# Alternative: NPM (⚠️ Deprecated - use native install instead)
npm install -g @anthropic-ai/claude-code

claude --version  # Verify installation
```

**Official Documentation:** https://code.claude.com/docs/en/overview

---

## Contents

| Getting Started | Core Features | Practical Usage | Reference |
|-----------------|---------------|-----------------|-----------|
| [What is Claude Code?](#what-is-claude-code) | [Skills System](#skills-system) | [Development Workflows](#development-workflows) | [Security](#security-considerations) |
| [Core Concepts](#core-concepts) | [Built-in Commands](#built-in-commands) | [Tool Synergies](#tool-synergies) | [SDK Integration](#sdk-integration) |
| [Quick Start Guide](#quick-start-guide) | [Hooks System](#hooks-system) | [Examples Library](#examples-library) | [Troubleshooting](#troubleshooting) |
| [Quick Reference](#quick-reference) | [MCP Integration](#mcp-integration) | [Best Practices](#best-practices) | [Changelog](#changelog) |
| | [Sub-Agents](#sub-agents) | | [Auto-Update Pipeline](#auto-update-pipeline) |
| | [Agent Teams](#agent-teams) | | |
| | [Plugins](#plugins) | | |

---

## Quick Reference

### Essential Commands [OFFICIAL]

```bash
# Starting Claude Code
claude                    # Start interactive session
claude -p "task"          # Print mode (non-interactive)
claude --continue         # Continue last session
claude --resume <id>      # Resume specific session

# Session Management
/help                     # Show available commands
/exit                     # End session
/compact                  # Reduce context size
/compact [instructions]  # Compact conversation with optional focus instructions

# Background Tasks
/bashes                   # List background processes
/kill <id>               # Stop background process

# Discovery
/commands                 # List skills and commands
/hooks                   # Show configured hooks
/skills                  # List available Skills (NEW)
/plugin                  # Manage plugins
```

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference)

### CLI Flags Reference [OFFICIAL]

```bash
# Output Control
claude -p, --print "task"          # Print mode: non-interactive, prints result and exits
claude --output-format json         # Output format: text, json, or stream-json
claude --input-format text          # Input format: text or stream-json
claude --verbose                    # Enable verbose logging (full turn-by-turn output)

# Session Management
claude --continue                   # Continue from last session
claude --resume <session-id>        # Resume specific session by ID or name
claude --from-pr <pr>               # Resume session linked to GitHub PR number or URL [NEW]
claude --fork-session               # Create new session ID instead of reusing original
claude --session-id <uuid>          # Use specific session ID (must be valid UUID)

# Remote Sessions (claude.ai subscribers)
claude --remote "task"              # Create web session on claude.ai
claude --teleport                   # Resume web session in local terminal

# Debugging & Logging
claude --debug                      # Enable debug mode (with optional category filtering)
claude --debug "api,mcp"            # Debug specific categories
claude --debug "!statsig,!file"     # Exclude categories with !

# Model & Agent Configuration
claude --model <name>               # Specify model (sonnet, opus, haiku, or full name)
claude --fallback-model <name>      # Fallback model when default overloaded (print mode)
claude --agent <name>               # Specify custom agent (overrides settings)
claude --agents '<json>'            # Define custom subagents dynamically via JSON

# System Prompt Customization
claude --system-prompt "prompt"     # Replace entire default system prompt
claude --system-prompt-file <path>  # Replace with file contents (print mode only)
claude --append-system-prompt "..."  # Append to default system prompt
claude --append-system-prompt-file <path>  # Append file contents (print mode only)

# Tool & Permission Management
claude --tools "Bash,Read,Edit"     # Restrict built-in tools (use "" to disable all)
claude --allowedTools "Bash(git:*)" # Tools that execute without prompting
claude --disallowedTools "Edit"     # Tools removed from context
claude --permission-mode plan       # Begin in specified permission mode
claude --dangerously-skip-permissions  # Skip all permission prompts ⚠️
claude --allow-dangerously-skip-permissions  # Enable bypass option without activating [NEW]
claude --permission-prompt-tool <mcp-tool>  # MCP tool for permission prompts (non-interactive) [NEW]

# Budget & Execution Limits (print mode)
claude --max-budget-usd 5.00        # Maximum dollar amount for API calls
claude --max-turns 3                # Limit number of agentic turns
claude --json-schema '<schema>'     # Get validated JSON output matching schema (print mode) [NEW]

# Directory & Configuration
claude --add-dir ../apps ../lib     # Add additional working directories
claude --plugin-dir ./my-plugins    # Load plugins from directories
claude --settings ./settings.json   # Path to settings JSON file
claude --setting-sources user,project  # Comma-separated list of setting sources [NEW]
claude --mcp-config ./mcp.json      # Load MCP servers from JSON file
claude --strict-mcp-config          # Only use MCP servers from --mcp-config

# IDE & Browser Integration
claude --ide                        # Auto-connect to IDE on startup
claude --chrome                     # Enable Chrome browser integration
claude --no-chrome                  # Disable Chrome browser integration

# Agent Teams [NEW]
claude --teammate-mode in-process   # Teammates display in main terminal
claude --teammate-mode tmux         # Each teammate in own pane (requires tmux/iTerm2)
claude --teammate-mode auto         # Auto-detect (default)

# Setup & Maintenance
claude --init                       # Run Setup hooks and start interactive mode
claude --init-only                  # Run Setup hooks and exit (no interactive session)
claude --maintenance                # Run Setup hooks with maintenance trigger and exit

# Other Options
claude --disable-slash-commands     # Disable all skills and slash commands
claude --no-session-persistence     # Disable session persistence (print mode)
claude --betas interleaved-thinking # Beta headers for API requests
claude --include-partial-messages   # Include partial streaming events (with stream-json) [NEW]
```

**Common Flag Combinations:**

```bash
# One-off task with JSON output
claude --print "analyze this code" --output-format json

# Debug MCP and API issues
claude --debug "api,mcp"

# Resume session with specific model
claude --resume auth-refactor --model opus

# Non-interactive with budget limit (CI/CD)
claude -p --max-budget-usd 5.00 --output-format json "run tests"

# Custom subagents for specialized work
claude --agents '{"reviewer":{"description":"Code reviewer","prompt":"Review for bugs"}}'

# Remote session for claude.ai subscribers
claude --remote "fix the login bug"
```

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference)

### Core Tools [OFFICIAL]

| Tool | Purpose | Permission Required |
|------|---------|---------------------|
| **Read** | Read files, images, PDFs | No |
| **Write** | Create new files | Yes |
| **Edit** | Modify existing files | Yes |
| **Bash** | Execute shell commands | Yes |
| **Grep** | Search content with regex | No |
| **Glob** | Find files by pattern | No |
| **TodoWrite** | Task management | No |
| **Task** | Launch sub-agents | No |
| **WebFetch** | Fetch web content | Yes |
| **WebSearch** | Search the web | Yes |
| **NotebookEdit** | Edit Jupyter notebooks | Yes |
| **NotebookRead** | Read Jupyter notebooks | No |

**Source:** [Settings Reference](https://code.claude.com/docs/en/settings)

---

## Core Concepts

### 1. How Claude Code Works [OFFICIAL]

Claude Code operates through a **conversational interface** in your terminal:

```bash
# You describe what you want
$ claude
> "Add user authentication to the API"

# Claude Code:
1. Analyzes your codebase structure
2. Plans the implementation
3. Requests permission for file edits (first time)
4. Writes code directly to your files
5. Can run tests and verify changes
6. Creates git commits if requested
```

**Key Principles:**
- **Natural Language**: Just describe what you need - no special syntax
- **Direct Action**: Edits files and runs commands with your permission
- **Context Aware**: Understands your entire project structure
- **Incremental Trust**: Asks permission as needed for new operations
- **Scriptable**: Can be automated via SDK

**Source:** [Overview](https://code.claude.com/docs/en/overview)

### 2. Permission Model [OFFICIAL]

Claude Code uses an **incremental permission system** for safety:

```bash
# Permission Modes
"ask"    # Prompt for each use (default for new operations)
"allow"  # Permit without asking
"deny"   # Block completely

# Permission Priority [NEW v2.1.27]
# Content-level rules override tool-level rules
# Example: allow: ["Bash"], ask: ["Bash(rm *)"]
#   -> Bash is generally allowed, but "rm *" commands require confirmation

# Tools Requiring Permission
- Bash (command execution)
- Write/Edit/NotebookEdit (file modifications)
- WebFetch/WebSearch (network access)
- Skill (skills and custom commands)

# Tools Not Requiring Permission (Safe Operations)
- Read/NotebookRead (reading files)
- Grep/Glob (searching)
- TodoWrite (task tracking)
- Task (sub-agents)
```

**Configuring Permissions:**

Create `.claude/settings.json` in your project or `~/.claude/settings.json` globally:

```json
{
  "permissions": {
    "defaultMode": "ask",
    "allow": {
      "Bash": ["git status", "git diff", "git log", "npm test", "npm run*"],
      "Read": {},
      "Edit": {}
    },
    "deny": {
      "Write": ["*.env", ".env.*", ".git/*"],
      "Edit": ["*.env", ".env.*"]
    },
    "additionalDirectories": [
      "/path/to/other/project"
    ]
  }
}
```

**Source:** [Settings](https://code.claude.com/docs/en/settings)

### 3. Project Context - CLAUDE.md [COMMUNITY]

A **CLAUDE.md** file in your project root provides persistent context across sessions:

<details>
<summary><strong>Example CLAUDE.md file (click to expand)</strong></summary>

    # Project: My Application

    ## Critical Context (Read First)
    - Language: TypeScript + Node.js
    - Framework: Express + React
    - Database: PostgreSQL with Prisma ORM
    - Testing: Jest + React Testing Library

    ## Commands That Work
    npm run dev          # Start dev server (port 3000)
    npm test             # Run all tests
    npm run lint         # ESLint check
    npm run typecheck    # TypeScript validation
    npm run db:migrate   # Run Prisma migrations

    ## Important Patterns
    - All API routes in /src/routes - RESTful structure
    - Database queries use Prisma Client
    - Auth uses JWT tokens (implementation in /src/auth)
    - Frontend components in /src/components
    - API responses: {success: boolean, data: any, error?: string}

    ## Gotchas & What NOT to Do
    - DON'T modify /generated folder (auto-generated by Prisma)
    - DON'T commit .env files (use .env.example instead)
    - ALWAYS run npm run db:migrate after pulling schema changes
    - DON'T use `any` type in TypeScript - use proper typing

    ## File Structure
    /src
      /routes       # Express API routes
      /services     # Business logic
      /models       # Type definitions
      /middleware   # Express middleware
      /utils        # Shared utilities
      /auth         # Authentication logic

    ## Recent Learnings
    - [2026-01-15] Payment webhook needs raw body parser for Stripe
    - [2026-01-10] Redis pool: {maxRetriesPerRequest: 3}

</details>

**Why CLAUDE.md Helps:**
- ✅ Provides context immediately at session start
- ✅ Reduces need to re-explain project structure
- ✅ Stores project-specific patterns and conventions
- ✅ Documents what works (and what doesn't)
- ✅ Shared with team via git
- ✅ AI-optimized format for Claude to understand quickly

**Note:** While CLAUDE.md is not an official feature, it's a widely-adopted community pattern. Claude Code will automatically read it if present at project root.

### 4. Tools Reference [OFFICIAL]

#### Read Tool
**Purpose:** Read and analyze files

```bash
# Examples
Read file_path="/src/app.ts"
Read file_path="/docs/screenshot.png"  # Can read images!
Read file_path="/docs/guide.pdf"       # Can read PDFs!
Read file_path="/docs/guide.pdf" pages="1-5"  # Read specific PDF pages [NEW v2.1.30]
```

**Capabilities:**
- Reads any text file (code, configs, logs, etc.)
- Handles images (screenshots, diagrams, charts)
- Processes PDFs - extracts text and visual content
- Parses Jupyter notebooks (.ipynb files)
- Returns content with line numbers (`cat -n` format)
- Can read large files with offset/limit parameters

**PDF Parameters** [NEW v2.1.30]:
- `pages`: Optional page range (e.g., `"1-5"`, `"1,3,5"`) to read specific pages
- Large PDFs (>10 pages) return a lightweight reference when @mentioned
- PDF limits: Maximum 100 pages, 20MB file size

**Special Features:**
- **Images**: Claude can read screenshots of errors, UI designs, architecture diagrams
- **PDFs**: Extract and analyze PDF content, useful for documentation and requirements
- **Notebooks**: Full access to code cells, markdown, and outputs

#### Write Tool
**Purpose:** Create new files

```bash
Write file_path="/src/newFile.ts"
      content="export const config = {...}"
```

**Behavior:**
- Creates new file with specified content
- Will OVERWRITE if file already exists (use Edit for existing files)
- Requires permission on first use per session
- Creates parent directories if needed

**Best Practice:** Use Edit tool for modifying existing files, Write tool only for new files.

#### Edit Tool
**Purpose:** Modify existing files with precise string replacement

```bash
Edit file_path="/src/app.ts"
     old_string="const port = 3000"
     new_string="const port = process.env.PORT || 3000"
```

**Important:**
- Requires **exact string match** including whitespace and indentation
- Fails if `old_string` is not unique in file (use larger context or `replace_all`)
- Use `replace_all=true` to replace all occurrences (useful for renaming)
- Must read file first before editing

**Common Pattern:**
```bash
# 1. Read file to see exact content
Read file_path="/src/app.ts"

# 2. Edit with exact string match
Edit file_path="/src/app.ts"
     old_string="function login() {
  return 'TODO';
}"
     new_string="function login() {
  return authenticateUser();
}"
```

#### Bash Tool
**Purpose:** Execute shell commands

```bash
Bash command="npm test"
Bash command="git status"
Bash command="find . -name '*.test.ts'"
```

**Features:**
- Can run any shell command
- Supports background execution (`run_in_background=true`)
- Configurable timeout (default 2 minutes, max 10 minutes)
- Git operations are common (status, diff, log, commit, push)

**Security:**
- Requires permission
- Can be restricted by pattern in settings
- Sandboxing available on macOS/Linux

**Common Git Patterns:**
```bash
# Check status
Bash command="git status"

# View changes
Bash command="git diff"

# Create commit
Bash command='git add . && git commit -m "feat: add authentication"'

# View history
Bash command="git log --oneline -10"
```

#### Grep Tool
**Purpose:** Search file contents with regex patterns

```bash
# Find functions
Grep pattern="function.*auth" path="src/" output_mode="content"

# Find TODOs with context
Grep pattern="TODO" output_mode="content" -C=3

# Count occurrences
Grep pattern="import.*from" output_mode="count"

# Case insensitive
Grep pattern="error" -i=true output_mode="files_with_matches"
```

**Parameters:**
- `pattern`: Regex pattern (ripgrep syntax)
- `path`: Directory or file to search (default: current directory)
- `output_mode`:
  - `"files_with_matches"` (default) - Just file paths
  - `"content"` - Show matching lines
  - `"count"` - Show match counts per file
- `-A`, `-B`, `-C`: Context lines (after, before, both)
- `-i`: Case insensitive
- `-n`: Show line numbers
- `type`: Filter by file type (e.g., "js", "py", "rust")
- `glob`: Filter by glob pattern (e.g., "*.test.ts")

**Fast and Powerful:** Uses ripgrep under the hood, much faster than bash grep on large codebases.

#### Glob Tool
**Purpose:** Find files by pattern

```bash
# Find test files
Glob pattern="**/*.test.ts"

# Find specific extensions
Glob pattern="src/**/*.{ts,tsx}"

# Find config files
Glob pattern="**/config.{json,yaml,yml}"
```

**Features:**
- Fast pattern matching (works with any codebase size)
- Returns files sorted by modification time (recent first)
- Supports complex glob patterns (`**` for recursive, `{}` for alternatives)

#### TodoWrite Tool
**Purpose:** Manage task lists during work

```bash
TodoWrite todos=[
  {
    "content": "Add authentication endpoint",
    "status": "in_progress",
    "activeForm": "Adding authentication endpoint"
  },
  {
    "content": "Write integration tests",
    "status": "pending",
    "activeForm": "Writing integration tests"
  },
  {
    "content": "Update API documentation",
    "status": "pending",
    "activeForm": "Updating API documentation"
  }
]
```

**Task States:**
- `"pending"` - Not started yet
- `"in_progress"` - Currently working on (should be only ONE at a time)
- `"completed"` - Finished successfully

**Dependency Tracking** [NEW]: v2.1.16 introduced task dependency tracking, allowing tasks to define prerequisites that must complete before they start. This enables complex multi-step workflows with proper sequencing.

**Best Practices:**
- Use for multi-step tasks (3+ steps)
- Keep ONE task `in_progress` at a time
- Mark completed IMMEDIATELY after finishing
- Use descriptive `content` (what to do) and `activeForm` (what you're doing)

**When to Use:**
- ✅ Complex multi-step features
- ✅ User provides multiple tasks
- ✅ Non-trivial work requiring planning
- ❌ Single straightforward tasks
- ❌ Trivial operations

#### Task Tool (Sub-Agents)
**Purpose:** Launch specialized AI agents for specific tasks

```bash
# Explore codebase
Task subagent_type="Explore"
     prompt="Find all API endpoints and their authentication requirements"

# General purpose agent for complex tasks
Task subagent_type="general-purpose"
     prompt="Research best practices for rate limiting APIs and implement a solution"
```

**Available Sub-Agent Types:**
- `"general-purpose"` - Complex multi-step tasks, research, implementation
- `"Explore"` - Fast codebase exploration (Glob, Grep, Read, Bash)

**When to Use:**
- Research tasks requiring web search + analysis
- Codebase exploration (finding patterns, understanding architecture)
- Complex multi-step operations that can run independently
- Background work while you continue other tasks

#### WebFetch Tool
**Purpose:** Fetch and analyze web page content

```bash
WebFetch url="https://docs.example.com/api"
         prompt="Extract all endpoint documentation"
```

**Features:**
- Converts HTML to markdown for analysis
- Can extract specific information with prompt
- Useful for researching docs, articles, references

#### WebSearch Tool
**Purpose:** Search the web for current information

```bash
WebSearch query="React 19 new features 2024"
```

**Use Cases:**
- Research current best practices
- Find up-to-date library documentation
- Check for known issues or solutions
- Verify latest framework features

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference), [Settings](https://code.claude.com/docs/en/settings)

#### LSP Tool (Language Server Protocol) [OFFICIAL]
**Purpose:** Get code intelligence features like go-to-definition, find references, and hover documentation.

```bash
LSP operation="goToDefinition"
    filePath="src/utils/auth.ts"
    line=42
    character=15
```

**Available Operations:**
| Operation | Description |
|-----------|-------------|
| `goToDefinition` | Find where a symbol is defined |
| `findReferences` | Find all references to a symbol |
| `hover` | Get documentation and type info for a symbol |
| `documentSymbol` | Get all symbols in a document (functions, classes, variables) |
| `workspaceSymbol` | Search for symbols across the entire workspace |
| `goToImplementation` | Find implementations of an interface or abstract method |
| `prepareCallHierarchy` | Get call hierarchy item at a position |
| `incomingCalls` | Find all functions/methods that call the function at a position |
| `outgoingCalls` | Find all functions/methods called by the function at a position |

**Parameters:**
- `operation` (required): The LSP operation to perform
- `filePath` (required): Absolute or relative path to the file
- `line` (required): Line number (1-based, as shown in editors)
- `character` (required): Character offset (1-based, as shown in editors)

**Use Cases:**
```bash
# Find where a function is defined
> "Go to the definition of getUserById"

# Find all usages of a function
> "Find all references to the authenticate function"

# Get documentation for a symbol
> "What does the validateToken function do?"

# Explore code structure
> "List all symbols in the auth.ts file"
```

**Note:** LSP servers must be configured for the file type. If no server is available for a language, an error will be returned.

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference)

### 5. Context Management [OFFICIAL]

Claude Code maintains conversation context with smart management:

#### Context Commands

```bash
/compact                   # Reduce context by removing old information
/compact "keep auth work"  # Compact with focus instructions (keeps specified context)
```

#### When to Use

**Use /compact when:**
- Long sessions with many file reads
- "Context too large" errors
- You've completed a major task and want to start fresh

**Use /compact with instructions when:**
- Context is getting large but you want to preserve recent work
- Switching between related tasks
- You want intelligent cleanup without losing important context
- Example: `/compact "keep the authentication implementation context"`

#### What Gets Preserved vs Cleared

**Preserved:**
- CLAUDE.md content (your project context)
- Recent interactions and decisions
- Current task information and todos
- Recent file reads still relevant

**Cleared:**
- Old file reads no longer needed
- Completed operations
- Stale search results
- Old context no longer relevant

#### Automatic Context Management

Claude Code may automatically compact when:
- Token limit is approaching
- Many old file reads are present
- Session has been very long

**Source:** [Settings](https://code.claude.com/docs/en/settings)

### 6. Workspace Management [OFFICIAL]

#### Adding Directories with /add-dir

Claude Code can work with multiple directories simultaneously:

```bash
# Add another directory to current session
/add-dir /path/to/other/project

# Work across multiple projects
> "Update the User type in backend and propagate to frontend"
# Claude can now access both directories
```

**Use Cases:**
- Monorepo development (frontend + backend + shared libs)
- Cross-project refactoring
- Dependency updates across multiple projects
- Coordinating changes between related repositories

**Configuration:**

You can also pre-configure additional directories in `.claude/settings.json`:

```json
{
  "permissions": {
    "additionalDirectories": [
      "/path/to/frontend",
      "/path/to/backend",
      "/path/to/shared-libs"
    ]
  }
}
```

#### Status Line Configuration with /statusline

Customize what information appears in your status line:

```bash
# Configure status line
/statusline

# Options typically include:
# - Current model
# - Token usage
# - Session duration
# - Active tools
# - Background processes
```

**Benefits:**
- Monitor token usage in real-time
- Track session duration
- See active background processes
- Understand which tools are being used

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference)

---

## Quick Start Guide

### Your First Session

```bash
# 1. Navigate to your project
cd /path/to/your/project

# 2. Start Claude Code
claude

# 3. Ask Claude to understand your project
> "Read the codebase and explain the project structure"

# Claude will:
- Look for README, package.json, or similar entry points
- Read relevant files (asks permission first time)
- Analyze the code structure
- Provide a summary

# 4. Request an analysis
> "Review the authentication system for security issues"

# Claude will:
- Find authentication-related files
- Analyze the implementation
- Identify potential vulnerabilities
- Suggest improvements

# 5. Make changes
> "Add rate limiting to the login endpoint"

# Claude will:
- Plan the implementation
- Show you what changes will be made
- Request permission to edit files
- Implement the changes
- Can run tests to verify

# 6. Create a commit
> "Create a git commit for these changes"

# Claude will:
- Run git status to see changes
- Review git diff
- Create a descriptive commit message
- Commit the changes
```

### Setting Up Your Project for Claude Code

#### 1. Create CLAUDE.md [COMMUNITY]

This provides context that persists across all sessions:

```bash
# Ask Claude to help create it
> "Create a CLAUDE.md file documenting this project's structure, commands, and conventions"

# Or create manually with:
- Languages and frameworks used
- Important commands (dev, test, build, lint)
- Project structure overview
- Coding conventions
- Known gotchas or issues
```

#### 2. Configure Permissions (Optional) [OFFICIAL]

Create `.claude/settings.json` in your project:

```json
{
  "permissions": {
    "defaultMode": "ask",
    "allow": {
      "Bash": [
        "npm test",
        "npm run*",
        "git status",
        "git diff",
        "git log*"
      ],
      "Read": {},
      "Grep": {},
      "Glob": {}
    },
    "deny": {
      "Write": ["*.env", ".env.*"],
      "Edit": ["*.env", ".env.*", ".git/*"]
    }
  }
}
```

This configuration:
- Allows common safe commands without asking
- Blocks editing sensitive files
- Still asks permission for file modifications

#### 3. Test the Setup

```bash
> "Run the tests"
# Should execute without permission prompt (if configured)

> "What commands are available?"
# Claude will read package.json and list scripts

> "What's in CLAUDE.md?"
# Claude will read and summarize your project context
```

**Source:** [Quickstart](https://code.claude.com/docs/en/quickstart), [Settings](https://code.claude.com/docs/en/settings)

---

## Advanced Features

### Thinking Mode [OFFICIAL]

Claude Code supports extended thinking for complex reasoning tasks. Opus 4.5 has thinking mode enabled by default.

**Activation Methods:**

```bash
# Toggle with keyboard shortcut
Alt+T (or Option+T on macOS)  # Toggle thinking on/off

# Or use natural language
> "think about this problem"
> "think harder about the architecture"
> "ultrathink about this security issue"

# Tab key (sticky toggle)
Press Tab to toggle thinking mode on/off for subsequent prompts
```

**Thinking Levels:**
| Trigger | Thinking Budget | Use Case |
|---------|----------------|----------|
| `think` | Standard | General reasoning, code analysis |
| `think harder` | Extended | Complex problems, multiple approaches |
| `ultrathink` | Maximum | Critical decisions, deep architecture analysis |

**Best Practices:**
- Use `think harder` for debugging complex issues
- Use `ultrathink` for architectural decisions or security reviews
- Thinking content is visible in `Ctrl+O` transcript mode
- Thinking mode is sticky - stays on until toggled off

**Source:** [Thinking Mode](https://code.claude.com/docs/en/thinking-mode)

### Fast Mode [NEW] [OFFICIAL]

Fast mode is a high-speed configuration for Claude Opus 4.6, making responses **2.5x faster** at a higher cost per token. Available since v2.1.36.

**Toggle Fast Mode:**
```bash
# Toggle with built-in command
/fast          # Toggle on/off

# Or set in settings
"fastMode": true   # In user settings file
```

**Visual Indicators:**
- `↯` icon appears next to prompt when fast mode is active
- Icon turns gray during rate limit cooldown

**Pricing (per MTok):**
| Mode | Input (<200K) | Output | Input (>200K) | Output |
|------|--------------|--------|---------------|--------|
| Standard Opus 4.6 | $15 | $75 | $15 | $75 |
| Fast Mode | $30 | $150 | $60 | $225 |

**Note:** Fast mode is available at 50% discount until February 16, 2026.

**Requirements:**
- Claude subscription plan (Pro/Max/Team/Enterprise) or Claude Console API
- Extra usage enabled (`/extra-usage`)
- Not available on third-party providers (Bedrock, Vertex, Azure Foundry)
- For Teams/Enterprise: Admin must enable in organization settings

**When to Use:**
- ✅ Rapid iteration on code changes
- ✅ Live debugging sessions
- ✅ Time-sensitive work
- ❌ Long autonomous tasks (cost matters more)
- ❌ Batch processing or CI/CD pipelines

**Fast Mode vs Effort Level:**
| Setting | Effect |
|---------|--------|
| **Fast mode** | Same quality, lower latency, higher cost |
| **Lower effort level** | Faster responses, potentially lower quality |

You can combine both for maximum speed on straightforward tasks.

**Rate Limits:**
- Separate rate limits from standard Opus 4.6
- Automatically falls back to standard mode during cooldown
- Re-enables when cooldown expires

**Source:** [Fast Mode](https://code.claude.com/docs/en/fast-mode)

### Plan Mode [OFFICIAL]

Plan Mode provides structured planning with model selection for complex tasks.

```bash
# Enter plan mode
/plan

# Or Claude may suggest plan mode for complex tasks
> "Implement a complete authentication system"
# Claude: "This is a complex task. Would you like me to create a plan first?"
```

**Plan Mode Features:**
- **Opus planning, Sonnet execution** - Uses stronger model for planning, faster model for implementation
- **SonnetPlan Mode** - Sonnet planning, Haiku execution (cost-effective)
- **Shift+Tab** - Auto-accept edits in plan mode
- **Plan persistence** - Plans persist across `/clear`

**Plan Mode Workflow:**
1. Claude analyzes the task and creates a structured plan
2. You review and approve or modify the plan
3. Claude executes the plan step by step
4. Progress is tracked with TodoWrite

**Source:** [Plan Mode](https://code.claude.com/docs/en/plan-mode)

### Background Tasks & Agents [OFFICIAL]

Run commands and agents in the background while continuing to work.

**Keyboard Shortcut:**
```bash
Ctrl+B  # Background current command or agent (unified shortcut)
```

**Background Commands:**
```bash
# Start command in background
> "Run the dev server in background"
> "Start tests in watch mode in background"

# Or prefix with &
> "& npm run dev"

# View background tasks
/tasks
/bashes

# Kill a background task
/kill <task-id>
```

**Background Agents:**
```bash
# Launch agent in background
> "Have an Explore agent analyze the codebase architecture in background"

# Agents run asynchronously and notify you when complete
# You receive wake-up messages when background agents finish
```

**Features:**
- Real-time output streaming to status line
- Wake-up notifications when tasks complete
- Multiple concurrent background processes
- Output persisted to files for large outputs

**Source:** [Background Tasks](https://code.claude.com/docs/en/background-tasks)

### Auto-Memory [NEW]

Claude Code now automatically records and recalls memories as it works (v2.1.32+).

**How It Works:**
- Claude automatically remembers important context, decisions, and patterns
- Memories persist across sessions and inform future work
- No manual intervention required

**Memory Scopes for Agents:**
```markdown
---
name: my-agent
memory: project  # Options: user, project, local
---
```

| Scope | Storage | Shared |
|-------|---------|--------|
| `user` | `~/.claude/` | All your projects |
| `project` | `.claude/` | Team via git |
| `local` | `.claude/*.local.*` | No (gitignored) |

**Disable Auto-Memory:**
```bash
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
```

### Keyboard Shortcuts [OFFICIAL]

**Navigation & Editing:**
| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+O` | View transcript (shows thinking blocks) |
| `Ctrl+G` | Edit prompt in system text editor |
| `Ctrl+Y` | Readline-style paste (yank) |
| `Alt+Y` | Yank-pop (cycle through kill ring) |
| `Ctrl+B` | Background current command/agent |
| `Ctrl+Z` | Suspend/Undo |

**Model & Mode Switching:**
| Shortcut | Action |
|----------|--------|
| `Alt+P` (Win/Linux) / `Option+P` (macOS) | Switch models while typing |
| `Alt+T` (Win/Linux) / `Option+T` (macOS) | Toggle thinking mode |
| `Tab` | Toggle thinking (sticky) / Accept suggestions |
| `Shift+Tab` | Auto-accept edits (plan mode) / Switch modes (Windows) |

**Input & Submission:**
| Shortcut | Action |
|----------|--------|
| `Enter` | Submit prompt / Accept suggestion immediately |
| `Shift+Enter` | New line (works in iTerm2, WezTerm, Ghostty, Kitty) |
| `Tab` | Edit/accept prompt suggestion |
| `Ctrl+T` | Toggle syntax highlighting in `/theme` |

**Image & File Handling:**
| Shortcut | Action |
|----------|--------|
| `Cmd+V` (macOS) / `Alt+V` (Windows) | Paste image from clipboard |
| `Cmd+N` / `Ctrl+N` | New conversation (VSCode) |

**Vim Bindings (if enabled):**
| Shortcut | Action |
|----------|--------|
| `;` and `,` | Repeat last motion |
| `y` | Yank operator |
| `p` / `P` | Paste |
| `Alt+B` / `Alt+F` | Word navigation |

**Login & Authentication:**
| Shortcut | Action |
|----------|--------|
| `c` | Copy OAuth URL during login |

**Bash Mode Autocomplete** [NEW v2.1.14]:
| Shortcut | Action |
|----------|--------|
| `!` + `Tab` | History-based autocomplete - complete partial commands from history |

### Prompt Suggestions [OFFICIAL]

Claude Code suggests prompts based on context (enabled by default).

```bash
# Claude suggests contextual prompts
> _  # Cursor blinking
# Suggestion appears: "Review the changes we made"

# Tab to edit the suggestion
Tab → Edit the suggestion text

# Enter to submit immediately
Enter → Submit the suggestion as-is
```

**Configuration:**
```bash
# Toggle in /config
/config
# Search for "prompt suggestions"
# Toggle enable/disable
```

### Environment Variables [OFFICIAL]

**Core Configuration:**
| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Your API key |
| `CLAUDE_CODE_SHELL` | Override shell detection |
| `CLAUDE_CODE_TMPDIR` | Custom temp directory |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Disable background task system |
| `CLAUDE_CODE_ENABLE_TASKS` | Set to `false` to use legacy task system [NEW v2.1.19] |

**Display & UI:**
| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_HIDE_ACCOUNT_INFO` | Hide account info in UI |

**Bash & Commands:**
| Variable | Description |
|----------|-------------|
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash command timeout |
| `BASH_MAX_TIMEOUT_MS` | Maximum allowed timeout |
| `CLAUDE_BASH_NO_LOGIN` | Don't use login shell |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | Keep working directory |
| `CLAUDE_CODE_SHELL_PREFIX` | Prefix for shell commands |

**Model Configuration:**
| Variable | Description |
|----------|-------------|
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Override default Sonnet model |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Override default Opus model |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Override default Haiku model |
| `ANTHROPIC_LOG` | Enable debug logging |

**MCP Configuration:**
| Variable | Description |
|----------|-------------|
| `MCP_TIMEOUT` | MCP connection timeout |
| `MCP_TOOL_TIMEOUT` | Individual tool timeout |

**File & Context:**
| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Max tokens for file reads |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Set to `1` to load CLAUDE.md from `--add-dir` directories [NEW] |
| `CLAUDE_PROJECT_DIR` | Override project directory |
| `CLAUDE_PLUGIN_ROOT` | Plugin root substitution |
| `CLAUDE_CONFIG_DIR` | Custom config directory |
| `XDG_CONFIG_HOME` | XDG config base path |

**Network & Proxy:**
| Variable | Description |
|----------|-------------|
| `NODE_EXTRA_CA_CERTS` | Custom CA certificates |
| `NO_PROXY` | Proxy bypass list |
| `CLAUDE_CODE_PROXY_RESOLVES_HOSTS` | Proxy DNS resolution |

**Auto-Update & Plugins:**
| Variable | Description |
|----------|-------------|
| `DISABLE_AUTOUPDATER` | Disable auto-updates |
| `FORCE_AUTOUPDATE_PLUGINS` | Force plugin updates |
| `CLAUDE_CODE_EXIT_AFTER_STOP_DELAY` | Exit delay after stop |

**Monitoring & Telemetry:**
| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_ENABLE_TELEMETRY` | Enable OpenTelemetry collection (`1`) |
| `OTEL_METRICS_EXPORTER` | OTel metrics exporter (e.g., `otlp`) |
| `DISABLE_TELEMETRY` | Opt out of Statsig telemetry (`1`) |
| `DISABLE_ERROR_REPORTING` | Opt out of Sentry error reporting (`1`) |
| `DISABLE_COST_WARNINGS` | Disable cost warning messages (`1`) |

**Advanced:**
| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | Disable anthropic-beta headers (workaround for gateway users) |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enable agent teams feature (`1`) [NEW] |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | Disable automatic memory recording (`1`) [NEW] |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Disable background task system (`1`) |
| `DISABLE_INTERLEAVED_THINKING` | Disable interleaved thinking |
| `USE_BUILTIN_RIPGREP` | Use built-in ripgrep |
| `CLOUD_ML_REGION` | Cloud ML region for Vertex |
| `AWS_BEARER_TOKEN_BEDROCK` | AWS bearer token |
| `MAX_THINKING_TOKENS` | Extended thinking budget (default: 31,999) |
| `MAX_MCP_OUTPUT_TOKENS` | Max MCP tool response tokens (default: 25,000) |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output tokens (default: 32,000, max: 64,000) |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | Disable autoupdate, bug reporting, telemetry |

### New Settings [OFFICIAL]

Recent settings additions (configure in `/config` or `settings.json`):

```json
{
  // Response language
  "language": "en",  // Claude's response language

  // Git integration
  "attribution": true,  // Add model name to commit bylines
  "respectGitignore": true,  // Respect .gitignore in searches

  // UI preferences
  "showTurnDuration": true,  // Show turn duration messages
  "fileSuggestion": "custom-cmd",  // Custom @ file search command
  "spinnerVerbs": ["analyzing", "thinking", "processing"],  // Custom spinner verbs
  "prefersReducedMotion": false,  // Reduce UI animations for accessibility [NEW v2.1.30]

  // Session behavior
  "companyAnnouncements": true,  // Show startup announcements

  // Plan mode
  "plansDirectory": ".claude/plans"  // Custom directory for plan files
}
```

**Skills Variable Substitution:** [NEW]
```markdown
# In skill files, use ${CLAUDE_SESSION_ID} for session-specific operations
Session ID: ${CLAUDE_SESSION_ID}
```

**Project Rules:**
```bash
# New: .claude/rules/ directory for project-specific rules
.claude/rules/
├── coding-style.md      # Coding conventions
├── testing.md           # Testing requirements
└── security.md          # Security guidelines
```

**Wildcard Permissions:**
```json
{
  "permissions": {
    "allow": {
      "Bash": ["npm *", "git *"],  // Wildcard patterns
      "mcp__myserver__*": {}       // MCP tool wildcards
    }
  }
}
```

---

## Skills System

**Skills are unified capabilities that extend Claude Code — both auto-activated by Claude and manually invoked via `/skill-name`.**

> **Note:** Custom slash commands (`.claude/commands/` files) have been merged into skills as of v2.1.3. Your existing command files keep working unchanged. Skills are recommended for new work because they support additional features like supporting files, invocation control, and subagent execution. See [Migration: Commands to Skills](#migration-commands-to-skills).

Claude Code skills follow the [Agent Skills](https://agentskills.io) open standard, which works across multiple AI tools. Claude Code extends the standard with additional features like invocation control, subagent execution, and dynamic context injection.

### What Are Skills? [OFFICIAL]

Skills are instructions packaged as `SKILL.md` files that extend what Claude Code can do. Claude loads them when relevant to your request, or you invoke them directly:

```
# Claude auto-activates a skill based on your request
You: "Review this code for security issues"
Claude: [Loads security-reviewer skill automatically]

# Or you invoke a skill directly
You: /security-reviewer src/auth.ts
Claude: [Loads and executes the security-reviewer skill]
```

**Two types of skill content:**

- **Reference content** — Knowledge Claude applies to your current work (conventions, patterns, style guides). Runs inline alongside your conversation context.
- **Task content** — Step-by-step instructions for a specific action (deploy, commit, code generation). Often invoked manually with `/skill-name`.

### Where Skills Live [OFFICIAL]

Where you store a skill determines who can use it:

| Location | Path | Applies To |
|----------|------|------------|
| **Enterprise** | [Managed settings](https://code.claude.com/docs/en/permissions#managed-settings) | All users in organization |
| **Personal** | `~/.claude/skills/<skill-name>/SKILL.md` | All your projects |
| **Project** | `.claude/skills/<skill-name>/SKILL.md` | This project only |
| **Plugin** | `<plugin>/skills/<skill-name>/SKILL.md` | Where plugin is enabled |

When skills share the same name, higher-priority locations win: **Enterprise > Personal > Project**. Plugin skills use a `plugin-name:skill-name` namespace, so they cannot conflict.

**Legacy compatibility:** Files in `.claude/commands/` still work and support the same frontmatter. If a skill and a command share the same name, the skill takes precedence.

**Automatic nested directory discovery:** When you work with files in subdirectories, Claude Code discovers skills from nested `.claude/skills/` directories. For example, editing a file in `packages/frontend/` also loads skills from `packages/frontend/.claude/skills/`. This supports monorepo setups where packages have their own skills.

**Live change detection:** Skills from directories added via `--add-dir` are loaded automatically and picked up by live change detection — edit them during a session without restarting.

### Skill Directory Structure [OFFICIAL]

Each skill is a directory with `SKILL.md` as the entrypoint:

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── template.md        # Template for Claude to fill in (optional)
├── examples/
│   └── sample.md      # Example output (optional)
└── scripts/
    └── validate.sh    # Script Claude can execute (optional)
```

Reference supporting files from your `SKILL.md` so Claude knows what each file contains:

```markdown
## Additional resources
- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

> **Tip:** Keep `SKILL.md` under 500 lines. Move detailed reference material to separate files.

### Creating a Skill [OFFICIAL]

**Step 1:** Create the skill directory:
```bash
# Personal skill (available in all projects)
mkdir -p ~/.claude/skills/explain-code

# Project skill (shared with team via git)
mkdir -p .claude/skills/explain-code
```

**Step 2:** Write `SKILL.md` with frontmatter and instructions:
```yaml
---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
---

When explaining code, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?

Keep explanations conversational. For complex concepts, use multiple analogies.
```

**Step 3:** Test the skill:
```bash
# Let Claude invoke it automatically
> "How does this code work?"

# Or invoke it directly
> /explain-code src/auth/login.ts
```

### Frontmatter Reference [OFFICIAL]

Configure skill behavior with YAML frontmatter between `---` markers at the top of `SKILL.md`. All fields are optional; only `description` is recommended.

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name. If omitted, uses directory name. Lowercase letters, numbers, hyphens (max 64 chars). |
| `description` | Recommended | What the skill does and when to use it. Claude uses this to decide when to load it. |
| `argument-hint` | No | Hint shown during autocomplete (e.g., `[issue-number]` or `[filename] [format]`). |
| `disable-model-invocation` | No | `true` → only user can invoke via `/name`. Default: `false`. |
| `user-invocable` | No | `false` → hidden from `/` menu, only Claude can invoke. Default: `true`. |
| `allowed-tools` | No | Tools Claude can use without asking permission when skill is active. |
| `model` | No | Model to use when skill is active. |
| `context` | No | Set to `fork` to run in a forked subagent context. |
| `agent` | No | Which subagent type to use when `context: fork` is set. |
| `hooks` | No | Hooks scoped to this skill's lifecycle. See [Hooks](https://code.claude.com/docs/en/hooks#hooks-in-skills-and-agents). |

### Controlling Invocation [OFFICIAL]

By default, both you and Claude can invoke any skill. Two frontmatter fields restrict this:

- **`disable-model-invocation: true`** — Only you can invoke. Use for workflows with side effects (e.g., `/deploy`, `/commit`).
- **`user-invocable: false`** — Only Claude can invoke. Use for background knowledge that isn't actionable as a command.

```yaml
# User-only skill (Claude won't auto-trigger)
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

# Model-only skill (hidden from / menu)
---
name: legacy-system-context
description: Background knowledge about the legacy system
user-invocable: false
---
```

**Invocation and context-loading behavior:**

| Frontmatter | You Can Invoke | Claude Can Invoke | When Loaded into Context |
|-------------|----------------|-------------------|--------------------------|
| (default) | Yes | Yes | Description always in context; full skill loads when invoked |
| `disable-model-invocation: true` | Yes | No | Description not in context; full skill loads when you invoke |
| `user-invocable: false` | No | Yes | Description always in context; full skill loads when invoked |

**Restricting Claude's access via `/permissions`:**

```bash
# Allow only specific skills
Skill(commit)
Skill(review-pr *)

# Deny specific skills
Skill(deploy *)

# Disable all skills
Skill    # Add to deny rules
```

Permission syntax: `Skill(name)` for exact match, `Skill(name *)` for prefix match with any arguments.

### Passing Arguments [OFFICIAL]

Skills accept arguments via placeholder substitutions:

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill |
| `$ARGUMENTS[N]` | Specific argument by 0-based index (e.g., `$ARGUMENTS[0]`) |
| `$N` | Shorthand for `$ARGUMENTS[N]` (e.g., `$0`, `$1`) |
| `${CLAUDE_SESSION_ID}` | Current session ID (useful for logging) |

**Example:**
```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Read the issue description
2. Implement the fix
3. Write tests
4. Create a commit
```

```bash
/fix-issue 123
# Claude receives: "Fix GitHub issue 123 following our coding standards..."
```

**Indexed arguments:**
```yaml
---
name: compare-files
description: Compare two files
---

# Compare: $ARGUMENTS[0] vs $ARGUMENTS[1]
# Shorthand: $0 vs $1

Compare $0 and $1 for differences.
```

```bash
/compare-files "src/v1/api.ts" "src/v2/api.ts"
# $0 = "src/v1/api.ts", $1 = "src/v2/api.ts"
```

If `$ARGUMENTS` is not present in the skill content, arguments are appended as `ARGUMENTS: <value>`.

### Advanced Patterns [OFFICIAL]

#### Dynamic Context Injection

The `` !`command` `` syntax runs shell commands before the skill content is sent to Claude. The output replaces the placeholder:

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

Each `` !`command` `` executes immediately (before Claude sees anything). Claude only sees the final result with actual data.

#### Running in a Subagent

Add `context: fork` to run a skill in isolation. The skill content becomes the prompt that drives the subagent (no access to conversation history):

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

The `agent` field specifies which subagent to use. Options: built-in agents (`Explore`, `Plan`, `general-purpose`) or custom subagents from `.claude/agents/`. Default: `general-purpose`.

> **Warning:** `context: fork` only makes sense for skills with explicit instructions. Guidelines without a task will return without meaningful output.

#### Extended Thinking

To enable extended thinking in a skill, include the word `ultrathink` anywhere in your skill content:

```yaml
---
name: architecture-review
description: Deep architectural analysis
---

Use ultrathink to analyze the architecture deeply.

Review the overall structure, identify patterns, and suggest improvements.
```

### Practical Examples

**Example: Code Review Skill**

`.claude/skills/code-reviewer/SKILL.md`:
```yaml
---
name: code-reviewer
description: Reviews code for security vulnerabilities, bugs, performance issues, and style problems. Use when user asks to review, audit, or check code quality.
allowed-tools: [Read, Grep, Glob]
---

# Code Review Skill

## When to Activate
Use this skill when the user asks to:
- Review code for issues
- Audit security or find vulnerabilities
- Check code quality or best practices

## Review Process

### 1. Scope Detection
- Use Glob to identify files to review
- Prioritize recently modified files
- Focus on user-specified areas if mentioned

### 2. Analysis Layers
- **Security**: SQL injection, XSS, auth issues, exposed secrets
- **Bugs**: Logic errors, null checks, error handling
- **Performance**: N+1 queries, unnecessary loops, memory leaks
- **Style**: Naming conventions, code organization, readability

### 3. Reporting
Provide structured feedback organized by severity:
- **Critical/High**: Security issues
- **Medium**: Performance issues
- **Low**: Style and best practices

Each issue: file path, description, and fix suggestion.
```

**Example: Test Generator Skill**

`.claude/skills/test-generator/SKILL.md`:
```yaml
---
name: test-generator
description: Generates comprehensive unit and integration tests. Use when user asks to write tests, add test coverage, or create test cases.
allowed-tools: [Read, Write, Grep, Glob, Bash]
---

# Test Generator Skill

## When to Activate
Use this skill when user requests:
- "Write tests for..."
- "Add test coverage"
- "Generate test cases"

## Test Generation Process

### 1. Analyze Target Code
- Read the file/function to test
- Identify inputs, outputs, side effects
- Check existing test patterns

### 2. Generate Comprehensive Tests
Cover all scenarios:
- Happy path (expected usage)
- Error cases (invalid inputs)
- Edge cases (empty, null, boundary values)
- Side effects (database, API calls)

### 3. Follow Project Patterns
- Check CLAUDE.md for testing conventions
- Match existing test file structure
- Use project's test framework
```

**Example: Security Review Skill**

`.claude/skills/security-review/SKILL.md`:
```yaml
---
name: security-review
description: Comprehensive security audit of codebase. Use when asked to review security, audit vulnerabilities, or check for exploits.
allowed-tools: [Read, Grep, Glob]
disable-model-invocation: true
---

# Security Review: $ARGUMENTS

Perform a thorough security audit focusing on: $ARGUMENTS

## Review Checklist

### 1. Authentication & Authorization
- Check for weak password policies
- Verify JWT token validation
- Review session management
- Check for broken access control

### 2. Input Validation
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- Command injection possibilities
- Path traversal vulnerabilities

### 3. Data Protection
- Sensitive data exposure
- Encryption at rest and in transit
- API keys and secrets in code
- Database credential security

### 4. Dependencies
- Known vulnerabilities in packages
- Outdated dependencies
- License compliance issues

### 5. Configuration
- Security headers (CSP, HSTS, etc.)
- CORS configuration
- Error messages leaking information
- Debug mode in production

**Output Format** - Provide a detailed report with sections:
- Critical Issues (Fix Immediately)
- High Priority
- Medium Priority
- Low Priority / Recommendations
- Security Strengths
- Action Plan (prioritized list of fixes)
```

**Usage:**
```bash
/security-review "authentication and API endpoints"
```

**Example: API Documentation Generator Skill**

`.claude/skills/api-docs/SKILL.md`:
```yaml
---
name: api-docs
description: Generate comprehensive API documentation from code. Use when asked to document APIs, create API docs, or generate OpenAPI specs.
allowed-tools: [Read, Write, Grep, Glob]
disable-model-invocation: true
---

# Generate API Documentation

Analyze the codebase and create comprehensive API documentation for: $ARGUMENTS

## Process

### 1. Discovery
- Find all API routes/endpoints
- Identify request/response types
- Note authentication requirements
- Document query parameters

### 2. Documentation
For each endpoint, document:
- Method and path
- Description
- Authentication requirements
- Request body/parameters
- Response codes and bodies
- Example requests

### 3. Output
- Create `/docs/API.md` with full documentation
- Create `/openapi.yaml` with OpenAPI spec if applicable
```

**Usage:**
```bash
/api-docs "all endpoints"
/api-docs "authentication routes"
```

### File References with @ Syntax [OFFICIAL]

Reference files with `@` prefix for quick file inclusion:

```bash
# Reference single file
/review-code @src/auth.ts

# Reference multiple files
/review-code @src/auth.ts @src/api.ts @tests/auth.test.ts

# Works in regular prompts too
> "Review @src/services/payment.ts for security issues"

# Reference files with skill arguments
/analyze-file @src/components/UserProfile.tsx
```

**How @ References Work:**
- `@filename` automatically expands to include file content
- Works with both absolute and relative paths
- Can reference multiple files in one command
- Files are read and included in context automatically
- Reduces need to explicitly say "read file X first"

**Use Cases:**
```bash
# Code review with context
> "Compare @src/api/v1.ts and @src/api/v2.ts and list differences"

# Refactoring across files
> "Make @src/models/User.ts consistent with @src/types/user.d.ts"

# Bug investigation
> "This error occurs in @src/services/auth.ts, check @logs/error.log for clues"

# Test generation
> "Generate tests for @src/utils/validator.ts"
```

**Best Practices:**
- Use @ references when you know exact file paths
- Combine with skills for reusable workflows
- Great for focused analysis of specific files
- Reduces token usage vs. reading entire directories

### MCP Integration [OFFICIAL]

MCP servers can expose prompts that become invocable skills automatically:

```json
{
  "prompts": [
    {
      "name": "search-docs",
      "description": "Search internal documentation",
      "arguments": [{"name": "query", "description": "Search query"}]
    }
  ]
}
```

This becomes available as `/search-docs` in Claude Code.

```bash
# Add MCP server
claude mcp add github -- gh-mcp

# MCP prompts become skills:
/github-pr-review      # Review current PR
/github-issues         # List open issues
/github-create-pr      # Create PR from current branch
```

### Skill Best Practices [OFFICIAL]

#### 1. Write Clear, Specific Descriptions

The `description` field is critical — it helps Claude decide when to activate:

**Good:**
```yaml
description: "Generates API documentation from code comments. Use when user asks to document APIs, create API docs, update endpoint documentation, or generate OpenAPI specs."
```

**Bad:**
```yaml
description: "Documentation generator"  # Too vague
```

#### 2. Use Natural Trigger Words

Include terms users would naturally say:

```yaml
# For security review skill
description: "Reviews code for security. Use when asked to: review security, audit code, find vulnerabilities, check for exploits, analyze risks."

# For performance optimization skill
description: "Optimizes code performance. Use when asked to: improve performance, optimize speed, reduce memory usage, make faster, profile code."
```

#### 3. Restrict Tools Appropriately

```yaml
# Analysis only (can't modify code)
allowed-tools: [Read, Grep, Glob]

# Can create/modify code
allowed-tools: [Read, Write, Edit, Bash]

# Research and implementation
allowed-tools: [Read, Write, Edit, WebFetch, WebSearch]
```

#### 4. Keep Skills Focused

**Good (focused):**
- `sql-optimizer` — Optimizes SQL queries only
- `api-docs-generator` — Generates API documentation
- `security-scanner` — Finds security issues

**Bad (too broad):**
- `database-everything` — Too vague
- `code-helper` — What kind of help?

#### 5. Provide Clear Instructions

Structure your SKILL.md:
1. **When to Activate** — Clear triggers
2. **Process** — Step-by-step what to do
3. **Output Format** — How to present results
4. **Examples** — Show expected behavior

#### 6. Mind the Context Budget

Skill descriptions are loaded into context so Claude knows what's available. If you have many skills, they may exceed the character budget (2% of context window, fallback 16,000 characters). Run `/context` to check for warnings about excluded skills.

Override the limit with the `SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable.

### Troubleshooting Skills [OFFICIAL]

**Skill not triggering:**
1. Check the description includes keywords users would naturally say
2. Verify the skill appears when you ask "What skills are available?"
3. Try rephrasing your request to match the description
4. Invoke directly with `/skill-name` to confirm it works

**Skill triggers too often:**
1. Make the description more specific
2. Add `disable-model-invocation: true` for manual-only invocation

**Claude doesn't see all skills:**
- Too many skill descriptions may exceed the character budget
- Run `/context` to check for a warning about excluded skills
- Set `SLASH_COMMAND_TOOL_CHAR_BUDGET` to a higher value

### Migration: Commands to Skills

Custom slash commands (`.claude/commands/` files) have been merged into the skills system. **Your existing command files keep working unchanged.** Skills are recommended for new work because they support:

- **Supporting files** — Bundle templates, scripts, and reference docs alongside your skill
- **Invocation control** — Choose whether you, Claude, or both can invoke
- **Subagent execution** — Run skills in isolated forked contexts
- **Nested discovery** — Automatic loading from subdirectories (monorepo support)

**Migration path:**
```bash
# Old structure (still works)
.claude/commands/review.md

# New structure (recommended)
.claude/skills/review/SKILL.md
```

Both create `/review` and work the same way. If both exist, the skill takes precedence.

**Source:** [Agent Skills](https://code.claude.com/docs/en/skills)

---

## Built-in Commands

**Built-in commands are native CLI commands for managing your Claude Code session.** They are hardcoded into Claude Code and are NOT skills — you cannot customize or override them.

> **Note:** For custom workflow commands, use [Skills](#skills-system) instead. Built-in commands like `/help` and `/compact` are not available through the Skill tool.

### Command Reference [OFFICIAL]

```bash
# Session Management
/help              # Show all available commands
/exit              # End current session
/clear             # Clear conversation history
/compact [instr]   # Compact context (optionally specify what to focus on)
/rewind            # Undo code changes in conversation

# Session & History
/rename <name>     # Give current session a name
/resume [name|id]  # Resume a previous session by name or ID
/export            # Export conversation to file
/copy              # Copy last response to clipboard [NEW]

# Usage & Stats
/usage             # View plan limits and usage (NEW)
/stats             # Usage stats, engagement metrics (supports 7/30/all-time) (NEW)
/extra-usage       # Enable extra usage for Max plan subscribers [NEW]
/fast              # Toggle fast mode (uses faster model, available after /extra-usage) [NEW]

# Background Process Management
/bashes            # List all background processes
/tasks             # List all background tasks (agents, shells, etc.)
/kill <id>         # Stop a background process

# Discovery & Debugging
/bug               # Report bugs (sends conversation to Anthropic)
/commands          # List all skills and commands
/debug             # Troubleshoot session issues [NEW v2.1.30]
/hooks             # Show configured hooks
/skills            # List available Skills
/plugin            # Plugin management interface
/context           # View current context usage as a colored grid
/cost              # Show token usage statistics
/doctor            # Run diagnostics (shows Updates section with auto-update channel)

# Configuration
/config            # General settings (type to search and filter)
/permissions       # Manage tool permissions (with search)
/privacy-settings  # View and update privacy settings
/status            # Show session status (Status tab)
/statusline        # Configure status line display
/model             # Switch between models
/output-style      # Set output style directly or from selection menu
/theme             # Theme picker (Ctrl+T toggles syntax highlighting)
/terminal-setup    # Configure terminal (Kitty, Alacritty, Zed, Warp)
/vim               # Enter vim mode for alternating insert/command modes
/sandbox           # Enable sandboxed bash with filesystem/network isolation

# Workspace Management
/add-dir <path>    # Add additional directory to workspace
/agents            # Manage custom AI subagents
/init              # Initialize project with CLAUDE.md guide
/memory            # Edit CLAUDE.md memory files
/install-github-app # Set up Claude GitHub Actions for repository
/pr-comments       # View pull request comments
/review            # Request code review
/security-review   # Complete security review of pending changes
/todos             # List current TODO items

# MCP Server Management
/mcp               # MCP server management and OAuth authentication
/mcp enable <srv>  # Enable an MCP server
/mcp disable <srv> # Disable an MCP server

# Remote Sessions (claude.ai subscribers)
/teleport          # Resume remote session from claude.ai by session ID
/remote-env        # Configure remote session environment

# Account & Updates
/login             # Switch Anthropic accounts
/logout            # Sign out from Anthropic account
/release-notes     # View release notes

# Plan Mode
/plan              # Enter plan mode for structured planning
```

**Source:** [CLI Reference](https://code.claude.com/docs/en/cli-reference), [Interactive Mode](https://code.claude.com/docs/en/interactive-mode#built-in-commands)

---

## Hooks System

**Hooks are automated scripts that execute at specific points in Claude Code's workflow.**

### What Are Hooks? [OFFICIAL]

Hooks let you **intercept and control** Claude's actions:

```bash
# Examples of what hooks can do:
- Block editing of sensitive files (.env)
- Inject context at session start
- Run linting before file edits
- Validate git commits
- Audit all commands executed
- Add custom security checks
```

**Two Types:**
1. **Bash Command Hooks** (`type: "command"`) - Run shell scripts
2. **Prompt-Based Hooks** (`type: "prompt"`) - Use LLM for context-aware decisions

### Hook Configuration [OFFICIAL]

Hooks are configured in `.claude/settings.json` or `~/.claude/settings.json`:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {"type": "command", "command": "script"}
        ]
      }
    ]
  }
}
```

### Hook Events [OFFICIAL]

| Event | When It Fires | Can Block |
|-------|---------------|-----------|
| **Setup** | Via `--init`, `--init-only`, or `--maintenance` flags | No |
| **SessionStart** | Session begins or resumes | No |
| **SessionEnd** | Session terminates | No |
| **UserPromptSubmit** | User submits a prompt | Yes |
| **PreToolUse** | Before tool execution | Yes |
| **PostToolUse** | After tool succeeds | No |
| **PostToolUseFailure** | After tool fails | No |
| **PermissionRequest** | When permission dialog appears | Yes |
| **SubagentStart** | When spawning a subagent | No |
| **SubagentStop** | When subagent finishes | Yes |
| **Stop** | Claude finishes responding | Yes |
| **Notification** | Claude sends notification | No |
| **PreCompact** | Before context compaction | No |
| **TeammateIdle** | Agent team teammate about to go idle [NEW] | Yes |
| **TaskCompleted** | Task being marked as completed [NEW] | Yes |

### Example: Protect Sensitive Files [OFFICIAL]

`.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=$(echo \"$HOOK_INPUT\" | jq -r \".tool_input.file_path // empty\"); if [[ \"$FILE\" == *\".env\"* ]] || [[ \"$FILE\" == \".git/\"* ]]; then echo \"Cannot modify sensitive files\" >&2; exit 2; fi'"
          }
        ]
      }
    ]
  }
}
```

**How it works:**
- Runs before any Edit or Write tool
- Checks if file path contains ".env" or ".git/"
- Exits with code 2 to block the operation
- Claude receives error and doesn't edit the file

### Example: Session Context Injection [OFFICIAL]

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "cat .claude/session-context.txt"
          }
        ]
      }
    ]
  }
}
```

**Creates:** `.claude/session-context.txt`
```
Today's Focus: Working on authentication refactor
Recent Context: Migrated from sessions to JWT
Current Branch: feature/jwt-auth
Important: Don't modify legacy auth code in /old-auth
```

This context is injected at every session start.

### Example: Intelligent Decision Hook [OFFICIAL]

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if the current task is complete. Arguments: $ARGUMENTS. Check if all subtasks are done, tests pass, and documentation updated. Respond with {\"decision\": \"stop\" or \"continue\", \"reason\": \"explanation\"}"
          }
        ]
      }
    ]
  }
}
```

Uses an LLM (Haiku) to intelligently decide if Claude should stop working.

### Hook Input/Output [OFFICIAL]

**Input (via stdin as JSON):**
```json
{
  "sessionId": "abc123",
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/src/app.ts",
    "old_string": "...",
    "new_string": "..."
  },
  "project_dir": "/home/user/project"
}
```

**Output (exit codes):**
- `0` - Success, continue
- `2` - Block the action
- Other - Non-blocking error (logged)

**JSON Output (optional):**
```json
{
  "decision": "stop",
  "reason": "All tasks complete",
  "continue": false
}
```

### Security Best Practices [OFFICIAL]

⚠️ **Critical:** "By using hooks, you are solely responsible for configured commands, which can modify or delete files your user can access."

**Best Practices:**
```bash
# 1. Always quote variables
FILE="$HOOK_INPUT"  # Good
FILE=$HOOK_INPUT    # Bad - can break with spaces

# 2. Validate paths
if [[ "$FILE" == ../* ]]; then
  echo "Path traversal attempt" >&2
  exit 2
fi

# 3. Use absolute paths
cd "$CLAUDE_PROJECT_DIR" || exit 1

# 4. Sanitize inputs
jq -r '.tool_input.file_path' <<< "$HOOK_INPUT"  # Good
eval "$SOME_VAR"  # Bad - code injection risk

# 5. Block sensitive operations
case "$FILE" in
  *.env|.git/*|.ssh/*)
    echo "Blocked: sensitive file" >&2
    exit 2
    ;;
esac
```

### Debugging Hooks [OFFICIAL]

```bash
# Run Claude with debug mode
claude --debug

# Check hook configuration
> /hooks

# Test hook command manually
echo '{"tool_name":"Edit","tool_input":{"file_path":".env"}}' | bash your-hook-script.sh

# View logs
tail -f ~/.claude/logs/claude.log
```

### Hook Recipes Library [OFFICIAL + COMMUNITY]

**Comprehensive collection of production-ready hook patterns for common automation needs.**

#### 1. Auto-Format Code on Save [COMMUNITY]

Automatically formats code after Claude edits files using language-appropriate formatters.

**Configuration (`.claude/settings.json`):**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

**Script (`~/.claude/hooks/format-code.sh`):**
```bash
#!/bin/bash
# Extract file path from JSON input
FILE=$(echo "$HOOK_INPUT" | jq -r '.tool_input.file_path // empty')

[[ -z "$FILE" ]] && exit 0

# Format based on extension
case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx)
    # Try Biome first, fall back to Prettier
    if command -v biome &> /dev/null; then
      biome format --write "$FILE" &> /dev/null || true
    elif command -v prettier &> /dev/null; then
      prettier --write "$FILE" &> /dev/null || true
    fi
    ;;
  *.py)
    # Python: Ruff
    if command -v ruff &> /dev/null; then
      ruff format "$FILE" &> /dev/null || true
    fi
    ;;
  *.go)
    # Go: goimports + gofmt
    if command -v goimports &> /dev/null; then
      goimports -w "$FILE" &> /dev/null || true
    fi
    go fmt "$FILE" &> /dev/null || true
    ;;
  *.md)
    # Markdown: Prettier
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE" &> /dev/null || true
    fi
    ;;
esac
```

**Make executable:** `chmod +x ~/.claude/hooks/format-code.sh`

---

#### 2. ESLint Auto-Fix on Edit [COMMUNITY]

Automatically runs ESLint with `--fix` on JavaScript/TypeScript files.

**Configuration:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=$(echo \"$HOOK_INPUT\" | jq -r \".tool_input.file_path // empty\"); if [[ \"$FILE\" =~ \\.(ts|tsx|js|jsx)$ ]] && command -v eslint &>/dev/null; then eslint --fix \"$FILE\" &>/dev/null || true; fi'"
          }
        ]
      }
    ]
  }
}
```

---

#### 3. Block .gitignore Reads [COMMUNITY]

Prevents Claude from reading files matching `.claudeignore` patterns.

**Configuration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "hooks": [
          {
            "type": "command",
            "command": "claude-ignore"
          }
        ]
      }
    ]
  }
}
```

**Installation:** `npm install -g claude-ignore && claude-ignore init`

---

#### 4. Run Tests Before Commits [COMMUNITY]

Validates that tests pass before allowing git commits.

**Configuration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/pre-commit-test.sh"
          }
        ]
      }
    ]
  }
}
```

**Script (`~/.claude/hooks/pre-commit-test.sh`):**
```bash
#!/bin/bash
COMMAND=$(echo "$HOOK_INPUT" | jq -r '.tool_input.command // empty')

# Only intercept git commit commands
if [[ "$COMMAND" == git*commit* ]]; then
  echo "Running tests before commit..." >&2

  # Run tests
  if npm test &>/dev/null; then
    echo "✅ Tests passed" >&2
    exit 0
  else
    echo "❌ Tests failed - blocking commit" >&2
    exit 2
  fi
fi

exit 0
```

---

#### 5. Audit Logging Hook [COMMUNITY]

Logs all tool usage for security auditing.

**Configuration:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'echo \"$(date -Iseconds) $TOOL_NAME: $(echo \\\"$HOOK_INPUT\\\" | jq -c .)\" >> ~/.claude/audit.log'"
          }
        ]
      }
    ]
  }
}
```

---

#### 6. Token Usage Tracker [COMMUNITY]

Monitors and logs token usage per session.

**Configuration:**
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/log-session.sh"
          }
        ]
      }
    ]
  }
}
```

**Script:**
```bash
#!/bin/bash
SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id // "unknown"')
TRANSCRIPT=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty')

if [[ -f "$TRANSCRIPT" ]]; then
  TOKENS=$(jq '[.[] | select(.role=="assistant") | .usage.total_tokens] | add' "$TRANSCRIPT" 2>/dev/null || echo 0)
  echo "$(date -Iseconds) Session $SESSION_ID: $TOKENS tokens" >> ~/.claude/token-usage.log
fi
```

---

#### 7. Commit Message Validation [COMMUNITY]

Enforces conventional commit message format.

**Configuration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/validate-commit.sh"
          }
        ]
      }
    ]
  }
}
```

**Script:**
```bash
#!/bin/bash
COMMAND=$(echo "$HOOK_INPUT" | jq -r '.tool_input.command // empty')

if [[ "$COMMAND" == git*commit*-m* ]]; then
  MSG=$(echo "$COMMAND" | sed -n 's/.*-m[[:space:]]*["'"'"']\([^"'"'"']*\)["'"'"'].*/\1/p')

  # Check conventional commit format: type(scope): message
  if [[ ! "$MSG" =~ ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: ]]; then
    echo "❌ Commit message must follow format: type(scope): message" >&2
    echo "Valid types: feat, fix, docs, style, refactor, test, chore" >&2
    exit 2
  fi
fi

exit 0
```

---

#### 8. Security Secret Scanner [COMMUNITY]

Prevents committing files containing potential secrets.

**Configuration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/detect-secrets.sh"
          }
        ]
      }
    ]
  }
}
```

**Script:**
```bash
#!/bin/bash
FILE=$(echo "$HOOK_INPUT" | jq -r '.tool_input.file_path // empty')
NEW_CONTENT=$(echo "$HOOK_INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')

# Check for common secret patterns
if echo "$NEW_CONTENT" | grep -iE '(api[_-]?key|password|secret|token|auth)["\s:=]+\S{16,}' &>/dev/null; then
  echo "⚠️  Potential secret detected in $FILE" >&2
  echo "Please review and use environment variables instead" >&2
  exit 2
fi

exit 0
```

---

#### 9. Auto-Documentation Update [COMMUNITY]

Updates README when code changes are made.

**Configuration:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'echo \"📝 Consider updating documentation for recent changes\" >&2'"
          }
        ]
      }
    ]
  }
}
```

---

#### 10. Performance Profiling [COMMUNITY]

Tracks execution time of tool operations.

**Configuration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'echo \"$HOOK_INPUT\" > /tmp/claude-pre-$$.json; date +%s%N > /tmp/claude-time-$$.txt'"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/profile-tool.sh"
          }
        ]
      }
    ]
  }
}
```

**Script:**
```bash
#!/bin/bash
START=$(cat /tmp/claude-time-$$.txt 2>/dev/null || echo 0)
END=$(date +%s%N)
DURATION=$(( (END - START) / 1000000 ))  # milliseconds
TOOL=$(echo "$HOOK_INPUT" | jq -r '.tool_name // "unknown"')

echo "$(date -Iseconds) $TOOL: ${DURATION}ms" >> ~/.claude/performance.log

rm -f /tmp/claude-pre-$$.json /tmp/claude-time-$$.txt
```

---

**Source:** [Hooks Reference](https://code.claude.com/docs/en/hooks), [Hooks Guide](https://code.claude.com/docs/en/hooks-guide), Community GitHub repositories

---

## MCP Integration

**Model Context Protocol (MCP) connects Claude Code to external data sources and tools.**

### What is MCP? [OFFICIAL]

MCP allows Claude Code to:
- Access external data (Google Drive, Slack, Jira, Notion, etc.)
- Use specialized tools (databases, APIs, services)
- Integrate with enterprise systems
- Extend capabilities beyond local filesystem

**Common Use Cases:**
- Read/write Google Drive documents
- Search Slack conversations
- Query databases directly
- Fetch from internal APIs
- Access design files (Figma)
- Manage project tasks (Jira, Linear)

### MCP Server Installation [OFFICIAL]

MCP servers can be added via CLI or configuration files:

**CLI Installation (Recommended):**
```bash
# Remote HTTP Server (recommended for hosted services)
claude mcp add --transport http notion https://mcp.notion.com/mcp
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# With authentication headers
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"

# Local Stdio Server (for local packages)
claude mcp add --transport stdio airtable -- npx -y airtable-mcp-server
claude mcp add --transport stdio postgres -- npx -y @modelcontextprotocol/server-postgres "$DATABASE_URL"

# With environment variables
claude mcp add --transport stdio --env AIRTABLE_API_KEY=your_key airtable -- npx -y airtable-mcp-server

# Windows (requires cmd /c wrapper)
claude mcp add --transport stdio myserver -- cmd /c npx -y @some/package
```

**MCP Server Management:**
```bash
claude mcp list              # List all configured servers
claude mcp get github        # Get details for specific server
claude mcp remove github     # Remove a server
/mcp                         # Interactive management in Claude Code
```

**Installation Scopes:**
```bash
# Local scope (default) - stored in ~/.claude.json under project path
claude mcp add --transport http stripe https://mcp.stripe.com

# Project scope - stored in .mcp.json (shared via git)
claude mcp add --scope project --transport http paypal https://mcp.paypal.com/mcp

# User scope - stored in ~/.claude.json (available across all projects)
claude mcp add --scope user --transport http hubspot https://mcp.hubspot.com
```

**Configuration File (`.mcp.json`):**
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "${DATABASE_URL}"],
      "env": {
        "DB_URL": "${DB_URL}",
        "API_KEY": "${API_KEY:-default-value}"
      }
    },
    "slack": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

### OAuth Authentication [OFFICIAL]

Many MCP servers support OAuth for secure authentication:

```bash
# Add server that requires OAuth
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# Within Claude Code, authenticate via browser
/mcp
# Follow browser steps to complete OAuth login
```

**Manual OAuth Configuration:**
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "oauth": {
        "provider": "github",
        "scopes": ["repo", "read:user"]
      }
    }
  }
}
```

Claude Code opens a browser to complete the OAuth flow on first use.

### Using MCP Tools [OFFICIAL]

Once configured, MCP tools appear with the pattern `mcp__<server>__<tool>`:

```bash
# Example: Google Drive search
> "Search our Google Drive for Q4 planning documents"

# Claude uses: mcp__google-drive__search_files

# Example: Database query
> "Show all users created in the last week"

# Claude uses: mcp__postgres__query with SQL

# Example: Slack search
> "Find conversations about the API redesign"

# Claude uses: mcp__slack__search_messages
```

### MCP in Hooks [OFFICIAL]

You can reference MCP tools in hooks:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__postgres__query",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Database query requires review' && read -p 'Approve? (y/n) ' -n 1 -r && [[ $REPLY =~ ^[Yy]$ ]]"
          }
        ]
      }
    ]
  }
}
```

### Popular MCP Servers [COMMUNITY]

```bash
# Official Servers
@modelcontextprotocol/server-google-drive      # Google Drive access
@modelcontextprotocol/server-slack             # Slack integration
@modelcontextprotocol/server-github            # GitHub API
@modelcontextprotocol/server-postgres          # PostgreSQL database
@modelcontextprotocol/server-sqlite            # SQLite database
@modelcontextprotocol/server-filesystem        # Extended file access

# Community Servers
# Check GitHub for community-built MCP servers
```

### MCP Configuration Management [OFFICIAL]

```bash
# Enable all project MCP servers automatically
{
  "enableAllProjectMcpServers": true
}

# Whitelist specific servers
{
  "enabledMcpjsonServers": ["google-drive", "postgres"]
}

# Blacklist servers
{
  "disabledMcpjsonServers": ["risky-server"]
}

# Enterprise: Restrict to managed servers only
{
  "useEnterpriseMcpConfigOnly": true,
  "allowedMcpServers": ["approved-server-1", "approved-server-2"]
}
```

### MCP Tool Search [NEW]

When MCP tool definitions exceed a threshold of the context window, they're automatically deferred via an MCPSearch tool:

```bash
# Configure tool search threshold (% of context window)
ENABLE_TOOL_SEARCH=auto:5 claude    # Activate at 5%
ENABLE_TOOL_SEARCH=auto:10 claude   # Activate at 10% (default)
ENABLE_TOOL_SEARCH=true claude      # Always enabled
ENABLE_TOOL_SEARCH=false claude     # Always disabled

# Or configure in settings.json
{
  "permissions": {
    "deny": ["MCPSearch"]  # Disable MCP tool search
  }
}
```

**Source:** [MCP Documentation](https://code.claude.com/docs/en/mcp), [Settings](https://code.claude.com/docs/en/settings)

### MCP Setup Examples [OFFICIAL]

**Quick-start configurations for popular MCP servers.**

#### GitHub Integration

```bash
# Installation
claude mcp add --transport stdio github -- npx -y @modelcontextprotocol/server-github

# Or via .mcp.json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Common operations:** Create issues, manage PRs, search code, review repositories.

#### Slack Integration

```bash
# Installation
claude mcp add --transport stdio slack -- npx -y @modelcontextprotocol/server-slack

# Configuration
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "T01234567"
      }
    }
  }
}
```

**Usage:** `> "Search Slack for conversations about API redesign"`

#### Google Drive Integration

```bash
# Installation with OAuth
claude mcp add --transport http gdrive https://mcp.google.com/drive

# Or stdio with credentials
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GDRIVE_CREDENTIALS_PATH": "${HOME}/.gdrive-credentials.json"
      }
    }
  }
}
```

**Authenticate:** Run `/mcp` in Claude Code and follow OAuth flow.

#### PostgreSQL Database

```bash
# Installation
claude mcp add --transport stdio postgres -- npx -y @modelcontextprotocol/server-postgres postgresql://user:pass@localhost/db

# Configuration
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "${DATABASE_URL}"
      ]
    }
  }
}
```

**Usage:** `> "Show all users created in the last week from the database"`

#### Notion Integration

```bash
# Installation
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Requires Notion OAuth - authenticate via /mcp command
```

**Common operations:** Query databases, create pages, search workspace.

#### Stripe Payment Integration

```bash
# Configuration
{
  "mcpServers": {
    "stripe": {
      "command": "npx",
      "args": ["-y", "@stripe/mcp-server"],
      "env": {
        "STRIPE_API_KEY": "${STRIPE_API_KEY}"
      }
    }
  }
}
```

**Usage:** `> "List recent Stripe transactions and summarize revenue"`

### MCP Troubleshooting [COMMUNITY]

**Common issues and solutions from GitHub issues and production usage.**

#### Issue: MCP Server Not Showing in List

```bash
# Problem
claude mcp list
# Output: "No MCP servers configured"

# Solutions
1. Check file location:
   - User scope: ~/.claude/settings.json
   - Project scope: .mcp.json (in project root)

2. Verify JSON syntax:
   cat .mcp.json | jq .

3. Check scope setting:
   claude mcp add --scope project <name> ...

4. Restart Claude Code after config changes
```

#### Issue: Tools Not Available Despite "Connected"

```bash
# Problem
/mcp shows "✓ Connected" but tools don't appear

# Solutions
1. Check tool output size (max 25,000 tokens):
   export MAX_MCP_OUTPUT_TOKENS=50000

2. Verify server actually started:
   ps aux | grep mcp

3. Check debug logs:
   claude --debug
   tail -f ~/.claude/logs/claude.log

4. Reset project approvals:
   claude mcp reset-project-choices
```

#### Issue: OAuth Authentication Fails

```bash
# Problem
Browser opens but OAuth fails or doesn't complete

# Solutions
1. Use /mcp command (not direct URL)

2. Check network/proxy settings:
   # Try without VPN/Cloudflare Warp

3. Clear OAuth cache:
   rm -rf ~/.claude/oauth-cache

4. Verify redirect URI in provider settings
```

#### Issue: Windows "Connection Closed" Error

```bash
# Problem
MCP server immediately closes on Windows

# Solution - Use cmd /c wrapper:
claude mcp add --transport stdio myserver -- cmd /c npx -y package-name

# In .mcp.json:
{
  "mcpServers": {
    "myserver": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "package-name"]
    }
  }
}
```

#### Issue: Environment Variables Not Expanding

```bash
# Problem
${VAR} shows literally instead of expanding

# Solutions
1. Check .env file exists and is loaded

2. Use default syntax:
   "${API_KEY:-default_value}"

3. Set in shell before running:
   export API_KEY=xxx && claude

4. Use settings.local.json for sensitive values
```

#### Issue: MCP Server Process Crashes

```bash
# Debug steps:
1. Test server directly:
   npx @modelcontextprotocol/server-github

2. Check stdout/stderr:
   claude --debug | grep mcp

3. Verify dependencies installed:
   npm list -g | grep mcp

4. Check memory/resource limits:
   ulimit -a
```

---

## Sub-Agents

**Sub-agents are specialized AI assistants configured for specific tasks.**

### What Are Sub-Agents? [OFFICIAL]

Sub-agents are instances of Claude optimized for particular workflows:

```bash
# Built-in Sub-Agents
- general-purpose: Complex multi-step tasks
- Explore: Fast codebase exploration

# Custom Sub-Agents
- You can create your own with custom prompts and tools
```

### Using Sub-Agents [OFFICIAL]

Launch with the `Task` tool:

```bash
# Explore codebase
> "Find all database queries in the codebase"

# Claude uses:
Task subagent_type="Explore"
     prompt="Find all database queries and list files containing SQL, Prisma, or ORM code"

# General purpose research
> "Research best practices for API rate limiting and suggest implementation"

# Claude uses:
Task subagent_type="general-purpose"
     prompt="Research API rate limiting approaches, compare options, and recommend implementation for Express.js"
```

### Creating Custom Sub-Agents [OFFICIAL]

Sub-agents are defined as Markdown files in `.claude/agents/` or `~/.claude/agents/`:

**Example: Debug Assistant**

`.claude/agents/debugger.md`:
```markdown
---
name: debugger
description: Specialized debugging agent for production issues
model: claude-sonnet-4
allowedTools: [Read, Grep, Glob, Bash]
---

# Debug Assistant

You are a specialized debugging agent. Your role is to systematically investigate and identify the root cause of issues.

## Debugging Process

### 1. Gather Context
- Read error messages and stack traces
- Check recent code changes (git log)
- Review related log files
- Understand expected vs actual behavior

### 2. Hypothesis Generation
- List possible causes
- Prioritize by likelihood
- Consider recent changes first

### 3. Systematic Investigation
- Test each hypothesis methodically
- Use Grep to find related code
- Read implementation details
- Check for similar patterns elsewhere

### 4. Root Cause Analysis
- Identify the precise cause
- Explain why it happens
- Trace the execution path

### 5. Solution Proposal
- Suggest specific fixes
- Explain tradeoffs
- Provide code examples
- Recommend tests to prevent recurrence

## Constraints
- DO NOT modify code (read-only analysis)
- DO provide detailed explanations
- DO reference specific file:line locations
- DO consider edge cases
```

**Example: Code Review Agent**

`.claude/agents/reviewer.md`:
```markdown
---
name: reviewer
description: Code review specialist focusing on quality and best practices
model: claude-sonnet-4
allowedTools: [Read, Grep, Glob]
---

# Code Reviewer

You are a senior code reviewer. Provide constructive, actionable feedback.

## Review Criteria

### Code Quality
- Readability and maintainability
- Naming conventions
- Code organization
- DRY principle adherence

### Correctness
- Logic errors
- Edge cases handling
- Error handling
- Null/undefined checks

### Performance
- Algorithm efficiency
- Unnecessary computations
- Memory usage
- Database query optimization

### Security
- Input validation
- SQL injection risks
- XSS vulnerabilities
- Authentication/authorization

### Testing
- Test coverage
- Test quality
- Edge cases tested

## Output Format
Provide structured feedback:
- **Strengths**: What's done well
- **Issues**: Problems found (with severity)
- **Suggestions**: Improvements
- **Examples**: Code snippets for fixes
```

### Sub-Agent Features [OFFICIAL]

#### Model Selection

Choose different models per agent:

```markdown
---
name: fast-explorer
model: claude-haiku-4  # Fast, cost-effective
---
```

```markdown
---
name: deep-analyzer
model: claude-opus-4  # Most capable
---
```

#### Tool Restrictions

Limit tools for focused operation:

```markdown
---
name: readonly-analyzer
allowedTools: [Read, Grep, Glob]  # Analysis only
---
```

```markdown
---
name: implementation-agent
allowedTools: [Read, Write, Edit, Bash]  # Can modify code
---
```

### Sub-Agent Patterns [COMMUNITY]

#### Parallel Analysis

```bash
> "Have multiple agents analyze different aspects"

# Launches multiple agents in parallel:
- Security review agent
- Performance analysis agent
- Code style agent
- Test coverage agent

# Aggregates results
```

#### Sequential Pipeline

```bash
> "Research → Design → Implement authentication"

# Sequential sub-agents:
1. Research agent: Find best practices
2. Design agent: Create architecture
3. Implementation agent: Write code
4. Review agent: Verify implementation
```

#### Specialized Teams

```json
{
  "frontend-agent": "React/UI specialist",
  "backend-agent": "API/database specialist",
  "devops-agent": "Deployment/infrastructure specialist"
}
```

**Source:** [Sub-Agents](https://code.claude.com/docs/en/sub-agents)

---

## Agent Teams

**Agent Teams enable multiple Claude Code instances to collaborate on complex tasks with shared context and direct communication.**

### What Are Agent Teams? [OFFICIAL]

Agent Teams (experimental) allow you to coordinate multiple Claude Code sessions working together:

```bash
# Key differences from Sub-Agents:
- Sub-Agents: Run within a single session, report only to main agent
- Agent Teams: Independent sessions that can communicate directly with each other

# When to use Agent Teams:
✅ Research and review (multiple perspectives simultaneously)
✅ New modules/features (teammates own separate pieces)
✅ Debugging with competing hypotheses (parallel investigation)
✅ Cross-layer coordination (frontend, backend, tests)

# When NOT to use Agent Teams:
❌ Sequential tasks with dependencies
❌ Same-file edits (coordination overhead)
❌ Simple tasks (overkill)
```

### Enable Agent Teams [OFFICIAL]

Agent Teams are disabled by default. Enable in settings:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Or set the environment variable:

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
claude
```

### Starting a Team [OFFICIAL]

```bash
# Describe the task and team structure
> "Create an agent team to review PR #142. Spawn three reviewers:
   - One focused on security implications
   - One checking performance impact
   - One validating test coverage
   Have them each review and report findings."

# Claude creates the team and coordinates work
# Use Shift+Up/Down to select and message teammates directly
```

### Team Display Modes [OFFICIAL]

| Mode | Description | Best For |
|------|-------------|----------|
| `in-process` | All teammates in main terminal | Any terminal, simple setup |
| `tmux` | Each teammate in own pane | Parallel visibility, tmux/iTerm2 |
| `auto` (default) | Uses tmux if already in tmux session | Automatic selection |

Configure in settings:

```json
{
  "teammateMode": "in-process"
}
```

Or via CLI flag:

```bash
claude --teammate-mode in-process
```

### Team Controls [OFFICIAL]

```bash
# Select teammates
Shift+Up/Down          # Cycle through teammates

# View teammate session
Enter                  # View selected teammate's session
Escape                 # Interrupt teammate's turn

# Manage tasks
Ctrl+T                 # Toggle shared task list

# Delegate mode
Shift+Tab              # Toggle delegate mode (lead only coordinates, doesn't implement)

# Shut down
> "Ask the researcher teammate to shut down"
> "Clean up the team"
```

### Team Architecture [OFFICIAL]

| Component | Description |
|-----------|-------------|
| **Team Lead** | Main session that creates team, spawns teammates, coordinates work |
| **Teammates** | Independent Claude Code instances working on assigned tasks |
| **Task List** | Shared work items that teammates claim and complete |
| **Mailbox** | Messaging system for inter-agent communication |

**Storage Locations:**
- Team config: `~/.claude/teams/{team-name}/config.json`
- Task list: `~/.claude/tasks/{team-name}/`

### Team Hooks [OFFICIAL]

Use hooks to enforce quality gates:

```json
{
  "hooks": {
    "TeammateIdle": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ ! -f ./dist/output.js ]; then echo \"Build artifact missing\" >&2; exit 2; fi'"
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if ! npm test 2>&1; then echo \"Tests failing\" >&2; exit 2; fi'"
          }
        ]
      }
    ]
  }
}
```

- **TeammateIdle**: Runs when teammate about to go idle. Exit code 2 sends feedback and keeps teammate working.
- **TaskCompleted**: Runs when task marked complete. Exit code 2 prevents completion with feedback.

### Current Limitations [OFFICIAL]

- No session resumption with in-process teammates
- Task status can lag (stuck tasks need manual intervention)
- Slow shutdown (teammates finish current work first)
- One team per session
- No nested teams (teammates can't spawn teams)
- Fixed lead (can't promote teammates)
- Permissions set at spawn (can't pre-set per-teammate)
- Split panes require tmux or iTerm2

**Source:** [Agent Teams](https://code.claude.com/docs/en/agent-teams)

---

## Plugins

**Plugins bundle Skills, Hooks, and MCP servers for easy sharing.**

### What Are Plugins? [OFFICIAL]

Plugins are packages that extend Claude Code:

```bash
# A plugin can contain:
- Skills (capabilities and workflow templates)
- Hooks (automation)
- MCP Servers (external integrations)
- Sub-Agent definitions
```

### Plugin Management [OFFICIAL]

```bash
# Interactive plugin management
> /plugin

# Options:
- Browse marketplace
- Install plugins
- Enable/disable plugins
- Remove plugins
- Add custom marketplaces
- Search installed plugins [v2.1.14]
```

**Plugin Pinning** [NEW v2.1.14]: Plugins can now be pinned to specific git commit SHAs for version stability:

```json
{
  "plugins": {
    "enabledPlugins": {
      "security-toolkit@official#abc123def": true
    }
  }
}
```

### Plugin Structure [OFFICIAL]

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Metadata
├── commands/                 # Legacy commands (treated as skills)
│   └── my-command.md
├── skills/                   # Skills
│   └── my-skill/
│       └── SKILL.md
├── hooks.json               # Hook definitions
└── agents/                  # MCP servers & sub-agents
    └── mcp.json
```

**plugin.json:**
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My awesome plugin",
  "author": "Your Name",
  "homepage": "https://github.com/user/plugin",
  "keywords": ["productivity", "testing"]
}
```

### Installing Plugins [OFFICIAL]

```bash
# From marketplace
> /plugin
# Select "Browse marketplace"
# Choose and install

# Team Configuration
# .claude/settings.json
{
  "plugins": {
    "enabledPlugins": {
      "security-toolkit@official": true,
      "custom-workflows@team": true
    }
  }
}
```

### Creating Custom Marketplaces [OFFICIAL]

```json
{
  "extraKnownMarketplaces": [
    {
      "name": "company-internal",
      "type": "github",
      "url": "https://github.com/company/claude-plugins"
    },
    {
      "name": "local-dev",
      "type": "directory",
      "path": "/path/to/plugins"
    }
  ]
}
```

### Plugin Auto-Install for Teams [OFFICIAL]

Configure in `.claude/settings.json` (committed to git):

```json
{
  "plugins": {
    "enabledPlugins": {
      "team-workflows@company": true
    }
  },
  "extraKnownMarketplaces": [
    {
      "name": "company",
      "type": "github",
      "url": "https://github.com/company/claude-plugins"
    }
  ]
}
```

When team members trust the repository, plugins install automatically.

### VSCode Plugin Features [NEW]

When using Claude Code in VSCode:
- **Install count display**: See how many users have installed each plugin
- **Trust warnings**: Security prompts when installing plugins from untrusted sources
- **Native plugin management** [v2.1.16]: Built-in plugin management support in VSCode extension
- **Remote session browsing** [v2.1.16]: OAuth users can browse and resume remote Claude sessions directly from the Sessions dialog
- **`/usage` command** [v2.1.14]: Display current plan usage directly in VSCode
- **Session forking and rewind** [v2.1.19]: Fork sessions and rewind functionality now enabled for all users
- **Python virtual environment activation** [v2.1.21]: Automatic activation ensures `python` and `pip` use the correct interpreter (configure via `claudeCode.usePythonEnvironment` setting)
- **Claude in Chrome integration** [v2.1.27]: Connect Claude Code to Chrome browser for web automation and testing

**Source:** [Plugins](https://code.claude.com/docs/en/plugins)

### Desktop App Features [NEW]

The Claude desktop app provides a native interface for running Claude Code sessions locally and integrating with Claude Code on the web.

**Key Features:**
- **Diff view**: Review Claude's changes file by file before creating a PR, with inline commenting
- **Parallel local sessions with git worktrees**: Run multiple sessions in the same repository, each with isolated worktrees
- **`.worktreeinclude` file**: Automatically copy gitignored files (like `.env`) to new worktrees
- **Launch cloud sessions**: Start Claude Code on the web directly from the desktop app
- **Bundled Claude Code version**: Includes a stable, managed version of Claude Code

**Diff View:**
- Click the diff stats indicator (`+12 -1`) to open the diff viewer
- Click any line to add inline comments
- Press Enter to accept each comment, Cmd+Enter to send all

**Git Worktrees:**
Create a `.worktreeinclude` file in your repository root:
```
.env
.env.local
**/.claude/settings.local.json
```

Files matching these patterns that are also in `.gitignore` will be copied to new worktrees.

**Installation:**
- macOS: https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect
- Windows x64: https://claude.ai/api/desktop/win32/x64/exe/latest/redirect
- Windows ARM64: https://claude.ai/api/desktop/win32/arm64/exe/latest/redirect

**Source:** [Desktop Documentation](https://code.claude.com/docs/en/desktop)

---

## Development Workflows

### Core Development Approach [COMMUNITY]

**Phase 1: Understand**
```bash
# Start by understanding the codebase
> "Read the project structure and explain the architecture"
> "What testing framework is used?"
> "Show me the authentication flow"

# Claude will:
- Read README, package.json, etc.
- Analyze project structure
- Identify key patterns
```

**Phase 2: Plan**
```bash
# For complex features, plan first
> "I need to add user roles and permissions. Create a plan"

# Claude will:
- Break down the feature
- Identify affected files
- Consider edge cases
- Create TodoWrite tasks
```

**Phase 3: Implement**
```bash
# Implement incrementally
> "Implement step 1: Add roles to user model"

# Then verify
> "Run the tests"

# Continue
> "Implement step 2: Add permission checks to API"
```

**Phase 4: Verify**
```bash
# Always verify changes
> "Run all tests"
> "Check for TypeScript errors"
> "Review the changes we made"

# Create commit
> "Create a git commit for these changes"
```

### Task Management with TodoWrite [COMMUNITY]

For complex multi-step work:

```bash
> "Add user authentication system"

# Claude creates todos:
TodoWrite todos=[
  {"content": "Create User model with password hashing", "status": "in_progress", ...},
  {"content": "Implement JWT token generation", "status": "pending", ...},
  {"content": "Add login/register endpoints", "status": "pending", ...},
  {"content": "Add authentication middleware", "status": "pending", ...},
  {"content": "Write integration tests", "status": "pending", ...}
]

# As work progresses, todos update:
# ✅ "Create User model..." - completed
# ⏳ "Implement JWT tokens..." - in_progress
# ⏸️ "Add login/register..." - pending
```

### Parallel vs Sequential Work [COMMUNITY]

**Parallel (Independent Tasks):**
```bash
> "Create these three independent components"

# Claude can work on all simultaneously:
- Component A (no dependencies)
- Component B (no dependencies)
- Component C (no dependencies)
```

**Sequential (Dependencies):**
```bash
> "Set up database, then add user model, then create API"

# Must be done in order:
1. Database setup (others depend on this)
2. User model (API depends on this)
3. API endpoints (depends on model)
```

### Quality Assurance Patterns [COMMUNITY]

**Automated Validation:**
```bash
# After changes, verify automatically
> "Run the following checks:
   - TypeScript compilation
   - Linting
   - All tests
   - Build process"

# Or create a skill:
/verify-changes
```

**Multi-Perspective Review:**
```bash
# Use sub-agents for thorough review
> "Review these changes from multiple perspectives:
   - Security issues
   - Performance implications
   - Code quality
   - Test coverage"

# Launches specialized review agents
```

---

## Tool Synergies

Claude Code's features form a layered automation stack. Understanding how they combine unlocks powerful workflows.

### Quick Reference: 15 Synergy Patterns

| # | Synergy | Use Case |
|---|---------|----------|
| 1 | [Explore → Plan → Code → Commit](#synergy-1-explore--plan--code--commit-official) | Standard development workflow |
| 2 | [Test-Driven Development](#synergy-2-test-driven-development-community) | Quality-first coding |
| 3 | [MCP + Skills](#synergy-3-mcp--skills-official) | External tool integrations |
| 4 | [Skills + Hooks](#synergy-4-skills--hooks-auto-apply--enforce-official) | Auto-apply expertise + enforce rules |
| 5 | [Sub-agents + Background](#synergy-5-sub-agents--background-tasks-official) | Parallel isolated work |
| 6 | [Multi-Claude Workflows](#synergy-6-multi-claude-workflows-community) | Git worktrees for parallelism |
| 7 | [Context Preservation](#synergy-7-context-preservation-across-sessions-community) | Session continuity |
| 8 | [Quality Pipeline](#synergy-8-quality-pipeline-hooks--tests--lint-community) | Automated quality enforcement |
| 9 | [Visual-Driven Development](#synergy-9-visual-driven-development-community) | Screenshots/mockups → code |
| 10 | [Log Analysis Pipeline](#synergy-10-log-analysis-pipeline-official) | Unix pipes + Claude |
| 11 | [Schema-Driven Development](#synergy-11-schema-driven-development-community) | DB schema → types/API/tests |
| 12 | [Dependency Management](#synergy-12-dependency-management-community) | Update + test + fix cycle |
| 13 | [Documentation Generation](#synergy-13-documentation-generation-community) | Codebase → living docs |
| 14 | [Refactoring with Safety](#synergy-14-refactoring-with-safety-net-community) | Large changes without breaking |
| 15 | [Incident Response](#synergy-15-incident-response-community) | Production debugging workflow |

### The Feature Stack [OFFICIAL]

Each feature serves a distinct purpose and they build on each other:

| Layer | Feature | Purpose | Invocation |
|-------|---------|---------|------------|
| **Connection** | MCP | External tools (GitHub, Jira, DBs) | Automatic when configured |
| **Capability** | Skills | Domain expertise + workflows | Auto-activated or via `/skill-name` |
| **Enforcement** | Hooks | Quality gates, auto-actions | Lifecycle events |
| **Isolation** | Sub-agents | Parallel specialized work | Task delegation |
| **Bundling** | Plugins | Package all of the above | Install once |

**Key insight:** MCP connects external systems. Skills provide expertise and workflows (both auto-activated and user-invoked). Hooks enforce standards. Sub-agents isolate heavy work.

### Synergy 1: Explore → Plan → Code → Commit [OFFICIAL]

The recommended workflow from [Anthropic's best practices](https://www.anthropic.com/engineering/claude-code-best-practices):

```bash
# Step 1: Explore - understand what exists
"Read src/auth/ and explain the current authentication flow.
List all files involved and their responsibilities."

# Step 2: Plan - use extended thinking
"Think hard about how to add OAuth2 support. Create a detailed plan
covering: files to modify, new files needed, dependencies, and test strategy."

# Step 3: Code - implement with explicit files
"Implement the OAuth2 changes following the plan. Start with
src/auth/oauth.ts, then update src/auth/index.ts to export it."

# Step 4: Commit - structured message
"Create a commit with message: 'feat(auth): add OAuth2 provider support'"
```

**Why it works:** Each step builds context. Exploring first prevents wrong assumptions. Planning with "think hard" engages extended reasoning. Explicit file names reduce ambiguity.

### Synergy 2: Test-Driven Development [COMMUNITY]

Write tests first, then implement:

```bash
# 1. Write failing tests first
"Write tests for a new validateEmail function in src/utils/validation.ts.
Cover: valid emails, invalid formats, empty input, null input.
Use Jest. The function doesn't exist yet - tests should fail."

# 2. Confirm tests fail
"Run npm test -- --testPathPattern=validation"

# 3. Commit the failing tests
"Commit with message: 'test(validation): add email validation tests (red)'"

# 4. Implement to pass
"Now implement validateEmail in src/utils/validation.ts to pass all tests.
Use a standard regex pattern. No external dependencies."

# 5. Verify and commit
"Run the tests again. If passing, commit: 'feat(validation): implement email validation (green)'"
```

**Why it works:** Tests define the contract before implementation. Claude iterates against concrete targets. Git history shows the TDD discipline.

### Synergy 3: MCP + Skills [OFFICIAL]

MCP servers expose prompts that become skills:

```bash
# Add MCP server
claude mcp add github -- gh-mcp

# Now available as commands:
/github-pr-review      # Review current PR
/github-issues         # List open issues
/github-create-pr      # Create PR from current branch

# Example workflow - complete ticket
/github-issues         # "Show me issue #42"
# Claude fetches issue details via MCP

"Implement the feature described in issue #42.
Follow our patterns in src/features/."

/github-create-pr      # Creates PR linked to issue
```

**Real MCP integrations:** GitHub, Jira, Linear, Notion, PostgreSQL, Slack, Figma, Google Drive. Each adds domain-specific commands.

### Synergy 4: Skills + Hooks (Auto-Apply + Enforce) [OFFICIAL]

Skills activate automatically; hooks enforce at lifecycle events:

```
.claude/
├── skills/
│   └── security-review/
│       └── SKILL.md        # Auto-activates on security-related tasks
└── settings.json           # Hook: block commits if security issues found
```

**Skill definition** (`.claude/skills/security-review/SKILL.md`):
```markdown
---
name: security-review
description: Analyzes code for security vulnerabilities. Activates when
reviewing auth code, API endpoints, or user input handling.
allowed-tools: [Read, Grep, Glob]
---

When activated, check for:
- SQL injection (string concatenation in queries)
- XSS (unescaped user input in HTML)
- Exposed secrets (API keys, passwords in code)
- Broken auth (missing token validation)

Report findings with file:line references and severity.
```

**Hook definition** (in `settings.json`):
```json
{
  "hooks": {
    "PreToolUse": [{
      "tool": "Bash",
      "command": "git commit",
      "script": ".claude/hooks/security-check.sh"
    }]
  }
}
```

**Workflow:**
```bash
"Review the authentication code in src/auth/ for security issues"
# Skill auto-activates, finds issues

"Fix the SQL injection vulnerability in src/auth/login.ts:45"
# You fix it

"Commit the security fix"
# Hook runs security-check.sh before allowing commit
# Blocks if issues remain, allows if clean
```

### Synergy 5: Sub-agents + Background Tasks [OFFICIAL]

Isolate work and run in parallel:

```bash
# Start services in background (Ctrl+B or explicit)
"Run npm run dev in background"
"Run npm test -- --watch in background"

# Check running tasks
/tasks

# Main session: Use explorer agent for research
"Use the explorer agent to find all API endpoints and their handlers"

# Parallel work happening:
# - Background: Dev server on port 3000
# - Background: Test watcher re-running on changes
# - Sub-agent: Scanning codebase for endpoints
# - Main session: Available for next task

# Later, retrieve agent results
"What did the explorer agent find?"
```

**Sub-agent types:** `Explore` (codebase search), `Plan` (architecture), custom agents defined in `.claude/agents/`.

### Synergy 6: Multi-Claude Workflows [COMMUNITY]

Run multiple Claude instances for independent work:

```bash
# Terminal 1: Feature development
cd feature-branch-worktree
claude
"Implement the user dashboard feature"

# Terminal 2: Code review (same repo, different worktree)
cd review-worktree
claude
"Review the changes in the user-dashboard branch for security and performance"

# Terminal 3: Documentation
cd docs-worktree
claude
"Update API documentation based on recent changes"
```

**Advanced: Claude reviewing Claude:**
```bash
# Claude 1 writes code
"Implement rate limiting for the API endpoints in src/api/"

# Claude 2 reviews (different session)
"Review the rate limiting implementation. Check for:
- Edge cases (what happens at exactly the limit?)
- Race conditions (concurrent requests)
- Configuration flexibility (can limits be changed without deploy?)"
```

### Synergy 7: Context Preservation Across Sessions [COMMUNITY]

Combine CLAUDE.md + skills for continuity:

**Project CLAUDE.md:**
```markdown
# Project: E-commerce API

## Current Sprint
- [ ] Implement payment webhooks
- [ ] Add inventory tracking
- [x] User authentication (completed Jan 10)

## Key Decisions
- Using Stripe for payments (see docs/adr/001-payment-provider.md)
- PostgreSQL for inventory (see src/db/schema.sql)

## Commands
npm run dev      # Start on port 3000
npm test         # Run Jest tests
npm run db:seed  # Seed test data
```

**Skill for context loading** (`.claude/skills/resume/SKILL.md`):
```markdown
---
name: resume
description: Resume work on current sprint
---

Read CLAUDE.md and the current sprint tasks.
Check git log for recent commits.
Summarize: what's done, what's in progress, what's next.
Ask what I want to work on.
```

**Usage:**
```bash
claude
/resume
# Claude reads context, summarizes state, ready to continue
```

### Synergy 8: Quality Pipeline (Hooks + Tests + Lint) [COMMUNITY]

Automated quality enforcement:

**Hook configuration:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "tool": "Write",
      "script": "npm run lint:fix -- $FILE"
    }, {
      "tool": "Edit",
      "script": "npm run lint:fix -- $FILE"
    }],
    "PreToolUse": [{
      "tool": "Bash",
      "command": "git commit",
      "script": ".claude/hooks/pre-commit.sh"
    }]
  }
}
```

**Pre-commit hook script:**
```bash
#!/bin/bash
npm run lint || exit 1
npm test || exit 1
echo "All checks passed"
```

**Result:** Every file edit auto-lints. Every commit requires passing tests. Quality enforced without manual intervention.

### Synergy 9: Visual-Driven Development [COMMUNITY]

Use screenshots and mockups as implementation targets:

```bash
# Share a design mockup
"Here's the Figma mockup for the new dashboard @mockups/dashboard.png
Implement this in src/components/Dashboard.tsx using our existing
Button, Card, and Chart components. Match the layout exactly."

# Iterate on visual feedback
"Here's a screenshot of the current result @screenshots/current.png
Compare to the mockup. Fix: the spacing between cards is wrong,
and the chart colors don't match."

# Debug visual issues
"This screenshot shows a layout bug on mobile @bugs/mobile-layout.png
The sidebar overlaps the content. Fix the responsive styles in
src/styles/layout.css"
```

**Why it works:** Claude can see images. Concrete visual targets reduce ambiguity. Iteration is fast.

### Synergy 10: Log Analysis Pipeline [OFFICIAL]

Unix pipes + Claude for real-time analysis:

```bash
# Monitor logs for anomalies
tail -f /var/log/app.log | claude -p "Alert me if you see errors or unusual patterns"

# Analyze crash dumps
cat crash.log | claude -p "Analyze this crash. Identify root cause and suggest fix."

# Parse and summarize
grep "ERROR" app.log | claude -p "Categorize these errors by type and frequency. Which is most critical?"

# CI/CD integration
npm test 2>&1 | claude -p "If tests failed, explain why and suggest fixes"
```

**Why it works:** Claude integrates with Unix pipelines. Composable with existing tools.

### Synergy 11: Schema-Driven Development [COMMUNITY]

Database schema as source of truth:

```bash
# Generate types from schema
"Read prisma/schema.prisma and generate TypeScript interfaces
in src/types/database.ts. Include JSDoc comments explaining each field."

# Create API endpoints from schema
"Based on the User model in schema.prisma, create CRUD endpoints
in src/api/users.ts. Include validation using zod."

# Generate test fixtures
"Read the schema and create realistic test fixtures in
tests/fixtures/users.ts. Cover edge cases: empty strings,
max lengths, special characters."

# Migration safety check
"Compare prisma/schema.prisma with the current database.
Identify breaking changes. Suggest migration strategy."
```

**Why it works:** Schema is the contract. Generate everything from it. Single source of truth.

### Synergy 12: Dependency Management [COMMUNITY]

Update, test, and fix in one flow:

```bash
# Check for updates
"Run npm outdated. For each major update, explain breaking changes
and effort to upgrade."

# Upgrade with safety net
"Upgrade lodash to v5. Run tests. If anything breaks, fix it.
Commit only when tests pass."

# Security audit flow
"Run npm audit. For each vulnerability:
1. Check if we actually use the affected code path
2. If yes, upgrade or find alternative
3. If no, document why it's acceptable"

# License compliance
"Check licenses of all dependencies. Flag any GPL or unknown
licenses. We need MIT/Apache/BSD only."
```

**Why it works:** Dependency management is tedious. Claude handles the research and fixes.

### Synergy 13: Documentation Generation [COMMUNITY]

Codebase exploration → living documentation:

```bash
# API documentation
"Explore src/api/ and generate OpenAPI spec in docs/api.yaml.
Include request/response examples from actual code."

# Architecture documentation
"Analyze the codebase structure. Create docs/ARCHITECTURE.md
explaining: folder structure, data flow, key patterns used."

# Onboarding guide
"Create docs/ONBOARDING.md for new developers. Include:
setup steps, key files to understand first, common tasks,
gotchas you found in the code."

# Changelog from commits
"Read git log for the last month. Generate CHANGELOG.md
grouped by: Features, Fixes, Breaking Changes."
```

**Why it works:** Documentation stays in sync with code. Generated from source, not memory.

### Synergy 14: Refactoring with Safety Net [COMMUNITY]

Large refactors without breaking things:

```bash
# Rename with confidence
"Rename the User class to Account across the entire codebase.
Update all imports, types, and documentation. Run tests after."

# Extract component
"The Dashboard component is 500 lines. Extract the chart logic
into src/components/DashboardChart.tsx. Keep all behavior identical.
Tests must still pass."

# Change data structure
"Migrate from storing user.fullName to user.firstName + user.lastName.
Update: database schema, API responses, frontend display, tests.
Create migration script for existing data."

# Upgrade patterns
"Replace all callback-style async code in src/services/ with
async/await. One file at a time. Test after each file."
```

**Why it works:** TodoWrite tracks progress. Tests verify correctness. Safe incremental changes.

### Synergy 15: Incident Response [COMMUNITY]

Debug production issues systematically:

```bash
# Initial triage
"Production is returning 500 errors. Here's the error log:
[paste log]
Identify the most likely cause. List files to investigate."

# Root cause analysis
"Read the files identified. Trace the code path from
API endpoint to error. Explain exactly where and why it fails."

# Fix with minimal blast radius
"Implement the smallest possible fix. Don't refactor.
Just stop the bleeding. Add a TODO for proper fix later."

# Post-mortem documentation
"Create docs/incidents/2024-01-15-500-errors.md documenting:
what happened, root cause, fix applied, prevention measures."
```

**Why it works:** Structured approach prevents panic. Documentation prevents recurrence.

### Prompting Best Practices [OFFICIAL]

Based on [Anthropic's guidance](https://www.anthropic.com/engineering/claude-code-best-practices):

| Instead of... | Write... |
|---------------|----------|
| "Add tests" | "Write Jest tests for src/utils/date.ts covering: formatDate with valid dates, invalid inputs, and timezone handling" |
| "Fix the bug" | "The login fails when email contains '+'. Fix src/auth/validate.ts:23 to handle plus signs in email addresses" |
| "Review this" | "Review src/api/users.ts for: N+1 queries, missing error handling, and SQL injection risks" |
| "Make it faster" | "Profile the /api/products endpoint. Identify the slowest operation and optimize it. Target: <100ms response" |

**Thinking modes** (escalating reasoning depth):
- `"think"` - Standard extended thinking
- `"think hard"` - More thorough analysis
- `"think harder"` - Deep exploration of options
- `"ultrathink"` - Maximum reasoning budget

**File references:**
```bash
# Use tab-completion or explicit paths
"Read @src/auth/login.ts and explain the authentication flow"

# Multiple files
"Compare @src/api/v1/users.ts and @src/api/v2/users.ts - what changed?"
```

### Key Principles [COMMUNITY]

**1. Understand the "when" of each feature:**

| Feature | Activates When... |
|---------|-------------------|
| MCP | External data/action needed |
| Skills | Context matches description (automatic) |
| Commands | User types `/command` (manual) |
| Hooks | Lifecycle event fires (PreToolUse, PostToolUse, etc.) |
| Sub-agents | Task delegated for isolated work |

**2. Combinations multiply value:**
```
MCP alone           = 1x (fetch data)
MCP + Skill         = 3x (fetch + auto-expertise)
MCP + Skill + Hook  = 9x (fetch + expertise + enforce)
```
Each layer multiplies the previous. Invest in setup.

**3. Prompting is the foundation:**
All synergies fail with vague prompts. Master specificity first:
- Name exact files
- State exact requirements
- Define exact success criteria

**4. We showed 15 synergies. There are many more.**
These patterns are starting points. Combine them, adapt them, discover your own. The best workflows are the ones tailored to your project.

**5. Setup cost amortizes:**
One hour configuring `.claude/` saves hundreds of hours across future sessions. Treat it as infrastructure.

---

## Examples Library

### Example 1: Adding Authentication

```bash
# Understanding current system
> "Analyze the current user management system"

# Planning
> "Create a plan to add JWT-based authentication"

# Implementation
> "Implement the authentication system following the plan"
# (Claude creates TodoWrite tasks and works through them)

# Testing
> "Create comprehensive tests for authentication"

# Security review
> "Review the authentication implementation for security issues"

# Documentation
> "Update the API documentation with authentication endpoints"

# Commit
> "Create a git commit for the authentication feature"
```

### Example 2: Performance Optimization

```bash
# Identify issues
> "Analyze the codebase for performance bottlenecks"

# Create optimization plan
> "Create a plan to optimize the most critical issues found"

# Implement optimizations
> "Implement the database query optimizations"

# Benchmark
> "Create benchmarks to measure the improvements"

# Verify
> "Run the benchmarks and compare before/after"
```

### Example 3: Bug Investigation

```bash
# Provide context
> "Users report login fails intermittently. Here's the error log: [paste log]"

# Investigation with Debug agent
> "Use the debugger agent to investigate this issue"

# Root cause analysis
> "Explain what's causing this and why it's intermittent"

# Fix
> "Implement a fix for this issue"

# Prevention
> "Add tests and logging to prevent this in the future"

# Documentation
> "Update CLAUDE.md with what we learned about this issue"
```

### Example 4: API Migration

```bash
# Analyze current API
> "Document all endpoints in the v1 API"

# Plan migration
> "Create a migration plan from v1 to v2 with these changes: [list changes]"

# Implement new version
> "Implement the v2 API alongside v1"

# Ensure backward compatibility
> "Create a compatibility layer so v1 clients still work"

# Testing
> "Create tests ensuring both v1 and v2 work correctly"

# Documentation
> "Generate migration guide for API consumers"
```

### Example 5: Setting Up CI/CD

```bash
# Research
> "Research GitHub Actions best practices for Node.js projects"

# Create workflow
> "Create a GitHub Actions workflow that:
   - Runs on pull requests
   - Checks TypeScript compilation
   - Runs linting
   - Runs all tests
   - Reports coverage"

# Security scanning
> "Add security scanning to the workflow"

# Deployment
> "Add automatic deployment to staging on merge to main"

# Documentation
> "Document the CI/CD setup in README.md"
```

### Example 6: Multi-Directory Project

```bash
# Add directories
> "Add the frontend and backend directories to the workspace"

# Synchronized changes
> "Update the User type definition in backend and propagate to frontend"

# Cross-project validation
> "Ensure the frontend API calls match the backend endpoints"

# Parallel testing
> "Run backend tests and frontend tests in parallel in background"

# Monitor both
> "Start both dev servers and monitor for errors"
```

### Example 7: Background Development Workflow

```bash
# Start all development services in background
> "Start the frontend dev server in background"
> "Start the backend API server in background"
> "Run tests in watch mode in background"

# Configure status line to track all services
/statusline

# Monitor all services simultaneously
> "Monitor all background processes for errors"

# Claude watches logs from all background tasks
# Identifies issues across services
# Suggests fixes without stopping services

# Fix issues dynamically
> "I see an API timeout error"
# Claude checks backend logs, identifies cause, suggests solution

# Check all background tasks
/bashes

# Stop specific service if needed
/kill <id>
```

### Example 8: Smart Context Management

```bash
# Start major feature development
> "Build a complete user authentication system with JWT, refresh tokens, and password reset"

# Work progresses, context accumulates...
# After reading many files and multiple operations
# Context is getting large

# Use microcompact for intelligent cleanup
/compact "focus"
# Keeps: Current auth work, recent changes, patterns learned
# Removes: Old file reads, completed searches, stale context

# Continue seamlessly with clean context
> "Add two-factor authentication to the system"
# Full context available for current authentication work

# Major context switch to new feature
/compact
# Complete reset for fresh start

> "Implement Stripe payment integration"
# Clean slate for payment feature
```

### Example 9: Security-First Development

```bash
# Plan with security considerations
> "Design a user input handling system for our forms. Focus on security best practices"

# Implement with immediate security review
> "Implement the form validation system"
> "Review the form validation code for security vulnerabilities"

# Fix identified issues
> "Fix the XSS vulnerability in the email field validation"
> "Verify the fix addresses all injection vectors"

# Document security patterns
> "Update CLAUDE.md with our input validation security patterns"

# Set up continuous security monitoring
> "Create a GitHub Action that runs security scans on every PR"
```

### Example 10: Full-Stack Multi-Repo Development

```bash
# Initialize multi-repo workspace
/add-dir ~/projects/backend
/add-dir ~/projects/frontend
/add-dir ~/projects/shared-types

# Synchronize type definitions across projects
> "Update the User type in shared-types and ensure backend and frontend are consistent"

# Parallel type checking
> "Run TypeScript type checking in all three projects simultaneously in background"

# Monitor and fix type errors
> "Check background tasks for any type errors"
> "Fix type mismatches found in frontend"

# Cross-repo validation
> "Verify that all API types in backend match the frontend client expectations"

# Start all dev servers
> "Start backend server, frontend server, and type watching in background"

# Unified development experience
> "Build the checkout flow, coordinating changes across backend API and frontend UI"
# Claude makes coordinated changes across all repos
```

---

## Best Practices

### For Developers [COMMUNITY]

**1. Set Up CLAUDE.md First**
```markdown
- Document your project structure
- List important commands
- Note conventions and patterns
- Add known gotchas
- Update it as you learn
```

**2. Use Descriptive Requests**
```bash
# Good
> "Add input validation to the login endpoint, checking email format and password length"

# Less effective
> "Fix login"
```

**3. Verify Changes**
```bash
# Always review before committing
> "Show me all the changes made"
> "Run tests to verify the changes"
```

**4. Incremental Development**
```bash
# Break large features into steps
> "First, let's add the database model"
> "Now add the API endpoint"
> "Finally, add the frontend form"
```

**5. Leverage Tools Intelligently**
```bash
# Use Grep for finding patterns
> "Find all database queries using raw SQL"

# Use Glob for file discovery
> "Find all test files"

# Use sub-agents for exploration
> "Have an Explore agent map out the authentication flow"
```

### Decision Patterns [COMMUNITY]

Quick decision trees for common scenarios:

**Something's not working:**
```
→ Can you reproduce it?
  → Yes: Debug systematically
  → No: Gather more info first
→ Did it work before?
  → Yes: Check recent changes (git diff)
  → No: Check assumptions
→ Is error message clear?
  → Yes: Address directly
  → No: Trace execution with logging
```

**Adding a new feature:**
```
→ Similar feature exists?
  → Yes: Follow that pattern
  → No: Research best practices
→ Touches existing code?
  → Yes: Understand it first (read, analyze)
  → No: Design in isolation
→ Has complex logic?
  → Yes: Break down first (use TodoWrite)
  → No: Implement directly
```

**Code seems slow:**
```
→ Measured it? → No: Profile first
→ Know the bottleneck? → No: Find it (use ultrathink)
→ Have solution? → No: Research, then implement and measure again
```

**Recovery When Things Go Wrong:**
```bash
# Establish facts
> "What's the current state of the codebase?"

# Find smallest step forward
> "What's the simplest fix that would work?"

# Question assumptions
> "Let me re-read the relevant code"

# Find solid ground
> "Let's revert to the last working state with /rewind"
```

**Complexity-Driven Approach:**
| Task Type | Approach |
|-----------|----------|
| Trivial (typo fix) | Just fix it |
| Simple (add button) | Quick implementation |
| Medium (new feature) | Plan → Implement → Test |
| Complex (architecture) | Research → Design → Prototype → Implement → Migrate |
| Unknown | Explore to assess, then choose approach |

### For Teams [COMMUNITY]

**1. Share Configuration**
```bash
# Commit to git:
.claude/
├── settings.json      # Shared permissions and config
├── commands/          # Team workflows
├── skills/            # Team Skills
└── agents/            # MCP servers & sub-agents

# Git-ignore:
.claude/settings.local.json  # Personal overrides
```

**2. Document Patterns in CLAUDE.md**
```markdown
## Team Conventions
- All API routes follow RESTful patterns
- Database migrations use Prisma
- Tests use the AAA pattern (Arrange, Act, Assert)
- Never commit directly to main
```

**3. Create Workflow Skills**
```bash
# .claude/skills/
├── code-review/
│   └── SKILL.md
├── deploy-staging/
│   └── SKILL.md
├── run-checks/
│   └── SKILL.md
└── security-audit/
    └── SKILL.md
```

**4. Use Hooks for Standards**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {"type": "command", "command": "eslint-check.sh"}
        ]
      }
    ]
  }
}
```

### For Security [COMMUNITY]

**1. Protect Sensitive Files**
```json
{
  "permissions": {
    "deny": {
      "Write": ["*.env", ".env.*", "*.key", "*.pem"],
      "Edit": ["*.env", ".env.*", "*.key", "*.pem", ".git/*"]
    }
  }
}
```

**2. Review Before Execution**
```json
{
  "permissions": {
    "defaultMode": "ask"
  }
}
```

**3. Use Hooks for Auditing**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date): $TOOL_NAME\" >> .claude/audit.log"
          }
        ]
      }
    ]
  }
}
```

**4. Regular Security Reviews**
```bash
# Use security review Skill or command
> "Perform a security audit of the authentication system"
```

---

## Troubleshooting

### Common Issues [COMMUNITY]

**Issue: "Context too large" error**
```bash
# Solution 1: Compact context
> /compact

# Solution 2: Smart cleanup
> /compact "focus"

# Prevention: Regular compaction in long sessions
```

**Issue: Edit tool fails with "string not found"**
```bash
# Solution: Read the file first to see exact content
> Read the file to see the exact string

# Ensure exact match including:
- Whitespace and indentation
- Line breaks
- Special characters

# Use larger context if string appears multiple times
```

**Issue: Permission denied**
```bash
# Solution 1: Grant permission when asked

# Solution 2: Pre-configure in settings.json
{
  "permissions": {
    "allow": {
      "Bash": ["npm test"],
      "Edit": {}
    }
  }
}

# Check current permissions
> /hooks  # Shows hook configuration
```

**Issue: Claude doesn't see recent file changes**
```bash
# Solution: Explicitly ask to re-read
> "Read the app.ts file again"

# Or provide the changes
> "I just updated the config, here's what changed: [paste]"
```

**Issue: Background task not responding**
```bash
# Check status
> /bashes

# Kill if stuck
> /kill <id>

# Restart
> "Start the dev server again in background"
```

**Issue: Git operations fail**
```bash
# Check git status
> "Run git status"

# Common fixes:
- Unstaged changes: "git add the files first"
- Merge conflicts: "Show me the conflicts and help resolve"
- Branch issues: "Switch to the correct branch"
```

**Issue: MCP server not working**
```bash
# Check configuration
> "Show me the MCP configuration"

# Verify server is running
> "Check if the MCP server started correctly"

# Check logs
~/.claude/logs/mcp-<server-name>.log

# Reinstall
> "Reinstall the MCP server package"
```

### Error Recovery Patterns [COMMUNITY]

**Systematic approaches to common error scenarios.**

#### Session Recovery After Disconnect

```bash
# If session disconnects mid-task:
1. Check recent history:
   > "What was I working on?"

2. Review file changes:
   git diff

3. Reconstruct state:
   > "Based on recent changes, continue where we left off"
```

#### Hook Failures

```bash
# If hook blocks unexpectedly:
1. Check hook output:
   claude --debug

2. Test hook manually:
   echo '{"tool_name":"Edit","tool_input":{...}}' | ~/.claude/hooks/script.sh

3. Temporarily disable:
   mv ~/.claude/settings.json ~/.claude/settings.json.bak

4. Fix and restore:
   # Fix the hook script, then restore settings
```

#### Context Overflow Mid-Task

```bash
# When "context too large" appears during complex work:

# Quick recovery:
> /compact "focus"
> "Continue with [brief task summary]"

# Full reset if needed:
> /compact
> "Let me brief you: [key context]"

# Prevention:
- Use /compact "focus" every ~50 operations
- Start fresh sessions for new features
```

#### Tool Permission Issues

```bash
# When permissions repeatedly requested:

# Grant permanently:
{
  "permissions": {
    "allow": {
      "Bash": {},      # Allow all bash
      "Edit": {},      # Allow all edits
      "Write": {}      # Allow all writes
    }
  }
}

# Or specific patterns:
{
  "permissions": {
    "allow": {
      "Bash": ["npm test", "npm run build"]
    }
  }
}
```

#### Network/API Timeouts

```bash
# If operations timeout:

# Retry with backoff:
1st attempt → fails
Wait 2s → retry
Wait 4s → retry
Wait 8s → retry

# Switch model if persistent:
> "Use a different model to try this"

# Check network:
ping anthropic.com
curl -v https://api.anthropic.com
```

#### Lost Work Recovery

```bash
# If changes weren't saved:

1. Check git:
   git status
   git diff

2. Check file backups:
   ls -la ~/.claude/backups/

3. Review session transcript:
   # Transcripts saved in ~/.claude/transcripts/

4. Reconstruct from memory:
   > "Based on our conversation, recreate the [feature]"
```

#### Debug Mode for Persistent Issues

```bash
# Enable comprehensive debugging:
claude --debug --log-level trace

# Follow logs in real-time:
tail -f ~/.claude/logs/claude.log

# Filter for specific issues:
grep -i error ~/.claude/logs/claude.log
grep -i "mcp" ~/.claude/logs/claude.log
```

---

## Security Considerations

### Security Model [OFFICIAL]

Claude Code operates with:

**1. Permission System**
- Tools require explicit permission
- Permissions are session-specific
- Can be pre-configured in settings

**2. Sandboxing** (macOS/Linux)
```json
{
  "sandbox": {
    "enabled": true,
    "allowUnsandboxedCommands": false
  }
}
```

**3. File Access Control**
```json
{
  "permissions": {
    "additionalDirectories": ["/allowed/path"],
    "deny": {
      "Read": ["*.key", "*.pem"],
      "Write": ["*.env"],
      "Edit": [".git/*"]
    }
  }
}
```

### Best Security Practices [COMMUNITY]

**1. Never Commit Secrets**
```bash
# Block in settings
{
  "permissions": {
    "deny": {
      "Write": ["*.env", "*.key", "*.pem", "*secret*"],
      "Edit": ["*.env", "*.key", "*.pem", "*secret*"]
    }
  }
}

# Use hooks to scan for secrets
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {"type": "command", "command": "detect-secrets-hook.sh"}
        ]
      }
    ]
  }
}
```

**2. Review AI-Generated Code**
```bash
# Always review before deploying
> "Explain the security implications of this code"
> "Review this for potential vulnerabilities"
```

**3. Limit Tool Access**
```json
// For sub-agents doing analysis
{
  "allowedTools": ["Read", "Grep", "Glob"]  // No modifications
}

// For implementation agents
{
  "allowedTools": ["Read", "Write", "Edit", "Bash"]  // Can modify
}
```

**4. Audit Trails**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "logger.sh"  // Log all operations
          }
        ]
      }
    ]
  }
}
```

**5. Network Restrictions**
```json
{
  "sandbox": {
    "network": {
      "allowUnixSockets": ["/var/run/docker.sock"],
      "allowLocalBinding": true,
      "httpProxyPort": 8080
    }
  }
}
```

**Source:** [Settings](https://code.claude.com/docs/en/settings), [Sandboxing](https://code.claude.com/docs/en/sandboxing)

---

## SDK Integration

**Claude Code can be used programmatically via TypeScript/Python SDKs.**

### Use Cases [OFFICIAL]

- Automate workflows in CI/CD
- Build custom tools on top of Claude Code
- Create automated code review systems
- Integrate into existing development tools
- Batch process multiple projects

### TypeScript SDK Example [OFFICIAL]

```typescript
import { ClaudeCodeSDK } from '@anthropic-ai/claude-code';

const sdk = new ClaudeCodeSDK({
  apiKey: process.env.ANTHROPIC_API_KEY
});

// Start a session
const session = await sdk.startSession({
  projectDir: '/path/to/project',
  systemPrompt: 'You are a code reviewer'
});

// Send a task
const response = await session.chat({
  message: 'Review this codebase for security issues'
});

console.log(response.content);

// End session
await session.end();
```

### Python SDK Example [OFFICIAL]

```python
from anthropic_sdk import ClaudeCodeSDK

sdk = ClaudeCodeSDK(api_key=os.environ["ANTHROPIC_API_KEY"])

# Start session
session = sdk.start_session(
    project_dir="/path/to/project",
    system_prompt="You are a test generator"
)

# Send task
response = session.chat(
    message="Generate tests for all API endpoints"
)

print(response.content)

# End session
session.end()
```

**Source:** [SDK Overview](https://code.claude.com/docs/en/sdk/sdk-overview)

---

## Experimental Concepts

> ⚠️ **Warning**: This section contains theoretical concepts and patterns that are NOT verified in official documentation. These are experimental ideas for power users to explore.

### Concept: Cognitive Modes [EXPERIMENTAL]

**Unverified theory** about optimizing Claude's approach based on task type:

```bash
# Simple Creation Mode
> "Create 5 similar React components"
# Theory: Parallel processing, template-based

# Optimization Mode
> "Optimize this algorithm"
# Theory: Deep analysis, multiple approaches

# Research Mode
> "Research and implement best practice for X"
# Theory: Web search → analysis → implementation pipeline
```

**Status**: No official documentation supports "modes". Claude Code uses the same model for all tasks.

### Concept: Kernel Architecture [EXPERIMENTAL]

**Unverified theoretical framework** about multi-layered intelligence:

```
Theory:
┌─────────────────┐
│   Orchestrator  │
└────────┬────────┘
         │
    ┌────┴────┬────────┬─────────┐
    │         │        │         │
  Memory   Intent  Extract  Validate
  Kernel   Kernel  Kernel   Kernel
```

**Status**: This is a conceptual model, not an actual Claude Code feature. Claude Code uses:
- Sub-agents (real feature)
- Skills (real feature)
- Hooks (real feature)

But NOT a "kernel architecture" system.

### Concept: Meta-Todo System [EXPERIMENTAL]

**Unverified theory** about advanced task management with AI validation:

```bash
# Theory: Multi-agent task validation
1. Intent Capture (4 approaches)
2. Multi-Agent Validation
3. Background Execution
4. Learning Integration
```

**Status**: TodoWrite is a real tool, but "meta-todo" with multi-agent validation is theoretical. Use the actual TodoWrite tool as documented.

### Why These Are Separate [EDITORIAL]

The original guide mixed:
- **Real features** (Skills, Hooks, MCP)
- **Usage patterns** (how to use features)
- **Theoretical frameworks** (unverified concepts)

This caused confusion about what Claude Code actually does vs. conceptual ideas.

**For AI Agents reading this**: Focus on sections marked `[OFFICIAL]` and `[COMMUNITY]`. Treat `[EXPERIMENTAL]` as ideas to test, not established features.

---

## Additional Resources

### Official Documentation [OFFICIAL]
- **Main Docs**: https://code.claude.com/docs/en/overview
- **CLI Reference**: https://code.claude.com/docs/en/cli-reference
- **Settings**: https://code.claude.com/docs/en/settings
- **Skills**: https://code.claude.com/docs/en/skills
- **Hooks**: https://code.claude.com/docs/en/hooks
- **MCP**: https://code.claude.com/docs/en/mcp
- **Sub-Agents**: https://code.claude.com/docs/en/sub-agents
- **Plugins**: https://code.claude.com/docs/en/plugins

### Community Resources [COMMUNITY]
- **GitHub**: https://github.com/anthropics/claude-code
- **Awesome Claude Code**: https://github.com/hesreallyhim/awesome-claude-code
- **Awesome Claude Skills**: https://github.com/travisvn/awesome-claude-skills

### Getting Help
- **GitHub Issues**: https://github.com/anthropics/claude-code/issues
- **Discord**: Check Anthropic's community channels
- **Documentation**: https://code.claude.com

---

## Changelog

### Claude Code CLI Releases [OFFICIAL]

For complete details, see the [official CHANGELOG.md](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md).

**Version 2.1.39** (February 10, 2026) - Latest
- ⚡ Improved terminal rendering performance
- 🐛 Fixed fatal errors being swallowed instead of displayed
- 🐛 Fixed process hanging after session close
- 🐛 Fixed character loss at terminal screen boundary
- 🐛 Fixed blank lines in verbose transcript view

**Version 2.1.38** (February 10, 2026)
- 🐛 Fixed VS Code terminal scroll-to-top regression (introduced in 2.1.37)
- 🐛 Fixed Tab key queueing slash commands instead of autocompleting
- 🐛 Fixed bash permission matching for commands using environment variable wrappers
- 🐛 Fixed text between tool uses disappearing when not using streaming
- 🐛 Fixed duplicate sessions when resuming in VS Code extension
- 🔒 Improved heredoc delimiter parsing to prevent command smuggling
- 🔒 Blocked writes to `.claude/skills` directory in sandbox mode

**Version 2.1.37** (February 7, 2026)
- 🐛 Fixed `/fast` not being immediately available after enabling `/extra-usage`

**Version 2.1.36** (February 7, 2026)
- ⚡ **Fast mode is now available for Opus 4.6** [NEW]

**Version 2.1.34** (February 6, 2026)
- 🐛 Fixed crash when agent teams setting changed between renders
- 🐛 Fixed commands excluded from sandboxing bypassing Bash ask permission when `autoAllowBashIfSandboxed` was enabled

**Version 2.1.33** (February 6, 2026)
- 🤖 Agent teammate sessions in tmux now correctly send and receive messages
- 🪝 Added `TeammateIdle` and `TaskCompleted` hook events for multi-agent workflows [NEW]
- 🔧 Added support for restricting sub-agents via `Task(agent_type)` syntax
- 📝 Added `memory` frontmatter field for agents (`user`, `project`, or `local` scope)
- 🔌 Plugin names now shown in skill descriptions for better discoverability
- 🐛 Fixed extended thinking interruption when submitting new messages
- 🐛 Fixed API proxy 404 errors on streaming endpoints
- 🐛 Fixed proxy settings via `settings.json` environment variables not applying to WebFetch
- 📊 Improved `/resume` session picker with clean titles (removed raw XML markup)
- 📝 Enhanced error messages for API connection failures (shows specific causes like ECONNREFUSED, SSL errors)
- 🔌 [VSCode] Added remote session support with OAuth
- 🔌 [VSCode] Added git branch and message count to session picker with branch name search
- 🔌 [VSCode] Fixed scroll-to-bottom under-scrolling on session load/switch

**Version 2.1.32** (February 5, 2026)
- ✨ **Claude Opus 4.6 is now available!** [NEW]
- 🤖 Added research preview **Agent Teams** feature for multi-agent collaboration [NEW]
- 🧠 Claude now automatically records and recalls **memories** as it works [NEW]
- 📊 Added "Summarize from here" to message selector for partial conversation summarization
- 📁 Skills in `.claude/skills/` within additional directories (`--add-dir`) now load automatically
- 🐛 Fixed `@` file completion showing incorrect relative paths from subdirectories
- 🔄 `--resume` now re-uses `--agent` value from previous conversation
- 🐛 Fixed bash "Bad substitution" errors with heredocs containing JavaScript template literals
- 📊 Skill character budget now scales with context window (2% of context)
- 🐛 Fixed Thai/Lao spacing vowels rendering issues
- 🔌 [VSCode] Fixed slash commands incorrectly executing with preceding text
- 🔌 [VSCode] Added spinner when loading past conversations

**Version 2.1.31** (February 4, 2026)
- 💡 Added session resume hint on exit showing how to continue conversations later
- 🌐 Added full-width (zenkaku) space input support from Japanese IME in checkbox selection
- 🤖 Improved system prompts to guide model toward dedicated tools (Read, Edit, Glob, Grep) instead of bash equivalents
- 🐛 Fixed PDF too large errors permanently locking up sessions
- 🐛 Fixed bash commands incorrectly reporting "Read-only file system" errors in sandbox mode
- 🐛 Fixed crashes after entering plan mode with missing default fields in `~/.claude.json`
- 🐛 Fixed `temperatureOverride` being ignored in streaming API path
- 🐛 Fixed LSP shutdown/exit compatibility with strict language servers
- ⚡ Reduced terminal layout jitter during spinner animations
- 📝 Better PDF and request size error messages (shows actual limits: 100 pages, 20MB)
- 💰 Removed misleading Anthropic API pricing display for third-party provider users (Bedrock, Vertex, Foundry)

**Version 2.1.30** (February 3, 2026)
- 📄 Added `pages` parameter for Read tool with PDFs (e.g., `pages: "1-5"`) [NEW]
- 📄 Large PDFs (>10 pages) now return lightweight reference when @mentioned
- 🔑 Added pre-configured OAuth credentials for MCP servers without Dynamic Client Registration
- 🔍 Added `/debug` command for troubleshooting sessions [NEW]
- 📊 Added token count, tool uses, and duration metrics in Task results
- ♿ Added reduced motion mode configuration option (`prefersReducedMotion` setting) [NEW]
- 🐛 Fixed phantom "(no content)" text blocks in API conversation history
- 🐛 Fixed prompt cache invalidation (now correctly revalidates on tool description/schema changes)
- 🐛 Fixed 400 errors after `/login` with thinking blocks in conversation
- 🐛 Fixed hangs when resuming sessions with corrupted transcripts
- 🐛 Fixed rate limit messages for Max 20x users
- 🐛 Fixed subagents unable to access SDK-provided MCP tools
- 🐛 Fixed Windows bash execution failure with `.bashrc` files
- 🐛 Fixed duplicate sessions in VSCode
- ⚡ 68% memory reduction for `--resume` with many sessions
- 📊 `TaskStop` tool now displays stopped command/task description
- ⚡ `/model` executes immediately instead of queuing
- ⌨️ [VSCode] Multiline input in question dialogs (Shift+Enter)

**Version 2.1.29** (January 31, 2026)
- ⚡ Fixed startup performance issues when resuming sessions with `saved_hook_context`

**Version 2.1.27** (January 30, 2026)
- 🔗 Added `--from-pr` flag to resume sessions linked to specific GitHub PR number or URL
- 🔗 Sessions now automatically link to PRs when created via `gh pr create`
- 🔒 Permissions now respect content-level `ask` over tool-level `allow` (e.g., `allow: ["Bash"], ask: ["Bash(rm *)"]`)
- 🔍 Tool call failures and denials now added to debug logs
- 🐛 Fixed `/context` command colored output display
- 🐛 Fixed status bar duplicating background task indicator with PR status
- 🔌 [VSCode] Enabled Claude in Chrome integration
- 🪟 [Windows] Fixed bash command execution failing for users with `.bashrc` files
- 🪟 [Windows] Fixed console windows flashing when spawning child processes
- 🔌 [VSCode] Fixed OAuth token expiration causing 401 errors after extended sessions

**Version 2.1.25** (January 29, 2026)
- 🔧 Fixed beta header validation error for gateway users on Bedrock and Vertex
- 💡 Workaround: Set `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` to avoid the error

**Version 2.1.23** (January 29, 2026)
- ⚙️ Added customizable spinner verbs setting (`spinnerVerbs`)
- 🔧 Fixed mTLS and proxy connectivity for users behind corporate proxies or using client certificates
- 🔧 Fixed per-user temp directory isolation to prevent permission conflicts on shared systems
- 🐛 Fixed race condition causing 400 errors when prompt caching scope was enabled
- 🐛 Fixed pending async hooks not being cancelled when headless streaming sessions ended
- 🐛 Fixed tab completion not updating the input field when accepting a suggestion
- 🐛 Fixed ripgrep search timeouts silently returning empty results instead of reporting errors
- ⚡ Improved terminal rendering performance with optimized screen data layout
- ⏱️ Changed Bash commands to show timeout duration alongside elapsed time
- 🟣 Changed merged pull requests to show purple status indicator in prompt footer
- 🔌 [IDE] Fixed model options displaying incorrect region strings for Bedrock users in headless mode

**Version 2.1.22** (January 28, 2026)
- 🔧 Fixed structured outputs for non-interactive (-p) mode

**Version 2.1.21** (January 28, 2026)
- 🌐 Added support for full-width (zenkaku) number input from Japanese IME in option selection prompts
- 🐛 Fixed shell completion cache files being truncated on exit
- 🐛 Fixed API errors when resuming sessions that were interrupted during tool execution
- 🐛 Fixed auto-compact triggering too early on models with large output token limits
- 🐛 Fixed task IDs potentially being reused after deletion
- 🐛 Fixed file search not working in VS Code extension on Windows
- 📊 Improved read/search progress indicators to show "Reading…" while in progress and "Read" when complete
- 🤖 Improved Claude to prefer file operation tools (Read, Edit, Write) over bash equivalents (cat, sed, awk)
- 🐍 [VSCode] Added automatic Python virtual environment activation (`claudeCode.usePythonEnvironment` setting)
- 🔌 [VSCode] Fixed message action buttons having incorrect background colors

**Version 2.1.20** (January 27, 2026)
- ⌨️ Arrow key history navigation in vim normal mode
- ⌨️ External editor shortcut (Ctrl+G) added to help menu
- 📊 PR review status indicator in prompt footer (approved/changes requested/pending/draft)
- 📁 Support for loading `CLAUDE.md` from additional directories via `--add-dir` (requires `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`)
- 🗑️ Task deletion via `TaskUpdate` tool
- 📱 Dynamic task list adjustment based on terminal height
- 📋 `/copy` command now available to all users
- ⚙️ Config backups now timestamped and rotated (keeps 5 most recent)
- 🐛 Fixed session compaction issues causing full history to load on resume
- 🐛 Fixed agents ignoring user messages during active work
- 🐛 Fixed wide character (emoji, CJK) rendering artifacts
- 🐛 Fixed JSON parsing errors with special Unicode in MCP responses
- 🐛 Fixed draft prompt loss when navigating command history
- 🐛 Fixed crashes when cancelling tool use

**Version 2.1.19** (January 23, 2026)
- ✨ Added env var `CLAUDE_CODE_ENABLE_TASKS` - set to `false` to use legacy task system
- ✨ Added shorthand `$0`, `$1`, etc. for accessing individual arguments in custom commands
- 🔄 Changed indexed argument syntax from `$ARGUMENTS.0` to `$ARGUMENTS[0]` (bracket syntax)
- ✅ Skills without additional permissions/hooks no longer require approval
- 🐛 Fixed crashes on processors without AVX instruction support
- 🐛 Fixed dangling Claude Code processes when terminal is closed (EIO error handling, SIGKILL fallback)
- 🐛 Fixed `/rename` and `/tag` not updating correct session when resuming from different directory
- 🐛 Fixed resuming sessions by custom title from different directories
- 🐛 Fixed pasted text loss when using prompt stash (Ctrl+S)
- 🐛 Fixed agent list displaying "Sonnet (default)" instead of "Inherit (default)"
- 🐛 Fixed backgrounded hook commands not returning early
- 🐛 Fixed file write preview omitting empty lines
- 🔌 [SDK] Added replay of `queued_command` attachment messages as `SDKUserMessageReplay` events
- 🔌 [VSCode] Enabled session forking and rewind functionality for all users

**Version 2.1.17** (January 22, 2026)
- 🔧 Fixed crashes on processors without AVX instruction support

**Version 2.1.16** (January 22, 2026)
- ✨ New task management system with dependency tracking
- 🔌 [VSCode] Native plugin management support
- 🔌 [VSCode] OAuth users can browse and resume remote Claude sessions from Sessions dialog
- 🐛 Fixed out-of-memory crashes when resuming sessions with heavy subagent usage
- 🐛 Fixed "context remaining" warning not hiding after running `/compact`
- 🐛 Fixed session titles on resume screen not respecting user's language setting
- 🪟 [IDE] Fixed race condition on Windows where Claude Code sidebar view container would not appear on start

**Version 2.1.15** (January 21, 2026)
- ⚠️ Added deprecation notification for npm installations - users directed to run `claude install` or visit https://docs.anthropic.com/en/docs/claude-code/getting-started
- ⚡ Improved UI rendering performance with React Compiler
- 🐛 Fixed "Context left until auto-compact" warning not disappearing after `/compact`
- 🐛 Fixed MCP stdio server timeout not killing child process, causing UI freezes

**Version 2.1.14** (January 20, 2026)
- ⌨️ History-based autocomplete in bash mode (`!`) - press Tab to complete partial commands
- 🔍 Added search to installed plugins list
- 📌 Support for pinning plugins to specific git commit SHAs
- 🔧 Fixed context window blocking limit calculated too aggressively (~65% instead of ~98%)
- 🐛 Fixed memory issues causing crashes with parallel subagents
- 🐛 Fixed memory leak in long-running sessions with stream resource cleanup
- 🐛 Fixed `@` symbol triggering file autocomplete in bash mode
- 📊 [VSCode] Added `/usage` command to display current plan usage

**Version 2.1.12** (January 17, 2026)
- 🔧 Fixed message rendering bug

**Version 2.1.11** (January 17, 2026)
- 🔧 Fixed excessive MCP connection requests for HTTP/SSE transports

**Version 2.1.10** (January 17, 2026)
- 🪝 New `Setup` hook event triggered via `--init`, `--init-only`, or `--maintenance` CLI flags
- ⌨️ Keyboard shortcut 'c' to copy OAuth URL during login
- 🐛 Fixed bash commands with heredocs containing JavaScript template literals
- ⚡ Improved startup to capture keystrokes before REPL is ready
- 📎 File suggestions now show as removable attachments
- 🔌 [VSCode] Added install count display and trust warning for plugins

**Version 2.1.9** (January 16, 2026)
- ✨ `auto:N` syntax for MCP tool search auto-enable threshold (context window %)
- 📁 `plansDirectory` setting to customize plan file storage location
- ⌨️ External editor support (Ctrl+G) in AskUserQuestion "Other" input
- 🔗 Session URL attribution to commits and PRs from web sessions
- 🪝 `PreToolUse` hooks can now return `additionalContext` to the model
- 🔧 `${CLAUDE_SESSION_ID}` string substitution for skills
- 🐛 Fixed long sessions with parallel tool calls failing with orphan tool_result errors
- 🐛 Fixed MCP server reconnection hanging on cached connection promise
- 🐛 Fixed Ctrl+Z suspend not working in Kitty keyboard protocol terminals

**Version 2.1.7** (January 14, 2026)
- ⚙️ `showTurnDuration` setting to hide turn duration messages
- 💬 Feedback ability for permission prompts
- 📱 Inline agent response display in task notifications
- 🔒 Security fix: wildcard permission rules vulnerability
- 🪟 Windows file sync compatibility improvements
- 🔧 MCP tool search auto mode enabled by default
- 🔗 OAuth/API Console URL migration to `platform.claude.com`

**Version 2.1.6** (January 13, 2026)
- 🔍 Search functionality in `/config` command
- 📊 Date range filtering in `/stats` (7/30 days, all-time)
- 🔄 Updates section in `/doctor` command
- 📁 Nested `.claude/skills` directory discovery
- 📈 `context_window.used_percentage` and `remaining_percentage` status fields
- 🔒 Permission bypass security fix (shell line continuation)

**Version 2.1.5** (January 12, 2026)
- 📁 `CLAUDE_CODE_TMPDIR` environment variable for temp directory override

**Version 2.1.3** (January 9, 2026)
- 🔀 Merged slash commands and skills (simplified mental model)
- 📻 Release channel toggle (`stable`/`latest`) in `/config`
- ⚠️ Permission rules unreachability detection and warnings
- 📝 Fixed plan file persistence across `/clear`
- ⏱️ 10-minute tool hook execution timeout

**Version 2.1.2** (January 9, 2026)
- 🖼️ Source path metadata for dragged images
- 🔗 OSC 8 hyperlinks for file paths (iTerm support)
- 🪟 Windows Package Manager (winget) support
- ⌨️ Shift+Tab in plan mode for "auto-accept edits"
- 🔒 Command injection vulnerability fix in bash processing
- 🧹 Memory leak fix in tree-sitter parse trees
- 💾 Large output persistence to disk instead of truncation

**Version 2.1.0** (December 23, 2025)
- 🔄 Automatic skill hot-reload
- 🔀 `context: fork` support for skill sub-agents
- 🌐 `language` setting for Claude's response language
- ⌨️ Shift+Enter works out-of-box in iTerm2, WezTerm, Ghostty, Kitty
- 📁 `respectGitignore` setting for per-project control
- 🎯 Wildcard pattern matching for Bash tool permissions (`*` syntax)
- ⌨️ Unified `Ctrl+B` backgrounding for bash commands and agents
- 🌐 `/teleport` and `/remote-env` commands for claude.ai subscribers
- ⚡ Agents can define hooks in frontmatter
- ✂️ New Vim motions: `;` and `,` repeat, `y` operator, `p`/`P` paste
- 🔧 `--tools` flag for restricting tool use
- 📄 `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` environment variable
- 🖼️ Cmd+V image paste support in iTerm2

**Version 2.0.74** (December 19, 2025)
- 🔍 **LSP Tool**: Language Server Protocol for code intelligence
- 📍 Go-to-definition, find references, hover documentation
- 🖥️ `/terminal-setup` support for Kitty, Alacritty, Zed, Warp
- 🎨 `Ctrl+T` shortcut in `/theme` for syntax highlighting toggle

**Version 2.0.72** (December 18, 2025)
- 🌐 Claude in Chrome (Beta) with Chrome extension control
- ⚡ ~3x faster `@` file suggestions in git repositories
- ⌨️ Changed thinking toggle from Tab to Alt+T

**Version 2.0.70** (December 16, 2025)
- ⌨️ Enter key submits prompt suggestions immediately (Tab edits)
- 🎯 Wildcard syntax `mcp__server__*` for MCP tool permissions
- 🧠 Improved memory usage (3x reduction for large conversations)

**Version 2.0.67** (December 12, 2025)
- 💡 Claude now suggests prompts (Tab accepts or Enter submits)
- 🧠 Thinking mode enabled by default for Opus 4.5
- 🔍 Search functionality in `/permissions` command

**Version 2.0.65** (December 11, 2025)
- ⌨️ Alt+P (Linux/Windows) or Option+P (macOS) to switch models while typing
- 📊 Context window information in status line
- 🔧 `CLAUDE_CODE_SHELL` environment variable for shell detection

**Version 2.0.64** (December 10, 2025)
- ⚡ Instant auto-compacting
- 🔄 Asynchronous agents and bash commands with wake-up messages
- 📊 `/stats` provides usage stats and engagement metrics
- 📝 Named session support: `/rename` and `/resume <name>`
- 📁 `.claude/rules/` directory support

**Version 2.0.60** (December 6, 2025)
- 🔄 Background agent support (agents run while working)
- 🔧 `--disable-slash-commands` CLI flag
- 📝 Model name in "Co-Authored-By" commit messages
- 🔀 `/mcp enable|disable [server-name]` quick toggles

**Version 2.0.51** (November 24, 2025)
- 🧠 Opus 4.5 released
- 🖥️ Claude Code for Desktop introduced
- 📝 Plan Mode builds more precise plans

**Version 2.0.45** (November 19, 2025)
- ☁️ Azure AI Foundry support
- 🔐 `PermissionRequest` hook for auto-approve/deny logic

**Version 2.0.24** (October 21, 2025)
- 🛡️ Sandbox mode for BashTool on Linux/Mac
- 🌐 Claude Code Web → CLI teleport support

**Version 2.0.20** (October 17, 2025)
- ⭐ Claude Skills for reusable prompt templates

**Version 2.0.12** (October 9, 2025)
- 🔌 Plugin System Released
- `/plugin install`, `/plugin enable/disable`, `/plugin marketplace`

**Version 2.0.10** (October 8, 2025)
- ✨ Rewrote terminal renderer (buttery smooth UI)
- 🔀 `@mention` to enable/disable MCP servers
- ⌨️ Tab completion for shell commands in bash mode
- ✏️ PreToolUse hooks can modify tool inputs
- ⌨️ Press `Ctrl-G` to edit prompt in system text editor

**Version 2.0.0** (September 29, 2025)
- 🆕 New native VS Code extension
- ✨ Fresh UI throughout app
- ⏪ `/rewind` to undo code changes
- 📊 `/usage` for plan limits viewing
- ⌨️ Tab toggles thinking (sticky)
- 🔍 Ctrl-R searches history
- 🤖 SDK became Claude Agent SDK
- 🔧 `--agents` flag for dynamic subagents

### Breaking Changes & Deprecations [OFFICIAL]

**Version 2.1.x Breaking Changes:**

| Change | Migration Path |
|--------|----------------|
| **Windows managed settings path** | Migrate from `C:\ProgramData\ClaudeCode\managed-settings.json` to `C:\Program Files\ClaudeCode\managed-settings.json` |
| **@-mention MCP enable/disable removed** | Use `/mcp enable <name>` or `/mcp disable <name>` instead |
| **Tool hook timeout increased** | Now 10 minutes (was 60 seconds) - update scripts if relying on quick timeouts |
| **SDK minimum zod version** | Requires zod ^4.0.0 as peer dependency |

---

### This Guide's Changelog

**Version 2026.1.13 (February 11, 2026)**
- Updated to v2.1.39 (latest release)
- Added v2.1.38 and v2.1.39 changelog entries:
  - v2.1.39: Terminal rendering performance improvements, fatal error display fix, process hanging fix, screen boundary character fix, verbose transcript blank lines fix
  - v2.1.38: VSCode scroll-to-top regression fix, Tab key autocomplete fix, bash permission matching fix, streaming text fix, duplicate sessions fix, heredoc security improvements, sandbox skills directory protection
- Added **Fast Mode** section to Advanced Features with full documentation:
  - Toggle methods (`/fast` command, settings)
  - Pricing table (standard vs fast mode)
  - Requirements (subscription, extra usage, admin enablement)
  - Use case guidance (when to use vs avoid)
  - Rate limit behavior and fallback

**Version 2026.1.12 (February 9, 2026)**
- Updated to v2.1.37 (latest release)
- Added v2.1.36 and v2.1.37 changelog entries:
  - v2.1.37: Fixed `/fast` not being immediately available after enabling `/extra-usage`
  - v2.1.36: **Fast mode now available for Opus 4.6**
- Added `/extra-usage` and `/fast` slash commands to Usage & Stats section

**Version 2026.1.11 (February 7, 2026)**
- Updated to v2.1.34
- Added v2.1.32 through v2.1.34 changelog entries:
  - v2.1.34: Fixed agent teams settings crash, fixed sandbox permission bypass for excluded commands
  - v2.1.33: TeammateIdle and TaskCompleted hook events, Task(agent_type) restriction syntax, memory frontmatter for agents, improved session picker, VSCode remote session OAuth, multiple bug fixes
  - v2.1.32: **Claude Opus 4.6 available**, **Agent Teams** feature (research preview), **Auto-Memory** feature, "Summarize from here" message selector, skills in --add-dir directories, multiple bug fixes
- Added new **Agent Teams** section with comprehensive documentation:
  - Team architecture (lead, teammates, task list, mailbox)
  - Display modes (in-process, tmux, auto)
  - Team hooks (TeammateIdle, TaskCompleted)
  - Keyboard controls and limitations
- Added **Auto-Memory** feature documentation
- Added `--teammate-mode` CLI flag for agent team display configuration
- Added `TeammateIdle` and `TaskCompleted` hook events to hooks table
- Added `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` and `CLAUDE_CODE_DISABLE_AUTO_MEMORY` environment variables
- Updated Contents table with Agent Teams link

**Version 2026.1.10 (February 5, 2026)**
- Updated to v2.1.31 (latest release)
- Added v2.1.30 and v2.1.31 changelog entries:
  - v2.1.31: Session resume hint on exit, Japanese IME full-width space support, improved tool preference prompts, PDF error handling fixes, sandbox bash fixes, plan mode crash fix, temperature override fix, LSP compatibility improvements, spinner animation improvements, better error messages
  - v2.1.30: PDF `pages` parameter for Read tool, `/debug` command, `prefersReducedMotion` setting, pre-configured OAuth for MCP, Task result metrics, 68% memory reduction for session resume, VSCode multiline input, multiple bug fixes
- Added PDF `pages` parameter documentation to Read tool section
- Added `/debug` slash command for troubleshooting sessions
- Added `prefersReducedMotion` accessibility setting documentation
- Updated PDF limits documentation (100 pages, 20MB)

**Version 2026.1.9 (February 1, 2026)**
- Updated to v2.1.29 (latest release)
- Added v2.1.29 changelog entry:
  - Startup performance fix for sessions with `saved_hook_context`

**Version 2026.1.8 (January 31, 2026)**
- Updated to v2.1.27 (latest release at time of update)
- Added v2.1.25 and v2.1.27 changelog entries:
  - v2.1.27: `--from-pr` flag for resuming PR-linked sessions, sessions auto-link when created via `gh pr create`, permission priority (content-level `ask` over tool-level `allow`), VSCode Chrome integration, Windows fixes
  - v2.1.25: Beta header validation fix for gateway users, `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` workaround
- Added `--from-pr` flag to CLI flags reference
- Added `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` environment variable documentation
- Added VSCode Chrome integration feature
- Added permission priority documentation (content-level rules override tool-level rules)

**Version 2026.1.7 (January 29, 2026)**
- Updated to v2.1.23 (latest release)
- Added v2.1.21 through v2.1.23 changelog entries:
  - v2.1.23: Customizable spinner verbs setting, mTLS/proxy connectivity fixes, terminal rendering improvements, bash timeout display
  - v2.1.22: Fixed structured outputs for non-interactive mode
  - v2.1.21: Japanese IME support, Python virtual environment activation in VSCode, session resume fixes, improved file operation preferences
- Added `spinnerVerbs` setting documentation for customizing spinner messages
- Added VSCode Python virtual environment activation feature (`claudeCode.usePythonEnvironment`)
- Added merged PR purple status indicator behavior

**Version 2026.1.6 (January 27, 2026)**
- Updated to v2.1.20
- Added v2.1.20 changelog entries:
  - Arrow key history navigation in vim normal mode
  - External editor shortcut (Ctrl+G) in help menu
  - PR review status indicator in prompt footer
  - CLAUDE.md loading from `--add-dir` directories (with env var)
  - Task deletion via TaskUpdate tool
  - Dynamic task list based on terminal height
  - `/copy` command now available to all users
  - Config backup rotation (keeps 5 most recent)
  - Multiple bug fixes (session compaction, wide characters, MCP Unicode, etc.)
- Added new hook events: `PostToolUseFailure`, `SubagentStart`
- Added `/copy` slash command documentation
- Added `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` environment variable
- Added comprehensive Desktop App Features section:
  - Diff view with inline commenting
  - Git worktrees for parallel sessions
  - `.worktreeinclude` file documentation
  - Installation links for macOS and Windows

**Version 2026.1.5 (January 25, 2026)**
- Updated to v2.1.19 (latest release)
- Added v2.1.19 changelog entries:
  - `CLAUDE_CODE_ENABLE_TASKS` env var to use legacy task system
  - Shorthand argument syntax (`$0`, `$1`) for custom commands
  - Changed indexed argument syntax from `$ARGUMENTS.0` to `$ARGUMENTS[0]` (bracket syntax)
  - Skills without additional permissions/hooks no longer require approval
  - VSCode session forking and rewind functionality for all users
  - Multiple bug fixes (process cleanup, session resume, prompt stash, etc.)
- Added new CLI flags from official docs:
  - `--json-schema` for validated JSON output
  - `--permission-prompt-tool` for MCP permission handling
  - `--setting-sources` for configuration source control
  - `--allow-dangerously-skip-permissions` for composable permission bypass
  - `--include-partial-messages` for streaming events
  - `--init`, `--init-only`, `--maintenance` Setup hook flags
- Added indexed arguments documentation with bracket syntax and shorthand
- Added VSCode session forking and rewind feature
- Added monitoring/telemetry environment variables section
- Added advanced environment variables (`MAX_THINKING_TOKENS`, `MAX_MCP_OUTPUT_TOKENS`, etc.)

**Version 2026.1.4 (January 23, 2026)**
- Updated to v2.1.17 (latest release with AVX instruction fix)
- Added v2.1.14 through v2.1.17 changelog entries:
  - v2.1.17: Fixed crashes on processors without AVX instruction support
  - v2.1.16: New task management system with dependency tracking, VSCode native plugin management, OAuth session browsing
  - v2.1.15: npm installation deprecation notice, React Compiler performance improvements
  - v2.1.14: History-based autocomplete in bash mode, plugin pinning to git commit SHAs, plugin search
- Added npm deprecation notice to installation section
- Added TodoWrite dependency tracking documentation
- Expanded VSCode Plugin Features section (native plugin management, remote session browsing, `/usage` command)
- Added Bash Mode Autocomplete keyboard shortcut section
- Added Plugin Pinning documentation for git commit SHA pinning

**Version 2026.1.3 (January 18, 2026)**
- Added v2.1.10 changelog (Setup hook, OAuth copy shortcut, VSCode plugin features)
- Added new `Setup` hook event for `--init`, `--init-only`, `--maintenance` flags
- Added `PermissionRequest` hook event documentation
- Added keyboard shortcut 'c' for copying OAuth URL during login
- Added VSCode plugin features section (install count display, trust warnings)
- Fixed hook events table to include all documented events

**Version 2026.1.2 (January 18, 2026)**
- Updated to v2.1.12 (latest release with message rendering fix)
- Expanded CLI flags reference with 30+ new flags including:
  - Remote session flags (`--remote`, `--teleport`, `--fork-session`)
  - System prompt customization (`--system-prompt`, `--append-system-prompt`)
  - Tool/permission management (`--tools`, `--allowedTools`, `--permission-mode`)
  - Budget limits (`--max-budget-usd`, `--max-turns`)
  - MCP configuration (`--mcp-config`, `--strict-mcp-config`)
- Added 15+ new slash commands from official docs:
  - `/bug`, `/cost`, `/privacy-settings`, `/output-style`, `/vim`, `/sandbox`
  - `/agents`, `/init`, `/install-github-app`, `/pr-comments`, `/review`
  - `/security-review`, `/todos`, `/login`, `/logout`, `/release-notes`
- Rewrote MCP Installation section with new transport types:
  - HTTP transport (recommended for hosted services)
  - Stdio transport (for local packages)
  - Installation scopes (local, project, user)
  - CLI commands (`claude mcp add/list/get/remove`)
- Fixed `/microcompact` references (now `/compact` with optional instructions)
- Updated OAuth authentication examples for MCP

**Version 2026.1.1 (January 17, 2026)**
- Updated to v2.1.11 (latest release)
- Added v2.1.9 through v2.1.11 changelog entries
- Updated all documentation URLs from docs.anthropic.com to code.claude.com
- Added new installation methods (curl scripts, Homebrew, WinGet)
- Added MCP Tool Search `auto:N` syntax documentation
- Added `plansDirectory` setting documentation
- Added `${CLAUDE_SESSION_ID}` skill variable substitution
- Added Breaking Changes & Deprecations section
- Added PreToolUse `additionalContext` hook feature

**Version 2026.1 (January 2026)**
- Major update covering v2.0.34 through v2.1.7
- Added **LSP Tool** documentation (go-to-definition, find references, hover)
- Added **Thinking Mode** section (Tab toggle, ultrathink, Alt+T)
- Added **Plan Mode** documentation
- Added **Background Tasks & Agents** section (Ctrl+B)
- Added comprehensive **Keyboard Shortcuts** reference
- Added **Environment Variables** comprehensive list
- Added **Prompt Suggestions** documentation
- Added 20+ new slash commands (/rewind, /stats, /usage, /config, /doctor, /terminal-setup, /rename, /resume, /teleport, /remote-env, etc.)
- Added new settings documentation (language, attribution, respectGitignore, etc.)
- Added `.claude/rules/` directory documentation
- Added wildcard permissions syntax
- Updated changelog to v2.1.7

**Version 2025.0 (January 2025)**
- Complete rewrite focused on verified features
- Clear separation of official vs. experimental content
- Added Skills System documentation
- Added Plugins documentation
- Added `/statusline` and `/add-dir` commands
- Added CLI flags reference section
- Enhanced `@filename` reference syntax documentation
- Comprehensive examples and patterns
- All claims verified against official docs

**Previous versions** mixed Claude.ai web features (REPL, Artifacts) with Claude Code CLI features, causing confusion. This version focuses exclusively on Claude Code CLI.

---

## Auto-Update Pipeline

This guide is a **living document** that automatically stays current with Claude Code's development.

### How It Works

A bi-daily pipeline (every 2 days at 3am UTC) runs Claude Code to:

1. **Check official sources:**
   - [Official Docs](https://code.claude.com/docs/en/overview) - Official documentation
   - [GitHub Releases](https://github.com/anthropics/claude-code/releases) - Version changelog
   - [Anthropic Changelog](https://www.anthropic.com/changelog) - Product updates

2. **Compare against current guide content**

3. **Update with verified changes:**
   - New features and capabilities
   - Changed CLI flags or commands
   - New tools or integrations
   - Bug fixes or deprecations

4. **Auto-commit changes** with detailed commit messages

### Update Log

See [update-log.md](./update-log.md) for the history of automated updates.

### Manual Trigger

The update can also be run manually:
```bash
./scripts/update-guide.sh
```

---

## License

This guide is community-maintained and not officially affiliated with Anthropic. Information is gathered from official documentation (code.claude.com) and community experience.

For official information, always refer to: https://code.claude.com/docs/en/overview

---

**End of Guide**

> **For AI Agents**: You've reached the end of the verified Claude Code guide. All features marked `[OFFICIAL]` are documented at code.claude.com. Features marked `[COMMUNITY]` are widely-used patterns. Content in the `[EXPERIMENTAL]` section is theoretical and should be tested before relying on it.

