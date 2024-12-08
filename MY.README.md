# Additional setup:
There are a few things that are going to need to be run to get this fully operational. First, we need all the dependencies like python, node, etc.

## Windows
First, make sure to get chocolatey installed:
`winget install Chocolatey`

After refreshing the terminal:
`choco install nvim nodejs llvm cmake gcc`

You'll also need to download [doelldb](https://github.com/vadimcn/codelldb/releases) and make sure you put the absolute path in the dap plugin lua file.
