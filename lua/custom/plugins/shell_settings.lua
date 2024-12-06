-- Check if 'pwsh' (PowerShell Core) is available; otherwise, use Windows PowerShell
if vim.fn.executable 'pwsh' == 1 then
  vim.opt.shell = 'pwsh'
elseif vim.fn.executable 'powershell' == 1 then
  vim.opt.shell = 'powershell'
end

-- Configure shell options for PowerShell
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.opt.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

return {}
