vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.number = true

vim.opt.mouse = "a"
vim.opt.showmode = false

vim.g.clipboard = "osc52"

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 100

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

vim.keymap.set("n", "<leader>/", ":noh<cr>", {})

vim.cmd("nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')")
vim.cmd("nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')")

vim.keymap.set("n", "<leader>z", ":set spell spelllang=en_us<CR>")
vim.keymap.set("n", "<leader>zr", ":set nospell<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = True, silent = True })

vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter folds

vim.api.nvim_create_user_command('ComputeKernelInit', function(opts)
  local sbatch_lines = {
    '#SBATCH --time=08:00:00', -- defaults
    '#SBATCH --mem=32G',
    '#SBATCH --gpus=1',
  }
  for _, arg in ipairs(opts.fargs) do
    local key, val = string.match(arg, "([^=]+)=([^=]+)")
    if key and val then
      table.insert(sbatch_lines, "#SBATCH --" .. key .. "=" .. val)
    end
  end

  local kernels = vim.fn.MoltenAvailableKernels()

  vim.ui.select(kernels, {
    prompt = 'Select a kernel',
  }, function (kernel)
    local sbatch_script = [[#!/bin/bash

#SBATCH --job-name=compute-kernel
]]
      .. table.concat(sbatch_lines, "\n")
      .. [[

# Extract the first 192.168.* IP address
ip=\$(hostname -I | tr ' ' '\n' | grep -m1 '^192\.168')

# Use it to launch the Jupyter kernel
jupyter kernel --ip="\$ip" --kernel="]] .. kernel .. '"'

    local script = [[#!/bin/bash

script="]] .. sbatch_script .. [=[
"

# Launch job and capture job ID
sbatch_output=$(echo "$script" | sbatch)
job_id=$(echo "$sbatch_output" | awk '{print $NF}')

# Construct the expected output file path (customize as needed)
# Default Slurm output: slurm-<jobid>.out in current dir
out_file="slurm-${job_id}.out"

# Wait until the output file exists
while [[ ! -f "$out_file" ]]; do
  sleep 1
done

# Tail the file for the pattern; stop after finding the first match
file_path=$(stdbuf -oL tail -F "$out_file" | \
  grep --line-buffered -m 1 -oP '\[KernelApp\] Connection file: \K.*')

# Print the extracted file_path
echo "$file_path"

rm "slurm-${job_id}.out"
]=]

    local tmpname = os.tmpname()
    local f = io.open(tmpname, "w")
    f:write(script)
    f:close()

    vim.api.nvim_echo({{'Launching on compute node (this takes a minute)...'}}, true, {})

    local output = vim.fn.system({'bash', tmpname})
    output = vim.trim(output)

    os.remove(tmpname)

    vim.api.nvim_echo({{'Launched. Initializing Molten...'}}, true, {})

    vim.cmd('MoltenInit ' .. output)
  end)
end, {
    nargs = '*',
    desc = 'Start a kernel on a compute node and init Molten with it'
})

