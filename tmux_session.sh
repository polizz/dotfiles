#!/bin/sh

# Usage: ./tmux_new_session.sh <session_name> <session_directory>
# Example: ./tmux_new_session.sh Story3 ~/projects/new-project

# Check if session name and directory are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <session_name> <session_directory>"
  exit 1
fi

SESSION_NAME="$1"
SESSION_DIR="$2"

# Expand the directory path (handles ~/ and similar)
eval SESSION_DIR_EXPANDED="$SESSION_DIR"

# Check if the directory exists
if [ ! -d "$SESSION_DIR_EXPANDED" ]; then
  echo "Error: Directory '$SESSION_DIR' does not exist."
  exit 1
fi

# Shared tab definitions
TAB_NOTES_NAME="notes"
TAB_NOTES_DIR="~/Nextcloud/notes"

# Expand notes directory path
eval TAB_NOTES_DIR_EXPANDED="$TAB_NOTES_DIR"

# Check if notes directory exists
if [ ! -d "$TAB_NOTES_DIR_EXPANDED" ]; then
  echo "Warning: Notes directory '$TAB_NOTES_DIR' does not exist."
  echo "The notes tab will still be created but may not work correctly."
fi

# Tab names
TAB1_NAME="nvim"
TAB2_NAME="sh"

# Check if session already exists
SESSION_EXISTS=$(tmux list-sessions | grep "$SESSION_NAME")

if [ -z "$SESSION_EXISTS" ]; then
  # Create a new session without attaching to it
  tmux new-session -d -s "$SESSION_NAME"

  # pane 1
  tmux rename-window -t "$SESSION_NAME":1 "$TAB1_NAME"
  tmux send-keys -t "$SESSION_NAME":"$TAB1_NAME" "cd $SESSION_DIR; clear; nvim ." C-m

  # pane 2
  tmux new-window -t "$SESSION_NAME":2 -n "$TAB2_NAME"
  tmux send-keys -t "$SESSION_NAME":"$TAB2_NAME" "cd $SESSION_DIR; clear" C-m

  # pane 3
  tmux new-window -t "$SESSION_NAME":3 -n "$TAB_NOTES_NAME"
  tmux send-keys -t "$SESSION_NAME":"$TAB_NOTES_NAME" "cd $TAB_NOTES_DIR; clear; nvim ." C-m

  echo "Created new session '$SESSION_NAME'"
  
else
  echo "Session '$SESSION_NAME' already exists"
fi

# Switch to the session
tmux switch-client -t "$SESSION_NAME":1
