# The Complete Claude Code CLI Guide

[![Official Docs](https://img.shields.io/badge/Docs-docs.claude.com-blue)](https://docs.claude.com/en/docs/claude-code/overview) [![GitHub](https://img.shields.io/badge/GitHub-anthropics%2Fclaude--code-black)](https://github.com/anthropics/claude-code) [![Version](https://img.shields.io/badge/Guide-2025-green)](#)

> **For AI Agents**: This guide is optimized for both human developers and AI agents. All features are verified against official documentation. `[OFFICIAL]` tags indicate features from docs.claude.com. `[COMMUNITY]` tags indicate observed patterns. `[EXPERIMENTAL]` tags indicate unverified concepts.

---

## 🎯 What is Claude Code?

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
npm install -g @anthropic-ai/claude-code
claude --version  # Verify installation
```

**Official Documentation:** https://docs.claude.com/en/docs/claude-code/overview

---

## 📖 Quick Navigation

### 🚀 Getting Started
- [What is Claude Code?](#what-is-claude-code) - Introduction and installation
- [Core Concepts](#core-concepts) - Essential understanding
- [Quick Start Guide](#quick-start-guide) - Your first session
- [Tools Reference](#tools-reference) - Available tools and capabilities

### ⚡ Core Features [OFFICIAL]
- [Skills System](#skills-system) - Model-invoked modular capabilities (NEW 2024)
- [Slash Commands](#slash-commands) - Custom workflow commands
- [Hooks System](#hooks-system) - Event-based automation
- [MCP Integration](#mcp-integration) - External data sources
- [Sub-Agents](#sub-agents) - Specialized AI assistants
- [Plugins](#plugins) - Bundled extensions

### 🛠️ Practical Usage
- [Development Workflows](#development-workflows) - Common patterns
- [Tool Synergies](#tool-synergies) - How features work together
- [Examples Library](#examples-library) - Real-world scenarios
- [Best Practices](#best-practices) - Proven approaches
- [Troubleshooting](#troubleshooting) - Common issues

### 📚 Advanced Topics
- [Security Considerations](#security-considerations) - Security model
- [SDK Integration](#sdk-integration) - Programmatic usage
- [Experimental Concepts](#experimental-concepts) - ⚠️ Unverified ideas

---

## 📋 Quick Reference

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
/microcompact            # Smart context cleanup (NEW)

# Background Tasks
/bashes                   # List background processes
/kill <id>               # Stop background process

# Discovery
/commands                 # List slash commands
/hooks                   # Show configured hooks
/skills                  # List available Skills (NEW)
/plugin                  # Manage plugins
```

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)

### CLI Flags Reference [OFFICIAL]

```bash
# Output Control
claude -p, --print "task"          # Print mode: non-interactive, prints result and exits
claude --output-format json         # Output format: json, markdown, or text
claude --no-color                   # Disable colored output

# Session Management
claude --continue                   # Continue from last session
claude --resume <session-id>        # Resume specific session by ID
claude --list-sessions              # List all available sessions

# Debugging & Logging
claude --debug                      # Enable debug mode with verbose logging
claude --log-level <level>          # Set log level: error, warn, info, debug, trace

# Model & Configuration
claude --model <model-name>         # Specify model to use
claude --config <path>              # Use custom config file

# Sandboxing (macOS/Linux)
claude --sandbox                    # Enable sandbox mode for security
claude --no-sandbox                 # Disable sandbox mode
```

**Common Flag Combinations:**

```bash
# One-off task with JSON output
claude --print "analyze this code" --output-format json

# Debug session with custom config
claude --debug --config .claude/custom-settings.json

# Resume session with specific model
claude --resume abc123 --model claude-opus-4

# Non-interactive with no color (CI/CD)
claude --print "run tests" --no-color --output-format json
```

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)

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

**Source:** [Settings Reference](https://docs.claude.com/en/docs/claude-code/settings)

---

## 🎓 Core Concepts

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

**Source:** [Overview](https://docs.claude.com/en/docs/claude-code/overview)

### 2. Permission Model [OFFICIAL]

Claude Code uses an **incremental permission system** for safety:

```bash
# Permission Modes
"ask"    # Prompt for each use (default for new operations)
"allow"  # Permit without asking
"deny"   # Block completely

# Tools Requiring Permission
- Bash (command execution)
- Write/Edit/NotebookEdit (file modifications)
- WebFetch/WebSearch (network access)
- SlashCommand (custom commands)

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

**Source:** [Settings](https://docs.claude.com/en/docs/claude-code/settings)

### 3. Project Context - CLAUDE.md [COMMUNITY]

A **CLAUDE.md** file in your project root provides persistent context across sessions:

```markdown
# Project: My Application

## 🔴 Critical Context (Read First)
- Language: TypeScript + Node.js
- Framework: Express + React
- Database: PostgreSQL with Prisma ORM
- Testing: Jest + React Testing Library

## Commands That Work
```bash
npm run dev          # Start dev server (port 3000)
npm test             # Run all tests
npm run lint         # ESLint check
npm run typecheck    # TypeScript validation
npm run db:migrate   # Run Prisma migrations
```

## Important Patterns
- All API routes in `/src/routes` - RESTful structure
- Database queries use Prisma Client
- Auth uses JWT tokens (implementation in `/src/auth`)
- Frontend components in `/src/components` - functional components with hooks
- API responses follow format: `{success: boolean, data: any, error?: string}`

## ⚠️ Gotchas & What NOT to Do
- DON'T modify `/generated` folder (auto-generated by Prisma)
- DON'T commit `.env` files (use `.env.example` instead)
- ALWAYS run `npm run db:migrate` after pulling schema changes
- DON'T use `any` type in TypeScript - use proper typing
- Redis connection requires retry logic (see `src/redis.ts`)

## File Structure Patterns
```
/src
  /routes       # Express API routes
  /services     # Business logic
  /models       # Type definitions
  /middleware   # Express middleware
  /utils        # Shared utilities
  /auth         # Authentication logic
```

## Recent Learnings
- [2025-01-15] Payment webhook needs raw body parser for Stripe verification
- [2025-01-10] Redis connection pool should use {maxRetriesPerRequest: 3}
- [2025-01-05] React components re-render issue fixed by using useMemo for expensive calculations
```

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
```

**Capabilities:**
- Reads any text file (code, configs, logs, etc.)
- Handles images (screenshots, diagrams, charts)
- Processes PDFs - extracts text and visual content
- Parses Jupyter notebooks (.ipynb files)
- Returns content with line numbers (`cat -n` format)
- Can read large files with offset/limit parameters

**Special Features:**
- **Images**: Claude can read screenshots of errors, UI designs, architecture diagrams
- **PDFs** [NEW]: Extract and analyze PDF content, useful for documentation and requirements
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

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference), [Settings](https://docs.claude.com/en/docs/claude-code/settings)

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

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)

### 5. Context Management [OFFICIAL]

Claude Code maintains conversation context with smart management:

#### Context Commands

```bash
/compact          # Reduce context by removing old information
/microcompact     # Smart cleanup (NEW - keeps CLAUDE.md, current work)
```

#### When to Use

**Use /compact when:**
- Long sessions with many file reads
- "Context too large" errors
- You've completed a major task and want to start fresh

**Use /microcompact when:**
- Context is getting large but you want to preserve recent work
- Switching between related tasks
- You want intelligent cleanup without losing important context

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

**Source:** [Settings](https://docs.claude.com/en/docs/claude-code/settings)

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

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)

---

## 🚀 Quick Start Guide

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

**Source:** [Quickstart](https://docs.claude.com/en/docs/claude-code/quickstart), [Settings](https://docs.claude.com/en/docs/claude-code/settings)

---

## 🧠 Advanced Features [OFFICIAL]

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

**Source:** [Thinking Mode](https://docs.claude.com/en/docs/claude-code/thinking-mode)

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

**Source:** [Plan Mode](https://docs.claude.com/en/docs/claude-code/plan-mode)

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

**Source:** [Background Tasks](https://docs.claude.com/en/docs/claude-code/background-tasks)

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

**Advanced:**
| Variable | Description |
|----------|-------------|
| `DISABLE_INTERLEAVED_THINKING` | Disable interleaved thinking |
| `USE_BUILTIN_RIPGREP` | Use built-in ripgrep |
| `CLOUD_ML_REGION` | Cloud ML region for Vertex |
| `AWS_BEARER_TOKEN_BEDROCK` | AWS bearer token |

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

  // Session behavior
  "companyAnnouncements": true  // Show startup announcements
}
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

## 🔧 Skills System [OFFICIAL]

**Skills are modular capabilities that Claude Code autonomously activates based on your request.**

### What Are Skills?

Skills are **model-invoked** - Claude decides when to use them automatically:

```
You: "Generate a PDF report of the test results"
Claude: [Sees pdf-generator Skill, activates it automatically]

You: "Review this code for security issues"
Claude: [Activates security-reviewer Skill]
```

**Key Difference:**
- **Skills**: Claude activates them (autonomous) - "What should I use?"
- **Slash Commands**: You invoke them (manual) - "/command-name"

### Skill Types [OFFICIAL]

```bash
# 1. Personal Skills
~/.claude/skills/my-skill/
# Available across all your projects
# Private to you

# 2. Project Skills
.claude/skills/team-skill/
# Shared with team via git
# Available to all team members

# 3. Plugin Skills
# Bundled with installed plugins
# Installed via plugin system
```

### Creating a Skill [OFFICIAL]

**Directory Structure:**
```
my-skill/
├── SKILL.md          # Required: Instructions for Claude
├── reference.md      # Optional: Additional docs
├── scripts/          # Optional: Helper scripts
└── templates/        # Optional: File templates
```

**Example: Code Review Skill**

`.claude/skills/code-reviewer/SKILL.md`:
```markdown
---
name: code-reviewer
description: Reviews code for security vulnerabilities, bugs, performance issues, and style problems. Use when user asks to review, audit, or check code quality.
allowed-tools: [Read, Grep, Glob]
---

# Code Review Skill

## When to Activate
Use this Skill when the user asks to:
- Review code for issues
- Audit security or find vulnerabilities
- Check code quality or best practices
- Analyze code for bugs or problems
- Perform code inspection or assessment

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
- **Best Practices**: Framework patterns, SOLID principles

### 3. Reporting
Provide structured feedback:

```markdown
## Security Issues
### 🔴 Critical: SQL Injection Risk
**File**: `src/api/users.ts:45`
**Issue**: Direct string interpolation in SQL query
**Fix**: Use parameterized queries

### ⚠️ High: Exposed API Key
**File**: `src/config.ts:12`
**Issue**: API key hardcoded in source
**Fix**: Move to environment variables

## Performance Issues
### 🟡 Medium: N+1 Query Problem
**File**: `src/services/posts.ts:23`
**Issue**: Loading comments in loop
**Fix**: Use JOIN or batch loading

## Style & Best Practices
### 🔵 Low: Inconsistent Naming
**File**: `src/utils/helpers.ts`
**Issue**: Mix of camelCase and snake_case
**Fix**: Standardize on camelCase
```

### 4. Verification
- Suggest fixes with code examples
- Prioritize by severity
- Reference specific file:line locations

## Notes
- Focus on actionable feedback
- Provide code examples for fixes
- Consider project context from CLAUDE.md
- Explain WHY something is an issue
```

**Example: Test Generator Skill**

`.claude/skills/test-generator/SKILL.md`:
```markdown
---
name: test-generator
description: Generates comprehensive unit and integration tests for code. Use when user asks to write tests, add test coverage, or create test cases.
allowed-tools: [Read, Write, Grep, Glob, Bash]
---

# Test Generator Skill

## When to Activate
Use this Skill when user requests:
- "Write tests for..."
- "Add test coverage"
- "Generate test cases"
- "Create unit/integration tests"

## Test Generation Process

### 1. Analyze Target Code
- Read the file/function to test
- Identify inputs, outputs, side effects
- Find dependencies and mocks needed
- Check existing test patterns (Grep for test files)

### 2. Determine Test Type
- **Unit Tests**: Individual functions, pure logic
- **Integration Tests**: API endpoints, database operations
- **Component Tests**: React/Vue components (if frontend)

### 3. Generate Comprehensive Tests
Cover all scenarios:
- ✅ Happy path (expected usage)
- ❌ Error cases (invalid inputs, failures)
- 🔀 Edge cases (empty, null, boundary values)
- 🔁 Side effects (database changes, API calls)

### 4. Follow Project Patterns
- Check CLAUDE.md for testing conventions
- Match existing test file structure
- Use project's test framework (Jest, Mocha, etc.)
- Follow naming conventions

## Test Template

```typescript
describe('FunctionName', () => {
  // Setup
  beforeEach(() => {
    // Initialize mocks, test data
  });

  // Happy path
  it('should return expected result with valid input', () => {
    // Arrange
    // Act
    // Assert
  });

  // Error cases
  it('should throw error when input is invalid', () => {
    // Test error handling
  });

  // Edge cases
  it('should handle empty input gracefully', () => {
    // Test boundaries
  });

  // Side effects
  it('should call external service with correct params', () => {
    // Test mocks and spies
  });
});
```

### 5. Verify Tests
- Run tests with Bash tool
- Ensure all pass
- Check coverage if available
```

### Skill Best Practices [OFFICIAL]

#### 1. Write Clear, Specific Descriptions

The `description` field is critical - it helps Claude decide when to activate:

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
# For security review Skill
description: "Reviews code for security. Use when asked to: review security, audit code, find vulnerabilities, check for exploits, analyze risks."

# For performance optimization Skill
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
- `sql-optimizer` - Optimizes SQL queries only
- `api-docs-generator` - Generates API documentation
- `security-scanner` - Finds security issues

**Bad (too broad):**
- `database-everything` - Database tasks (too vague)
- `code-helper` - Helps with code (what kind?)

#### 5. Provide Clear Instructions

Structure your SKILL.md:
1. **When to Activate** - Clear triggers
2. **Process** - Step-by-step what to do
3. **Output Format** - How to present results
4. **Examples** - Show expected behavior

### Discovering and Using Skills [OFFICIAL]

```bash
# List all available Skills
> "What Skills are available?"

# Claude will show all Skills with descriptions
# Skills activate automatically when relevant

# Explicitly request a Skill
> "Use the code-reviewer Skill on src/auth.ts"

# Skills work in background
> "Review security and generate tests"
# May activate multiple Skills automatically
```

### Skills vs Slash Commands [OFFICIAL]

| Feature | Skills | Slash Commands |
|---------|--------|----------------|
| **Invocation** | Automatic (Claude decides) | Manual (you type `/command`) |
| **Purpose** | Modular capabilities | Workflow templates |
| **When to Use** | Claude should decide when needed | You want explicit control |
| **Example** | Security review when analyzing code | `/deploy` to run deployment steps |

**Use Skills when:** You want Claude to intelligently apply capabilities based on context

**Use Slash Commands when:** You have specific workflows you invoke repeatedly

**Source:** [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills)

---

## ⚡ Slash Commands [OFFICIAL]

**Slash commands are user-invoked workflow templates stored as Markdown files.**

### Built-in Commands [OFFICIAL]

```bash
# Session Management
/help              # Show all available commands
/exit              # End current session
/clear             # Clear conversation history
/compact           # Reduce context size
/microcompact      # Smart context cleanup (keeps CLAUDE.md, current work)
/rewind            # Undo code changes in conversation (NEW)

# Session & History
/rename <name>     # Give current session a name (NEW)
/resume [name|id]  # Resume a previous session by name or ID (NEW)
/export            # Export conversation to file

# Usage & Stats
/usage             # View plan limits and usage (NEW)
/stats             # Usage stats, engagement metrics (supports 7/30/all-time) (NEW)

# Background Process Management
/bashes            # List all background processes
/tasks             # List all background tasks (agents, shells, etc.)
/kill <id>         # Stop a background process

# Discovery & Debugging
/commands          # List all slash commands
/hooks             # Show configured hooks
/skills            # List available Skills
/plugin            # Plugin management interface
/context           # View current context usage and visualization (NEW)
/doctor            # Run diagnostics and validation (NEW)

# Configuration
/config            # General settings (with search) (NEW)
/settings          # Alias for /config (NEW)
/permissions       # Manage tool permissions (with search) (NEW)
/status            # Show session status
/statusline        # Configure status line display
/model             # Switch between models
/theme             # Theme picker (Ctrl+T toggles syntax highlighting)
/terminal-setup    # Configure terminal (Kitty, Alacritty, Zed, Warp) (NEW)

# Workspace Management
/add-dir <path>    # Add additional directory to workspace
/memory            # Manage CLAUDE.md project context

# MCP Server Management
/mcp               # MCP server management interface
/mcp enable <srv>  # Enable an MCP server (NEW)
/mcp disable <srv> # Disable an MCP server (NEW)

# Remote Sessions (claude.ai subscribers)
/teleport          # Connect to remote session (NEW)
/remote-env        # Configure remote environment (NEW)

# Plan Mode
/plan              # Enter plan mode for structured planning
```

### Creating Custom Commands [OFFICIAL]

**Command Locations:**
```bash
.claude/commands/          # Project commands (shared via git)
~/.claude/commands/        # Personal commands (just for you)
```

**Example: Security Review Command**

`.claude/commands/security-review.md`:
```markdown
---
name: security-review
description: Comprehensive security audit of codebase
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

## Output Format

Provide a detailed report with:

```markdown
## 🔴 Critical Issues (Fix Immediately)
- **Issue**: [Description]
  - **File**: [path:line]
  - **Risk**: [What could happen]
  - **Fix**: [How to resolve]

## ⚠️ High Priority
[Similar format]

## 🟡 Medium Priority
[Similar format]

## 🔵 Low Priority / Recommendations
[Similar format]

## ✅ Security Strengths
[What's done well]

## 📋 Action Plan
1. [Prioritized list of fixes]
```

## Testing
After suggesting fixes, offer to:
- Create test cases for vulnerabilities
- Set up security hooks
- Add security documentation
```

**Usage:**
```bash
/security-review "authentication and API endpoints"
```

**Example: API Documentation Generator**

`.claude/commands/api-docs.md`:
```markdown
---
name: api-docs
description: Generate comprehensive API documentation
---

# Generate API Documentation

Analyze the codebase and create comprehensive API documentation for: $ARGUMENTS

## Process

### 1. Discovery
- Find all API routes/endpoints
- Identify request/response types
- Note authentication requirements
- Document query parameters

### 2. Documentation Structure

For each endpoint, document:

```markdown
### POST /api/users/login

**Description**: Authenticates a user and returns a JWT token

**Authentication**: None (public endpoint)

**Request Body**:
```json
{
  "email": "string (required, format: email)",
  "password": "string (required, min: 8 chars)"
}
```

**Response 200** (Success):
```json
{
  "success": true,
  "data": {
    "token": "string (JWT)",
    "user": {
      "id": "string",
      "email": "string",
      "name": "string"
    }
  }
}
```

**Response 401** (Unauthorized):
```json
{
  "success": false,
  "error": "Invalid credentials"
}
```

**Example Request**:
```bash
curl -X POST https://api.example.com/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"secretpass"}'
```
```

### 3. Generate OpenAPI/Swagger Spec
Create an OpenAPI 3.0 specification file.

### 4. Create Examples
Provide curl examples and code snippets for common use cases.

## Output
- Create `/docs/API.md` with full documentation
- Create `/openapi.yaml` with OpenAPI spec
- Update README.md with API documentation link
```

**Usage:**
```bash
/api-docs "all endpoints"
/api-docs "authentication routes"
```

### Command Features [OFFICIAL]

#### Using Arguments

Commands can accept arguments via `$ARGUMENTS` placeholder:

```markdown
---
name: analyze-file
description: Deep analysis of a specific file
---

# Analyze: $ARGUMENTS

Perform a comprehensive analysis of: $ARGUMENTS

Include:
- Code structure and patterns
- Potential issues
- Improvement suggestions
- Test coverage
```

**Usage:**
```bash
/analyze-file "src/services/payment.ts"
```

#### File References with @ Syntax [OFFICIAL]

Reference files with `@` prefix for quick file inclusion:

```bash
# Reference single file
/review-code @src/auth.ts

# Reference multiple files
/review-code @src/auth.ts @src/api.ts @tests/auth.test.ts

# Works in regular prompts too
> "Review @src/services/payment.ts for security issues"

# Reference files in commands with arguments
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
- Combine with slash commands for reusable workflows
- Great for focused analysis of specific files
- Reduces token usage vs. reading entire directories

#### Namespacing

Organize commands in subdirectories:

```bash
.claude/commands/
├── api/
│   ├── generate-docs.md
│   └── test-endpoints.md
├── testing/
│   ├── run-e2e.md
│   └── coverage-report.md
└── deploy/
    ├── staging.md
    └── production.md
```

**Usage:**
```bash
/api/generate-docs
/testing/run-e2e
/deploy/staging
```

#### Extended Thinking

Commands can trigger extended reasoning for complex tasks:

```markdown
---
name: architecture-review
description: Deep architectural analysis
extended-thinking: true
---

# Architecture Review

[Claude will use extended thinking to analyze architecture deeply]
```

#### MCP Integration

MCP servers can expose prompts as slash commands automatically:

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

**Source:** [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference)

---

## 🔗 Hooks System [OFFICIAL]

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
| **SessionStart** | Session begins | No |
| **SessionEnd** | Session ends | No |
| **UserPromptSubmit** | User sends message | Yes |
| **PreToolUse** | Before tool execution | Yes |
| **PostToolUse** | After tool completes | No |
| **Stop** | Claude considers stopping | Yes |
| **SubagentStop** | Sub-agent considers stopping | Yes |
| **Notification** | Claude sends notification | No |
| **PreCompact** | Before context compaction | No |

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

**Source:** [Hooks Reference](https://docs.claude.com/en/docs/claude-code/hooks), [Hooks Guide](https://docs.claude.com/en/docs/claude-code/hooks-guide), Community GitHub repositories

---

## 🌐 MCP Integration [OFFICIAL]

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

### MCP Server Configuration [OFFICIAL]

MCP servers are configured in `.claude/agents/` directory:

**Structure:**
```bash
.claude/agents/
├── mcp.json          # Server definitions
└── server-name/      # Optional: custom server code
```

**Example: `.claude/agents/mcp.json`**
```json
{
  "mcpServers": {
    "google-drive": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-google-drive"
      ],
      "env": {
        "GOOGLE_DRIVE_CLIENT_ID": "${GOOGLE_DRIVE_CLIENT_ID}",
        "GOOGLE_DRIVE_CLIENT_SECRET": "${GOOGLE_DRIVE_CLIENT_SECRET}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://user:pass@localhost/db"
      ]
    },
    "slack": {
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

MCP servers can use OAuth for secure authentication:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "oauth": {
        "provider": "github",
        "scopes": ["repo", "read:user"]
      }
    }
  }
}
```

Claude Code will guide you through OAuth flow on first use.

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

**Source:** [MCP Documentation](https://docs.claude.com/en/docs/claude-code/mcp), [Settings](https://docs.claude.com/en/docs/claude-code/settings)

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

## 🤖 Sub-Agents [OFFICIAL]

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

**Source:** [Sub-Agents](https://docs.claude.com/en/docs/claude-code/sub-agents)

---

## 📦 Plugins [OFFICIAL]

**Plugins bundle Skills, Commands, Hooks, and MCP servers for easy sharing.**

### What Are Plugins? [OFFICIAL]

Plugins are packages that extend Claude Code:

```bash
# A plugin can contain:
- Skills (auto-activated capabilities)
- Slash Commands (workflow templates)
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
```

### Plugin Structure [OFFICIAL]

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Metadata
├── commands/                 # Slash commands
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

**Source:** [Plugins](https://docs.claude.com/en/docs/claude-code/plugins)

---

## 🔄 Development Workflows

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

# Or create a slash command:
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

## 🔗 Tool Synergies [COMMUNITY]

**How Claude Code features work together for powerful workflows.**

### Synergy Pattern 1: Research → Validate → Implement

```bash
# 1. Research with WebSearch + WebFetch
> "Research best practices for Redis caching in Node.js"

# 2. Explore codebase with Explore agent
> "Find where we currently handle caching"

# 3. Implement with guidance
> "Implement Redis caching following the patterns found"

# 4. Verify with tests
> "Create tests for the caching implementation"
```

### Synergy Pattern 2: Skills + Hooks + MCP

```bash
# Setup:
- Skill: "security-scanner" (auto-activates on code review)
- Hook: Blocks commits with security issues
- MCP: Logs security findings to Jira

# Workflow:
> "Review this authentication code"

# Triggers:
1. Security scanner Skill activates automatically
2. Finds vulnerability
3. Hook blocks any commit attempt
4. MCP logs issue to Jira automatically
```

### Synergy Pattern 3: Sub-Agents + Background Tasks

```bash
# Start development server in background
> "Start the dev server in background"

# Launch test watcher
> "Run tests in watch mode in background"

# Use Explore agent while services run
> "While those run, find all API endpoints and document them"

# Agents work in parallel:
- Main session: Documentation work
- Background: Dev server running
- Background: Tests running
- Sub-agent: Exploring codebase
```

### Synergy Pattern 4: TodoWrite + Multiple Files

```bash
# Complex refactor across many files
> "Refactor the authentication system to use JWT instead of sessions"

# Claude:
1. Creates comprehensive TodoWrite list
2. Works through each file systematically
3. Updates todos as progress
4. You can see progress in real-time
5. Can interrupt and resume anytime
```

### Synergy Pattern 5: Slash Commands + Hooks + Skills

```bash
# Custom deployment workflow
/deploy-staging

# Triggers:
1. Slash command runs pre-deploy checks
2. Hooks validate all tests pass
3. Security scanner Skill auto-reviews
4. Hook blocks if issues found
5. MCP notifies team in Slack
6. Deployment proceeds if all checks pass
```

---

## 📚 Examples Library

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
/microcompact
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

## ✅ Best Practices

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

**3. Create Workflow Commands**
```bash
# .claude/commands/team/
├── code-review.md
├── deploy-staging.md
├── run-checks.md
└── security-audit.md
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

## 🔧 Troubleshooting

### Common Issues [COMMUNITY]

**Issue: "Context too large" error**
```bash
# Solution 1: Compact context
> /compact

# Solution 2: Smart cleanup
> /microcompact

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
> /microcompact
> "Continue with [brief task summary]"

# Full reset if needed:
> /compact
> "Let me brief you: [key context]"

# Prevention:
- Use /microcompact every ~50 operations
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

## 🔒 Security Considerations [OFFICIAL]

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

**Source:** [Settings](https://docs.claude.com/en/docs/claude-code/settings), [Sandboxing](https://docs.claude.com/en/docs/claude-code/sandboxing)

---

## 📊 SDK Integration [OFFICIAL]

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

**Source:** [SDK Overview](https://docs.claude.com/en/docs/claude-code/sdk/sdk-overview)

---

## 🧪 Experimental Concepts

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

## 📝 Additional Resources

### Official Documentation [OFFICIAL]
- **Main Docs**: https://docs.claude.com/en/docs/claude-code/overview
- **CLI Reference**: https://docs.claude.com/en/docs/claude-code/cli-reference
- **Settings**: https://docs.claude.com/en/docs/claude-code/settings
- **Skills**: https://docs.claude.com/en/docs/claude-code/skills
- **Hooks**: https://docs.claude.com/en/docs/claude-code/hooks
- **MCP**: https://docs.claude.com/en/docs/claude-code/mcp
- **Sub-Agents**: https://docs.claude.com/en/docs/claude-code/sub-agents
- **Plugins**: https://docs.claude.com/en/docs/claude-code/plugins

### Community Resources [COMMUNITY]
- **GitHub**: https://github.com/anthropics/claude-code
- **Awesome Claude Code**: https://github.com/hesreallyhim/awesome-claude-code
- **Awesome Claude Skills**: https://github.com/travisvn/awesome-claude-skills

### Getting Help
- **GitHub Issues**: https://github.com/anthropics/claude-code/issues
- **Discord**: Check Anthropic's community channels
- **Documentation**: https://docs.claude.com

---

## 📜 Changelog

### Claude Code CLI Releases [OFFICIAL]

For complete details, see the [official CHANGELOG.md](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md).

**Version 2.1.7** (January 14, 2026) - Latest
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

---

### This Guide's Changelog

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

## 📄 License

This guide is community-maintained and not officially affiliated with Anthropic. Information is gathered from official documentation (docs.claude.com) and community experience.

For official information, always refer to: https://docs.claude.com/en/docs/claude-code/overview

---

**End of Guide**

> **For AI Agents**: You've reached the end of the verified Claude Code guide. All features marked `[OFFICIAL]` are documented at docs.claude.com. Features marked `[COMMUNITY]` are widely-used patterns. Content in the `[EXPERIMENTAL]` section is theoretical and should be tested before relying on it.

