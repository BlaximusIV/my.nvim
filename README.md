# my.nvim
My personal neovim configuration, from scratch, inspired from kickstart.nvim. Organized how I'd like it, with only the plugins I want.

## Preinstallation
There are a few prerequisites for the plugins to work correctly. 

Base Requirements
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
Python Development
  - python
  - pip `python -m ensurepip --upgrade`
  - debugpy `pip install debugpy`
Csharp Development
  - dotnet 8 sdk `winget install Microsoft.DotNet.SDK.8`

If using windows, I suggest using the chocolatey package manager for as much of the installation as possible. It makes it all much easier. `winget install Chocolatey`.

## Structure
In general, this is all trying to make the plugins modular and digestible using the plugin structure in the `:help lua-guide` documentation.

## Other Notes
Other things to keep in mind
  - You may need to update LSP servers after installing them for them to start working on the code
  - Flutter is run and debugged via flutter commands e.g. :FlutterRun, :FlutterQuit
