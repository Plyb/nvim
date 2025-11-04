return {
  'akinsho/toggleterm.nvim',
  init = function ()
    require('toggleterm').setup({
      open_mapping = [[<c-_>]],
      shell = "/usr/bin/bash -l"
    })
    local opts = {}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  end
}
