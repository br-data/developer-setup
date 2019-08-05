# Set name of the theme from ~/.oh-my-zsh/themes/
ZSH_THEME="ys"

# Load oh-my-zsh plugins from ~/.oh-my-zsh/plugins/
plugins=(osx vscode git git-extras brew node npm pip)

# Initialize oh-my-zsh
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Set Visual Studio Code as standard editor
export EDITOR="code -w"

# User paths
export PATH=$PATH:"/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin"

# Path for additional Python packages
PYTHONPATH=/usr/local/lib/python3.7/site-packages:$PYTHONPATH
PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export PYTHONPATH
