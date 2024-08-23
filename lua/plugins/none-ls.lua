return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        require("none-ls.diagnostics.flake8").with({
          diagnostic_config = {
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
          },
          extra_args = {
            "--max-line-length=79",
            "ignore=...",
          },
        }),
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
