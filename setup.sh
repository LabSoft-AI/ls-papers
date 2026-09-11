#!/usr/bin/env bash
# setup.sh — install the ls-papers toolchain for your OS.
#
# Installs: pandoc, pandoc-crossref, XeLaTeX (TeX Live), librsvg, git-lfs,
# and a Cyrillic-capable font (DejaVu). Then runs `git lfs install`.
#
# Usage: ./setup.sh

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[x]\033[0m %s\n' "$1" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

install_macos() {
  info "Detected macOS."
  if ! have brew; then
    err "Homebrew is required. Install from https://brew.sh and re-run."
    exit 1
  fi
  info "Installing pandoc, pandoc-crossref, librsvg, git-lfs..."
  brew install pandoc pandoc-crossref librsvg git-lfs

  if ! have xelatex; then
    info "Installing MacTeX (no GUI) — this is large, may take a while..."
    brew install --cask mactex-no-gui
    warn "You may need to open a new shell so xelatex is on PATH."
  else
    info "xelatex already present."
  fi
  warn "DejaVu fonts: on macOS the template can use 'Times New Roman' as mainfont."
}

install_debian() {
  info "Detected Debian/Ubuntu."
  info "Installing pandoc, pandoc-crossref, TeX Live (xetex), librsvg, fonts, git-lfs..."
  sudo apt-get update
  sudo apt-get install -y \
    pandoc pandoc-crossref \
    texlive-xetex texlive-latex-recommended texlive-latex-extra \
    texlive-fonts-recommended fonts-dejavu \
    librsvg2-bin git-lfs
}

install_fedora() {
  info "Detected Fedora/RHEL."
  info "Installing toolchain via dnf..."
  sudo dnf install -y \
    pandoc pandoc-crossref \
    texlive-xetex texlive-collection-latexrecommended \
    texlive-collection-fontsrecommended dejavu-serif-fonts \
    librsvg2-tools git-lfs
}

# Install pre-commit and register the git hooks (commit + commit-msg stages).
install_precommit() {
  info "Setting up pre-commit hooks..."
  if ! have pre-commit; then
    if have pipx; then
      pipx install pre-commit
    elif have pip3; then
      pip3 install --user pre-commit
    elif have brew; then
      brew install pre-commit
    else
      warn "Could not install pre-commit (no pipx/pip3/brew). Install it manually:"
      warn "  pipx install pre-commit   # or: pip3 install --user pre-commit"
      return 0
    fi
  fi
  # Register both the pre-commit and commit-msg stage hooks.
  pre-commit install
  pre-commit install --hook-type commit-msg
  info "pre-commit hooks installed (run 'pre-commit run --all-files' to test)."
}

main() {
  local os
  os="$(uname -s)"

  case "$os" in
    Darwin) install_macos ;;
    Linux)
      if [ -f /etc/debian_version ]; then
        install_debian
      elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        install_fedora
      else
        err "Unsupported Linux distro. Install manually (see README.md)."
        exit 1
      fi
      ;;
    *)
      err "Unsupported OS: $os. Install manually (see README.md)."
      exit 1
      ;;
  esac

  info "Initializing git-lfs..."
  git lfs install

  install_precommit

  info "Verifying toolchain:"
  for tool in pandoc pandoc-crossref xelatex git-lfs; do
    if have "$tool"; then
      printf '    \033[1;32mok\033[0m  %s\n' "$tool"
    else
      printf '    \033[1;31mMISSING\033[0m  %s\n' "$tool"
    fi
  done

  info "Done. Try: make list  then  make paper=<folder>"
}

main "$@"
