#!/bin/zsh

sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &

export NONINTERACTIVE=1
export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_ENV_HINTS=1
export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

# Install xCode cli tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing commandline tools..."
  xcode-select --install
  echo "Waiting for xcode-select installation to complete..."
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

# Homebrew
## Install
if ! command -v brew &>/dev/null && [ ! -x /opt/homebrew/bin/brew ]; then
  echo "Installing Brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae
brew tap asmvik/formulae
brew tap stablyai/orca
brew trust --tap FelixKratz/formulae asmvik/formulae stablyai/orca

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install llvm
brew install boost
brew install wget
brew install jq
brew install ripgrep
brew install bear
brew install gh
brew install ifstat
brew install switchaudio-osx
brew install skhd
brew install sketchybar
brew install borders
brew install yabai

### Terminal
brew install neovim
brew install helix
brew install starship
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
brew install tmux
brew install herdr
brew install zoxide
brew install fzf
brew install glow

### Security
brew install gnupg

### Nice to have
brew install lulu
brew install btop
# brew install svim # disabled
brew install lazygit
brew install wireguard-go
brew install dooit

### Custom HEAD only forks
brew install fnnn --head # nnn fork (changed colors, keymappings)

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask ghostty
brew install --cask orion
brew install --cask brave-browser

### Dev Tools
brew install --cask docker
brew install --cask datagrip
brew install --cask apidog
brew install --cask stablyai/orca/orca

### Communication
brew install --cask slack
brew install --cask telegram

### Office
brew install --cask zoom
brew install --cask meetingbar
brew install --cask skim
brew install --cask vlc

### Utilities
brew install --cask sloth

### Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write -g NSWindowShouldDragOnGesture YES

## Fix for MX Master 3S
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid

# Copying and checking out configuration files
echo "Planting Configuration Files..."
DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:shegx01/dotfile.git}"
cfg() { git --git-dir="$HOME/dotfiles/" --work-tree="$HOME" "$@"; }
if [ ! -d "$HOME/dotfiles" ]; then
  git clone --bare "$DOTFILES_REPO" "$HOME/dotfiles"
else
  cfg remote set-url origin "$DOTFILES_REPO"
  cfg fetch origin main
  if [ -f "$HOME/dotfiles/index" ]; then
    cfg merge --ff-only FETCH_HEAD
  else
    cfg update-ref refs/heads/main FETCH_HEAD
  fi
fi
if ! cfg checkout main 2>/dev/null; then
  backup="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing files that conflict with the dotfiles to $backup"
  cfg checkout main 2>&1 | awk '/^[[:space:]]/ {print $1}' | while read -r f; do
    mkdir -p "$backup/$(dirname "$f")"
    mv "$HOME/$f" "$backup/$f"
  done
  cfg checkout main
fi

# herdr plugins (config is planted above; plugin payloads are machine-local)
echo "Installing herdr plugins..."
sh $HOME/.config/herdr/install-plugins.sh

# Installing Fonts
git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

source $HOME/.zshrc
cfg config --local status.showUntrackedFiles no

# asdf version manager
echo "Installing asdf..."
brew install asdf
. "$(brew --prefix asdf)/libexec/asdf.sh"

## asdf plugins
echo "Installing asdf plugins..."
asdf plugin add erlang
asdf plugin add nodejs
asdf plugin add elixir
asdf plugin add rust

asdf install erlang latest && asdf set --home erlang latest
asdf install nodejs latest && asdf set --home nodejs latest
asdf install elixir latest && asdf set --home elixir latest
asdf install rust latest && asdf set --home rust latest

# Global npm packages
echo "Installing global npm packages..."
npm i -g oh-my-claude-sisyphus@latest
npm i -g vscode-langservers-extracted

echo "Installing agent skills..."
sh $HOME/.agents/install-skills.sh

# Language servers
echo "Installing language servers..."
curl -sL https://github.com/elixir-tools/next-ls/releases/latest/download/next_ls_darwin_arm64 -o /opt/homebrew/bin/nextls && chmod +x /opt/homebrew/bin/nextls
brew install taplo
rustup component add rust-analyzer

# Python
echo "Installing Python..."
if [ ! -d "$HOME/miniforge3" ]; then
  curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh -o /tmp/miniforge.sh
  bash /tmp/miniforge.sh -b -p "$HOME/miniforge3"
  rm -f /tmp/miniforge.sh
fi
source $HOME/.zshrc

# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start fyabai
brew services start sketchybar
brew services start borders
# brew services start svim # disabled

echo "Orca: launch it once, quit it, then run: sh ~/.config/orca/sync-settings.sh apply"
csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"
echo "Installation complete...\n"
