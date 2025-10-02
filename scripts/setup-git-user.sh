#!/usr/bin/env bash

USER_CONFIG="$HOME/.gitconfig.user"
DOTFILES_DIR="$HOME/.dotfiles"

# Configure global git user
if [ -f "$USER_CONFIG" ]; then
  echo "Global git user already configured:"
  grep -A2 "\[user\]" "$USER_CONFIG" | tail -2
  read -p "Do you want to update? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping global git user update"
  else
    echo "Setting up global Git user information..."
    read -p "Enter your name: " git_name
    read -p "Enter your email: " git_email

    cat > "$USER_CONFIG" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF

    echo "✅ Global git user configured in $USER_CONFIG"
    echo "  Name: $git_name"
    echo "  Email: $git_email"
  fi
else
  echo "Setting up global Git user information..."
  read -p "Enter your name: " git_name
  read -p "Enter your email: " git_email

  cat > "$USER_CONFIG" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF

  echo "✅ Global git user configured in $USER_CONFIG"
  echo "  Name: $git_name"
  echo "  Email: $git_email"
fi

echo ""

# Configure dotfiles-specific git user
if [ -d "$DOTFILES_DIR/.git" ]; then
  DOTFILES_USER=$(git -C "$DOTFILES_DIR" config user.name 2>/dev/null)

  if [ -n "$DOTFILES_USER" ]; then
    echo "Dotfiles repo user already configured:"
    echo "  Name: $(git -C "$DOTFILES_DIR" config user.name)"
    echo "  Email: $(git -C "$DOTFILES_DIR" config user.email)"
    read -p "Do you want to update? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 0
    fi
  fi

  echo "Setting up dotfiles repo-specific Git user..."
  read -p "Enter your name for dotfiles commits: " dotfiles_name
  read -p "Enter your email for dotfiles commits: " dotfiles_email

  git -C "$DOTFILES_DIR" config user.name "$dotfiles_name"
  git -C "$DOTFILES_DIR" config user.email "$dotfiles_email"

  echo "✅ Dotfiles repo user configured"
  echo "  Name: $dotfiles_name"
  echo "  Email: $dotfiles_email"
fi
