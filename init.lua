vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set relativenumber")
vim.cmd("set number")

vim.cmd("set clipboard+=unnamedplus")

vim.cmd("set ignorecase")

vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Powershell
if package.config:sub(1, 1) == "\\" then -- Check if the OS is windows by grabbing the path seperator.
	vim.o.shell = "powershell"
	vim.o.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
end

-- Lazy
require("config.lazy")

vim.keymap.set("n", "<leader>/", ":noh<cr>", {})

vim.cmd("nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')")
vim.cmd("nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')")

vim.cmd("set updatetime=100")
