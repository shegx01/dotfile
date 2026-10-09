# asdf's shims, moved here from .zshrc so non-interactive shells get them too.
# Claude Code's statusline runs `node <hud>` without an interactive shell, and node
# exists only as an asdf shim, so in .zshrc the HUD silently rendered nothing.
# Guarded because .zshenv is read by every zsh, including nested ones.
case ":$PATH:" in
  *":${ASDF_DATA_DIR:-$HOME/.asdf}/shims:"*) ;;
  *) export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH" ;;
esac
