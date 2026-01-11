#!/bin/sh

# Shared tab definitions

PROJECTS="~/projects"
TAB_NOTES_NAME="notes"
TAB_NOTES_DIR="~/notes"

# Session 1 definitions

SESSION1="Story1"
SESSION_EXISTS=$(tmux list-sessions | grep "$SESSION1")
SESSION1_DIR=$(PROJECTS)/

TAB1_NAME="nvim"
TAB2_NAME="sh"

# Session 1 definitions

SESSION2="Story2"
SESSION2_EXISTS=$(tmux list-sessions | grep "$SESSION2")
SESSION2_DIR=$(PROJECTS)

if [ -z "$SESSION_EXISTS" ]; then
  tmux new-session -d -s "$SESSION1"

  # pane 1
  tmux rename-window -t 1 "$TAB1_NAME"
  tmux send-keys -t "$TAB1_NAME" "cd $SESSION1_DIR; clear; nvim ."

  # pane 2
  tmux new-window -t "$SESSION1":2 -n "$TAB2_NAME"
  tmux send-keys -t "$TAB2_NAME" "cd $SESSION1_DIR; clear"

  # pane 3
  tmux new-window -t "$SESSION1":3 -n "$TAB_NOTES_NAME"
  tmux send-keys -t "$TAB_NOTES_NAME" "cd $TAB_NOTES_DIR; clear; nvim ."
fi

if [ -z "$SESSION2_EXISTS" ]; then
  tmux new-session -d -s "$SESSION2"

  # pane 1
  tmux rename-window -t 1 "$TAB1_NAME"
  tmux send-keys -t "$TAB1_NAME" "cd $SESSION2_DIR; clear"

  # pane 2
  tmux new-window -t "$SESSION2":2 -n "$TAB2_NAME"
  tmux send-keys -t "$TAB2_NAME" "cd $SESSION2_DIR; clear"

  # pane 3
  tmux new-window -t "$SESSION2":3 -n "$TAB_NOTES_NAME"
  tmux send-keys -t "$TAB_NOTES_NAME" "cd $TAB_NOTES_DIR; clear; nvim ."
fi

tmux a -t "$SESSION1":1
