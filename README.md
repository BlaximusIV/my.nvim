# my.nvim
My personal neovim configuration, from scratch, inspired from kickstart.nvim. Organized how I'd like it, with only the plugins I want.

## Preinstallation
There are a few prerequisites for the plugins to work correctly. 

  - Neovim
  - A Nerd Font
  - git
  - make / GnuWin32
  - ripgrep
  - wget
  - fd
  - unzip
  - gzip
  - mingw
  - gcc
  - nodejs

If using windows, I suggest using the chocolatey package manager for as much of the installation as possible. It makes it all much easier. `winget install Chocolatey`.

## Structure
In general, this is all trying to make the plugins modular and digestible using the plugin structure in the `:help lua-guide` documentation.
