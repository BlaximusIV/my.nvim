return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown', 'mdx' },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
  config = function()
    vim.g.mkdp_auto_start = 1
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_browser = 'brave'
    vim.g.mkdp_filetypes = { 'markdown', 'mdx' }
  end,
}
