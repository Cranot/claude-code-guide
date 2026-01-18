#!/bin/bash
# Claude Code Guide Auto-Updater
# Smart pipeline that checks for updates and maintains the guide
#
# Features:
# - Pre-flight check: Skips full run if no new GitHub release
# - Dynamic commits: Uses Claude's summary as commit message
# - Change tracking: Maintains structured JSON log
# - Error handling: Retries and rollback on failure
# - State tracking: Remembers last-checked versions
#
# Sources:
# - https://github.com/anthropics/claude-code/releases (primary trigger)
# - https://docs.anthropic.com/en/docs/claude-code (official docs)
# - https://www.anthropic.com/changelog (product changelog)
#
# Cron: 0 3 */2 * * (3am UTC every 2 days)

# ============================================
# Configuration
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUIDE_DIR="$(dirname "$SCRIPT_DIR")"
README_PATH="$GUIDE_DIR/README.md"
STATE_FILE="$GUIDE_DIR/.update-state.json"
CHANGES_LOG="$GUIDE_DIR/changes.json"
HUMAN_LOG="$GUIDE_DIR/update-log.md"
BACKUP_PATH="$GUIDE_DIR/.README.backup.md"
MAX_RETRIES=2

# Ensure PATH includes Claude CLI
export PATH="/usr/local/bin:$PATH"

# Load environment (before strict mode)
if [ -f /root/.bashrc ]; then
    source /root/.bashrc 2>/dev/null || true
fi

# Enable strict mode after environment setup
set -euo pipefail

# ============================================
# Utility Functions
# ============================================

log() {
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] $1"
}

error() {
    echo "[ERROR] $1" >&2
}

# Initialize state file if missing
init_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"last_release": "", "last_check": "", "consecutive_no_change": 0}' > "$STATE_FILE"
    fi
}

# Initialize changes log if missing
init_changes_log() {
    if [ ! -f "$CHANGES_LOG" ]; then
        echo '{"updates": []}' > "$CHANGES_LOG"
    fi
}

# Get value from state JSON
get_state() {
    jq -r ".$1 // \"\"" "$STATE_FILE"
}

# Update state JSON
set_state() {
    local tmp=$(mktemp)
    jq ".$1 = \"$2\"" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

increment_no_change() {
    local tmp=$(mktemp)
    jq ".consecutive_no_change += 1" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

reset_no_change() {
    local tmp=$(mktemp)
    jq ".consecutive_no_change = 0" "$STATE_FILE" > "$tmp" && mv "$tmp" "$STATE_FILE"
}

# ============================================
# Pre-flight Check
# ============================================

check_github_release() {
    log "Checking GitHub for latest release..."

    local latest_release
    latest_release=$(curl -sf "https://api.github.com/repos/anthropics/claude-code/releases/latest" 2>/dev/null | jq -r '.tag_name // ""') || {
        log "Could not fetch GitHub releases (network issue?) - continuing with full check"
        return 0  # Continue on error
    }

    if [ -z "$latest_release" ]; then
        log "No release found - continuing with full check"
        return 0
    fi

    local last_release
    last_release=$(get_state "last_release")

    if [ "$latest_release" = "$last_release" ]; then
        local no_change_count
        no_change_count=$(jq -r ".consecutive_no_change // 0" "$STATE_FILE")

        # Force full check every 5 runs even if no new release (catch doc updates)
        if [ "$no_change_count" -lt 5 ]; then
            log "No new release (current: $latest_release). Skipping full check."
            increment_no_change
            set_state "last_check" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
            return 1  # Skip
        else
            log "No new release but forcing periodic full check (run #$no_change_count)"
        fi
    fi

    log "New release detected: $latest_release (was: ${last_release:-none})"
    set_state "last_release" "$latest_release"
    return 0  # Continue
}

# ============================================
# Backup and Rollback
# ============================================

create_backup() {
    cp "$README_PATH" "$BACKUP_PATH"
    log "Backup created"
}

rollback() {
    if [ -f "$BACKUP_PATH" ]; then
        cp "$BACKUP_PATH" "$README_PATH"
        log "Rolled back to backup"
    fi
}

cleanup_backup() {
    rm -f "$BACKUP_PATH"
}

# ============================================
# Claude Update
# ============================================

# Global variable for output file (set before calling run_claude_update)
CLAUDE_OUTPUT_FILE=""

run_claude_update() {
    CLAUDE_OUTPUT_FILE=$(mktemp)

    local prompt=$(cat <<'EOF'
You are updating the Claude Code Guide (README.md in this directory). Your task:

## 1. CHECK SOURCES for updates about Claude Code:
- https://docs.anthropic.com/en/docs/claude-code/overview (official docs)
- https://github.com/anthropics/claude-code/releases (GitHub releases/changelog)
- https://www.anthropic.com/changelog (product changelog - filter for Claude Code)

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
- Outdated information
- Broken markdown formatting
- Navigation table matches actual sections

## 4. FORMATTING RULES:
- Maintain the existing structure and style
- Add [NEW] tags to newly added sections
- Keep [OFFICIAL], [COMMUNITY], [EXPERIMENTAL] tags accurate in content (not headers)
- Update the changelog section with any new versions

## 5. OUTPUT FORMAT (IMPORTANT):
At the END of your response, include a summary in this EXACT format:

---SUMMARY---
CHANGED: yes/no
SECTIONS: [comma-separated list of sections updated, or "none"]
DESCRIPTION: [One paragraph describing what was updated, or "No updates needed"]
---END---

Be thorough but accurate. Only add information you can verify from official sources.
EOF
)

    log "Running Claude Code..."

    if claude --print "$prompt" \
        --allowedTools "Read,Write,Edit,WebFetch,WebSearch,Bash(git diff *),Bash(git status)" \
        2>&1 | tee "$CLAUDE_OUTPUT_FILE"; then
        return 0
    else
        error "Claude exited with error"
        rm -f "$CLAUDE_OUTPUT_FILE"
        CLAUDE_OUTPUT_FILE=""
        return 1
    fi
}

# Parse Claude's summary from output
parse_summary() {
    local output_file="$1"

    # Extract between ---SUMMARY--- and ---END---
    local summary
    summary=$(sed -n '/---SUMMARY---/,/---END---/p' "$output_file" | grep -v "^---")

    if [ -z "$summary" ]; then
        echo "Auto-update from official sources"
        return
    fi

    local description
    description=$(echo "$summary" | grep "^DESCRIPTION:" | sed 's/^DESCRIPTION: *//')

    if [ -n "$description" ] && [ "$description" != "No updates needed" ]; then
        echo "$description"
    else
        echo "Auto-update from official sources"
    fi
}

# Check if Claude indicated changes
check_changed() {
    local output_file="$1"

    local changed
    changed=$(sed -n '/---SUMMARY---/,/---END---/p' "$output_file" | grep "^CHANGED:" | sed 's/^CHANGED: *//' | tr '[:upper:]' '[:lower:]')

    [ "$changed" = "yes" ]
}

# ============================================
# Change Logging
# ============================================

log_change() {
    local description="$1"
    local sections="$2"

    local tmp=$(mktemp)
    local entry=$(jq -n \
        --arg date "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
        --arg desc "$description" \
        --arg sections "$sections" \
        --arg release "$(get_state 'last_release')" \
        '{date: $date, release: $release, description: $desc, sections: $sections}')

    jq ".updates = [$entry] + .updates" "$CHANGES_LOG" > "$tmp" && mv "$tmp" "$CHANGES_LOG"

    # Also append to human-readable log
    echo "" >> "$HUMAN_LOG"
    echo "## $(date -u '+%Y-%m-%d'): Update" >> "$HUMAN_LOG"
    echo "" >> "$HUMAN_LOG"
    echo "$description" >> "$HUMAN_LOG"
    echo "" >> "$HUMAN_LOG"
    echo "Sections: $sections" >> "$HUMAN_LOG"
    echo "" >> "$HUMAN_LOG"
    echo "---" >> "$HUMAN_LOG"
}

# ============================================
# Git Operations
# ============================================

commit_and_push() {
    local message="$1"

    git -C "$GUIDE_DIR" add "$README_PATH" "$CHANGES_LOG" "$STATE_FILE"

    git -C "$GUIDE_DIR" commit -m "$(cat <<EOF
docs(claude-code-guide): $message

Automated update from official sources.

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

    log "Pushing to remote..."
    if git -C "$GUIDE_DIR" push origin main; then
        log "Push successful"
        return 0
    else
        error "Push failed"
        return 1
    fi
}

# ============================================
# Main
# ============================================

main() {
    echo "=========================================="
    echo "Claude Code Guide - Smart Auto-Updater"
    echo "=========================================="
    log "Starting update check"

    cd "$GUIDE_DIR"

    # Initialize state files
    init_state
    init_changes_log

    # Pre-flight: Check if there's a new release
    if ! check_github_release; then
        log "Skipping full check (no new release)"
        echo "=========================================="
        exit 0
    fi

    # Create backup before modifications
    create_backup

    # Run Claude with retry logic
    local attempt=1

    while [ $attempt -le $MAX_RETRIES ]; do
        log "Update attempt $attempt of $MAX_RETRIES"

        if run_claude_update; then
            break
        fi

        if [ $attempt -eq $MAX_RETRIES ]; then
            error "All update attempts failed"
            rollback
            cleanup_backup
            exit 1
        fi

        log "Retrying in 30 seconds..."
        sleep 30
        ((attempt++))
    done

    # Check if README actually changed
    if git -C "$GUIDE_DIR" diff --quiet "$README_PATH" 2>/dev/null; then
        log "No changes detected in README.md"
        increment_no_change
        cleanup_backup
        rm -f "$CLAUDE_OUTPUT_FILE"
        echo "=========================================="
        exit 0
    fi

    # Parse summary from Claude's output
    local summary
    summary=$(parse_summary "$CLAUDE_OUTPUT_FILE")

    local sections
    sections=$(sed -n '/---SUMMARY---/,/---END---/p' "$CLAUDE_OUTPUT_FILE" | grep "^SECTIONS:" | sed 's/^SECTIONS: *//' || echo "various")

    rm -f "$CLAUDE_OUTPUT_FILE"

    # Log the change
    log_change "$summary" "$sections"
    reset_no_change
    set_state "last_check" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

    # Commit and push
    log "Changes detected! Committing..."

    if commit_and_push "$summary"; then
        log "Update complete!"
        cleanup_backup
    else
        error "Commit/push failed - rolling back"
        rollback
        cleanup_backup
        exit 1
    fi

    echo "=========================================="
    log "Pipeline finished successfully"
}

main "$@"
