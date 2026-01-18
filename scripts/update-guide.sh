#!/bin/bash
# Claude Code Guide Auto-Updater
# Runs bi-daily to check Anthropic sources and update the guide
#
# Sources checked:
# - https://docs.anthropic.com/en/docs/claude-code (official docs)
# - https://www.anthropic.com/news (news/announcements)
# - https://github.com/anthropics/claude-code/releases (GitHub releases)
# - https://www.anthropic.com/changelog (changelog)
#
# Cron schedule: 0 3 */2 * * (3am UTC every 2 days)

set -e

# Ensure PATH includes Claude CLI
export PATH="/usr/local/bin:$PATH"

# Load any required environment variables
if [ -f /root/.bashrc ]; then
    source /root/.bashrc 2>/dev/null || true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUIDE_DIR="$(dirname "$SCRIPT_DIR")"
README_PATH="$GUIDE_DIR/README.md"
LOG_FILE="$GUIDE_DIR/update-log.md"

echo "=========================================="
echo "Claude Code Guide Auto-Updater"
echo "Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "=========================================="

# Change to guide directory
cd "$GUIDE_DIR"

# Create the prompt for Claude
PROMPT=$(cat <<'EOF'
You are updating the Claude Code Guide (README.md in this directory). Your task:

## 1. CHECK SOURCES for updates about Claude Code:
- https://docs.anthropic.com/en/docs/claude-code/overview (official docs)
- https://www.anthropic.com/news (filter for Claude Code announcements)
- https://github.com/anthropics/claude-code/releases (GitHub releases/changelog)
- https://www.anthropic.com/changelog (product changelog)

## 2. UPDATE the README.md with any:
- New features or capabilities
- Changed CLI flags or commands
- New MCP tools or integrations
- Updated best practices
- Bug fixes or deprecations
- New examples or patterns

## 3. QUALITY CHECK - Review and fix if needed:
- Broken internal links (anchors that don't match headers)
- Unbalanced code fences (``` must be paired)
- Outdated year references
- Broken markdown formatting
- Navigation table matches actual sections
- Any other quality issues you notice

## 4. FORMATTING RULES:
- Maintain the existing structure and style
- Add [NEW] tags to newly added sections
- Keep [OFFICIAL], [COMMUNITY], [EXPERIMENTAL] tags accurate in content (not headers)
- Add update notes to the changelog section

## 5. OUTPUT:
- If changes made: brief summary of what was updated
- If no changes needed: just say "No updates needed"

IMPORTANT: Be thorough but accurate. Only add information you can verify from official sources.
EOF
)

echo ""
echo "Running Claude Code to check for updates..."
echo ""

# Run Claude Code with the update prompt
# Using --print mode for non-interactive execution
claude --print "$PROMPT" --allowedTools "Read,Write,Edit,WebFetch,WebSearch,Bash(git *)" 2>&1 | tee -a "$LOG_FILE"

# Check if README was modified
if git diff --quiet "$README_PATH" 2>/dev/null; then
    echo ""
    echo "No changes detected in README.md"
    echo "$(date -u '+%Y-%m-%d'): No updates needed" >> "$LOG_FILE"
else
    echo ""
    echo "Changes detected! Creating commit..."

    # Stage and commit changes
    git add "$README_PATH"
    git commit -m "$(cat <<EOF
docs(claude-code-guide): auto-update from official sources

Automated bi-daily update checking:
- Anthropic docs
- GitHub releases
- Anthropic changelog

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

    echo ""
    echo "Commit created! Pushing to remote..."
    git push origin main

    echo ""
    echo "Changes pushed successfully!"
    echo "$(date -u '+%Y-%m-%d'): Guide updated - see git log for details" >> "$LOG_FILE"
fi

echo ""
echo "Update check complete!"
echo "=========================================="
