#!/bin/sh
#
# Shared Jira helpers for the scripts in `~/.dotfiles/scripts`.
#
# Source this file, then call the functions below:
#   . "$HOME/.dotfiles/lib/jira.sh"
#

. "${DEV_SCRIPTS_DIR}/installers/jq.sh"

# Print every unresolved issue assigned to the current user, across all
# projects, as `KEY<TAB>Summary` lines (most recently updated first).
#
# `jira issue list` always scopes its query to the configured project, so this
# hits the search API directly with the same server, login and token the Jira
# CLI uses.
#
jira_assigned_issues() {
  if ! ensure_jq; then
    echo "Error: Failed to install required tool 'jq'" >&2
    return 1
  fi

  if [ -z "${JIRA_API_TOKEN-}" ]; then
    echo "Error: JIRA_API_TOKEN is not set." >&2
    return 1
  fi

  jira_config="${JIRA_CONFIG_FILE:-$HOME/.config/.jira/.config.yml}"
  jira_server=$(awk '/^server:/ {print $2}' "$jira_config")
  jira_login=$(awk '/^login:/ {print $2}' "$jira_config")

  jira_issues=$(curl -sS --fail-with-body \
    -u "${jira_login}:${JIRA_API_TOKEN}" \
    -G "${jira_server}/rest/api/3/search/jql" \
    --data-urlencode 'jql=assignee = currentUser() AND resolution IS EMPTY ORDER BY updated DESC' \
    --data-urlencode 'fields=summary' \
    --data-urlencode 'maxResults=100' |
    jq -r '.issues[] | "\(.key)\t\(.fields.summary)"')

  if [ -z "$jira_issues" ]; then
    echo "Error: no unresolved Jira issues assigned to you." >&2
    return 1
  fi

  printf '%s\n' "$jira_issues"
}
