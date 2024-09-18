local function get_max_line_length()
	local cur_dir = vim.fn.getcwd():gsub("\\", "/")
	local flake_files = { cur_dir .. "/.flake8", cur_dir .. "/tox.ini" }

	local data = nil

	for _, file_path in ipairs(flake_files) do
		local flake_file = io.open(file_path, "r")
		if flake_file then
			data = flake_file:read("*a")
			flake_file:close()
			break
		end
	end

	if not data then
		return nil
	end

	local max_line = string.match(data, "max%-line%-length = %d+")

	if not max_line then
		return nil
	end

	local max = string.match(max_line, "%d+")
	return tonumber(max)
end

return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvimtools/none-ls-extras.nvim" },
	config = function()
		local max_line_length = get_max_line_length()
		if max_line_length then
			vim.cmd("set colorcolumn=" .. max_line_length + 1)
		else
			max_line_length = 79
		end
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
						update_in_insert = true,
						underline = true,
					},
					extra_args = {
						"--max-line-length=" .. max_line_length,
						"ignore=...",
					},
				}),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
