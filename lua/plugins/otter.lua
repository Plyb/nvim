return {
  "jmbuhr/otter.nvim",
  opts = {}, -- You can add custom options here
  config = function()
    require("otter").setup()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        require("otter").activate()
      end,
    })
  end,
}
