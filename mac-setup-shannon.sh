#!/bin/sh

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing cask..."
brew install caskroom/cask/brew-cask

echo "Tapping versions"
brew tap caskroom/versions

echo "Installing pre-requisites"
sudo xcodebuild -license
brew cask install osxfuse
brew cask install xquartz

echo "Tapping R"
brew tap homebrew/science

binaries=(
  graphicsmagick
  webkit2png
  rename
  zopfli
  ffmpeg
  python
  sshfs
  trash
  node
  tree
  ack
  hub
  git
  sbt
  gcc
  r
  autojump
  zsh
  zsh-completions
)

echo "installing binaries..."
brew install ${binaries[@]}

echo "cleaning up..."
brew cleanup

# Apps
apps=(
  java6
  alfred
  google-chrome
  qlcolorcode
  slack
  appcleaner
  firefox
  qlmarkdown
  spotify
  vagrant
  flash
  iterm2
  qlprettypatch
  shiori
  sublime-text3
  virtualbox
  atom
  flux
  mailbox
  qlstephen
  sketch
  tower
  sourcetree
  vlc
  cloudup
  nvalt
  quicklook-json
  skype
  gimp
  google-drive
  intellij-idea-ce  
  vagrant-manager
  rstudio
  keepassx
  fitbit-connect
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

echo "Linking alfred to cask"
brew cask alfred link

echo "Installing oh-my-zsh..."
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

echo "Creating Developer directory ~/Developer/config"
mkdir -p ~/Developer/config
touch ~/Developer/config/env.sh

echo "Installing mackup for use with google-drive"
pip install mackup
touch ~/.mackup.cfg
echo "[storage]" >> ~/.mackup.cfg
echo "engine = google_drive" >> ~/.mackup.cfg

echo ""
echo "Editing the .zshrc to include the following:"
# Edit .zshrc to include the following
echo "ZSH_THEME=pygmalion"
echo "alias zshconfig='subl ~/.zshrc'"
echo "alias envconfig='subl ~/Projects/config/env.sh'"
echo "alias hackdev='subl ~/Developer'"
echo "plugins=(git colored-man colorize github jira vagrant virtualenv pip python brew osx zsh-syntax-highlighting)"

echo "ZSH_THEME=pygmalion" >> ~/.zshrc
echo "alias zshconfig='subl ~/.zshrc'" >> ~/.zshrc
echo "alias envconfig='subl ~/Projects/config/env.sh'" >> ~/.zshrc
echo "alias hackdev='subl ~/Developer'" >> ~/.zshrc
echo "plugins=(git colored-man colorize github jira vagrant virtualenv pip python brew osx zsh-syntax-highlighting)" >> ~/.zshrc

echo ""
echo "Now running ./osx-for-shannon.sh"
. "./osx-for-shannon.sh"

echo "Creating Developer utils directory ~/Developer/utils"
mkdir ~/Developer/utils
cd ~/Developer/utils
git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git

echo "Fixing Google Drive app icon colour for dark mode"
source <(curl -s https://gist.githubusercontent.com/gboudreau/fcbe40d55787cfec38b3/raw/fix-google-drive-dark-mode-icons.sh)

echo "Fixing Mackup to point at correct Google Drive location"
original='Library\/Application Support\/Google\/Drive\/sync_config.db'
fixed='Library\/Application Support\/Google\/Drive\/user_default\/sync_config.db'
file="/usr/local/lib/python2.7/site-packages/mackup/utils.py"
grep "$original" $file &> /dev/null
if [ $? -ne 0 ]; then
  echo "Search string not found in $file!"
else
  sed -i '' "s/$original/$fixed/" $file
fi 

echo "Finished! Please install the follow the last manual steps:"
# Manual install list:
echo "appstore: better snap tool"
echo "Iterm2 themes: ~/Developer/utils/iTerm2-Color-Schemes"
echo "Setup google-drive then run: mackup backup"


