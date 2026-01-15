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

ERRORS=0

# Check 1: Code fences are balanced
FENCE_COUNT=$(grep -c '^```' "$README_PATH" || echo "0")
if [ $((FENCE_COUNT % 2)) -ne 0 ]; then
    echo "ERROR: Unbalanced code fences ($FENCE_COUNT found, should be even)"
    ERRORS=$((ERRORS + 1))
else
    echo "✓ Code fences balanced ($FENCE_COUNT fences)"
fi

# Check 2: Internal links have matching anchors
echo "Checking internal links..."
BROKEN_LINKS=0
for link in $(grep -oP '\]\(#[^)]+\)' "$README_PATH" | grep -oP '#[^)]+'); do
    anchor="${link#\#}"
    # Generate expected header pattern (case insensitive, allows emoji prefix)
    if ! grep -qiE "^##+ .*${anchor//-/[- ]}|^##+ [^a-zA-Z]*${anchor//-/[- ]}" "$README_PATH" 2>/dev/null; then
        # More lenient check - just look for the words in any header
        words=$(echo "$anchor" | tr '-' ' ')
        if ! grep -qi "^##.*$words" "$README_PATH" 2>/dev/null; then
            echo "  WARNING: Link $link may not have matching header"
            BROKEN_LINKS=$((BROKEN_LINKS + 1))
        fi
    fi
done
if [ $BROKEN_LINKS -eq 0 ]; then
    echo "✓ All internal links appear valid"
else
    echo "WARNING: $BROKEN_LINKS links may be broken (verify manually)"
fi

# Check 3: File size sanity check (should be > 50KB for a comprehensive guide)
FILE_SIZE=$(wc -c < "$README_PATH")
if [ "$FILE_SIZE" -lt 50000 ]; then
    echo "WARNING: README seems too small ($FILE_SIZE bytes)"
    ERRORS=$((ERRORS + 1))
else
    echo "✓ File size OK ($FILE_SIZE bytes)"
fi

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo "Quality check found $ERRORS error(s) - review needed"
fi

echo ""
echo "Update check complete!"
echo "=========================================="
