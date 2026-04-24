#!/usr/bin/env bash
# tmux cheatsheet — rendered with Tokyo Night ANSI.
# Invoked by tmux.conf via `display-popup` piped through `less -R`.
# Edit the Python generator in git history if you want to tweak the look.

printf '%b' "
  \033[1m\033[38;2;187;154;247mtmux\033[0m  \033[38;2;86;95;137m·\033[0m  prefix: \033[38;2;158;206;106mCtrl-Space\033[0m
  \033[38;2;86;95;137m(tap Ctrl-Space, release, then the command key)\033[0m

  \033[1m\033[38;2;125;207;255mWINDOWS\033[0m    \033[38;2;86;95;137m· like browser tabs\033[0m
    \033[1m\033[38;2;224;175;104mc\033[0m          new window
    \033[1m\033[38;2;224;175;104mn\033[0m  \033[1m\033[38;2;224;175;104mp\033[0m       next / previous
    \033[1m\033[38;2;224;175;104m1..9\033[0m       jump to window N
    \033[1m\033[38;2;224;175;104m,\033[0m          rename current window
    \033[1m\033[38;2;224;175;104m&\033[0m          close window \033[38;2;86;95;137m(asks to confirm)\033[0m

  \033[1m\033[38;2;125;207;255mPANES\033[0m      \033[38;2;86;95;137m· splits inside a window\033[0m
    \033[1m\033[38;2;224;175;104m|\033[0m          split vertically   \033[38;2;86;95;137m(side-by-side)\033[0m
    \033[1m\033[38;2;224;175;104m-\033[0m          split horizontally \033[38;2;86;95;137m(top + bottom)\033[0m
    \033[1m\033[38;2;224;175;104m← ↓ ↑ →\033[0m    move between panes
    \033[1m\033[38;2;224;175;104mz\033[0m          zoom current pane  \033[38;2;86;95;137m(toggle fullscreen)\033[0m
    \033[1m\033[38;2;224;175;104mx\033[0m          close pane
    \033[1m\033[38;2;224;175;104mspace\033[0m      cycle pane layouts

  \033[1m\033[38;2;125;207;255mSESSION\033[0m    \033[38;2;86;95;137m· the whole workspace\033[0m
    \033[1m\033[38;2;224;175;104md\033[0m          detach \033[38;2;86;95;137m(leave it running, come back later)\033[0m
    \033[1m\033[38;2;224;175;104ms\033[0m          switch to another session
    \033[1m\033[38;2;224;175;104m$\033[0m          rename session

  \033[1m\033[38;2;125;207;255mHELP\033[0m
    \033[1m\033[38;2;224;175;104m?\033[0m  \033[1m\033[38;2;224;175;104mh\033[0m       show this cheat sheet  \033[38;2;86;95;137m(q to close)\033[0m
    \033[1m\033[38;2;224;175;104mr\033[0m          reload tmux config

  \033[38;2;86;95;137mScrollback: mouse wheel. [ enters copy-mode for search/copy.\033[0m

"
