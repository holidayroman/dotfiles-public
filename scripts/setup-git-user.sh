#!/usr/bin/env bash

USER_CONFIG="$HOME/.gitconfig.user"

# Check if git user is already configured
if [ -f "$USER_CONFIG" ]; then
  echo "Git user already configured:"
  grep -A2 "\[user\]" "$USER_CONFIG" | tail -2
  read -p "Do you want to update? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

echo "Setting up Git user information..."
read -p "Enter your name: " git_name
read -p "Enter your email: " git_email

# Write to user config (not tracked in dotfiles)
cat > "$USER_CONFIG" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF

echo "✅ Git user configured in $USER_CONFIG"
echo "  Name: $git_name"
echo "  Email: $git_email"
