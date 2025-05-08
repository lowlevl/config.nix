# shell: enable and configure shell and tools
{...}: {
  programs.dircolors.enable = true;
  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      pgrep = "pgrep --color=auto";
    };

    historyControl = ["erasedups" "ignoreboth"];
    initExtra = ''
      if [[ ''${EUID} == 0 ]] ; then
        PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
      else
        PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
      fi
    '';
  };
}
