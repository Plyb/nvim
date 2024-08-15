return {
  "airblade/vim-gitgutter",
  config = function()
  vim.cmd("let g:gitgutter_sign_priority = 0")
  vim.cmd("let g:gitgutter_realtime = 1")
  vim.cmd("let g:git_gutter_eager = 1")
  end,
}
