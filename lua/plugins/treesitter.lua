return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"python",
				"cpp",
				"c",
				"cmake",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"html",
				"bash",
				"markdown",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
