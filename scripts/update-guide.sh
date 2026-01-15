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

1. CHECK THESE SOURCES for updates about Claude Code:
   - https://docs.anthropic.com/en/docs/claude-code/overview (official docs)
   - https://www.anthropic.com/news (filter for Claude Code announcements)
   - https://github.com/anthropics/claude-code/releases (GitHub releases/changelog)
   - https://www.anthropic.com/changelog (product changelog)

2. COMPARE what you find against the current README.md content

3. UPDATE the README.md with any:
   - New features or capabilities
   - Changed CLI flags or commands
   - New MCP tools or integrations
   - Updated best practices
   - Bug fixes or deprecations
   - New examples or patterns

4. FORMATTING RULES:
   - Maintain the existing structure and style
   - Add [NEW] tags to newly added sections
   - Update dates where relevant
   - Keep [OFFICIAL], [COMMUNITY], [EXPERIMENTAL] tags accurate
   - Add update notes to the changelog section at the bottom

5. If NO UPDATES are needed, do not modify the file.

6. After checking, create a brief summary of what was updated (or that no updates were needed).

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
    echo "Commit created successfully!"
    echo "$(date -u '+%Y-%m-%d'): Guide updated - see git log for details" >> "$LOG_FILE"
fi

# Quality Check
echo ""
echo "Running quality checks..."

# Check 1: Code fences are balanced (critical)
FENCE_COUNT=$(grep -c '^```' "$README_PATH" || echo "0")
if [ $((FENCE_COUNT % 2)) -ne 0 ]; then
    echo "WARNING: Unbalanced code fences ($FENCE_COUNT found)"
else
    echo "✓ Code fences balanced ($FENCE_COUNT)"
fi

# Check 2: File size sanity check
FILE_SIZE=$(wc -c < "$README_PATH")
echo "✓ File size: $(numfmt --to=iec $FILE_SIZE 2>/dev/null || echo "$FILE_SIZE bytes")"

# Check 3: Section count
SECTION_COUNT=$(grep -c '^## ' "$README_PATH" || echo "0")
echo "✓ Sections: $SECTION_COUNT"

# Check 4: Internal link count (informational)
LINK_COUNT=$(grep -oP '\]\(#[^)]+\)' "$README_PATH" | wc -l || echo "0")
echo "✓ Internal links: $LINK_COUNT"

echo ""
echo "Update check complete!"
echo "=========================================="
