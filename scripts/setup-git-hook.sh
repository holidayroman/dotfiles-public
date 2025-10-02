#!/bin/bash

# Create pre-commit hook for dotfiles repo only
DOTFILES_DIR="$HOME/.dotfiles"
HOOK_FILE="$DOTFILES_DIR/.git/hooks/pre-commit"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  echo "Dotfiles git directory not found, skipping hook setup"
  exit 0
fi

if [ ! -f "$HOOK_FILE" ]; then
  cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash

# Pre-commit hook to prevent committing sensitive terms
# This hook is LOCAL to the dotfiles repo and not tracked in git

BLOCKED_TERMS=(
    # Add your sensitive terms here, one per line
    # Example: "myname"
    # Example: "mysecretkey"
)

# Check staged files for blocked terms
for term in "${BLOCKED_TERMS[@]}"; do
    # Skip empty terms
    [ -z "$term" ] && continue

    if git diff --cached | grep -i "$term" > /dev/null; then
        echo "❌ ERROR: Commit blocked!"
        echo "Found blocked term: '$term'"
        echo ""
        echo "Occurrences:"
        git diff --cached | grep -n -i --color=always "$term"
        echo ""
        echo "Remove this term from your changes before committing."
        exit 1
    fi
done

exit 0
EOF
  chmod +x "$HOOK_FILE"
  echo ""
  echo "✅ Created pre-commit hook at $HOOK_FILE"
  echo ""
  echo "📝 IMPORTANT: Edit the hook to add terms you don't want to commit:"
  echo "   vim $HOOK_FILE"
  echo ""
  echo "   Add sensitive terms to the BLOCKED_TERMS array (e.g., your name, email, keys)"
  echo ""
else
  echo "Pre-commit hook already exists at $HOOK_FILE"
fi
