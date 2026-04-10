emulate sh
source ~/.profile
emulate zsh


# Setting PATH for Python 3.9
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
export PATH

  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles #ckbrew
  eval $(/opt/homebrew/bin/brew shellenv) #ckbrew



# Added by Toolbox App
export PATH="$PATH:/Users/mike/Library/Application Support/JetBrains/Toolbox/scripts"
# Setting PATH for Python 2.7
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
