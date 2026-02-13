#!/bin/bash
# Creates stub ~/.zshrc and ~/.vimrc files if they don't exist.
# If they exist but don't source the shared config, prompt the user to add it.

set -e

create_stub() {
  local file="$1"
  local source_line="$2"
  local comment_prefix="$3"
  local shared_name="$4"

  if [ ! -f "$file" ] || [ -L "$file" ]; then
    # Remove symlink if present (left over from old dotfiles layout)
    [ -L "$file" ] && rm "$file"
    printf '%s\n\n%s Local customizations below (overrides shared settings)\n' "$source_line" "$comment_prefix" > "$file"
    echo "Created $file (sources $shared_name)"
  elif ! grep -qF "$source_line" "$file"; then
    echo ""
    echo "$file exists but does not source $shared_name."
    printf "Add '%s' to the top of %s? [y/N] " "$source_line" "$file"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      tmp=$(mktemp)
      printf '%s\n\n' "$source_line" | cat - "$file" > "$tmp" && mv "$tmp" "$file"
      echo "Updated $file"
    else
      echo "Skipped $file — please add '$source_line' manually."
    fi
  else
    echo "$file already sources $shared_name — no changes needed."
  fi
}

create_stub "$HOME/.zshrc" "source ~/.zshrc.shared" "#" "~/.zshrc.shared"
create_stub "$HOME/.vimrc" "source ~/.vimrc.shared" "\"" "~/.vimrc.shared"
