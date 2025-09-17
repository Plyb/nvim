return {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_init_behavior = "init"
      vim.g.molten_enter_output_behavior = "open_and_enter"
      vim.g.molten_auto_image_popup = false
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_crop_border = false
      vim.g.molten_output_virt_lines = true
      vim.g.molten_output_win_max_height = 50
      vim.g.molten_output_win_style = "minimal"
      vim.g.molten_output_win_hide_on_leave = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_max_lines = 10000
      vim.g.molten_cover_empty_lines = false
      vim.g.molten_copy_output = true
      vim.g.molten_output_show_exec_time = false

      local NS = { noremap = true, silent = true }
      vim.keymap.set({"x"          }, "<S-Enter>"  , ":<C-u>MoltenEvaluateVisual<cr>gv"          , NS)
      vim.keymap.set({"n"          }, "<C-S-h>"    , "<cmd>MoltenHideOutput<cr>"                 , NS)
      vim.keymap.set({"n"          }, "<C-S-s>"    , "<cmd>noautocmd MoltenEnterOutput<cr>"      , NS)
      vim.keymap.set({"n"          }, "<C-S-r>"    , "<cmd>MoltenReevaluateAll<cr>"              , NS)
      vim.keymap.set({"n"          }, "<C-S-j>"    , "<cmd>MoltenNext<cr>"                       , NS)
      vim.keymap.set({"n"          }, "<C-S-k>"    , "<cmd>MoltenPrev<cr>"                       , NS)

      vim.keymap.set({"n"          }, "<S-Enter>"  , function() require("various-textobjs").mdFencedCodeBlock("inner"); vim.cmd("MoltenEvaluateOperator"); end, NS)
      vim.keymap.set({     "i"     }, "<S-Enter>"  , function() vim.cmd("stopinsert"); require("various-textobjs").mdFencedCodeBlock("inner"); vim.cmd("MoltenEvaluateOperator"); end, NS)

      vim.keymap.set({"n"          }, "<C-Tab>"      , "/\\(```.\\|](\\)<cr>:nohl<cr>"             , NS)
      vim.keymap.set({"n"          }, "<C-S-Tab>"    , "?\\(```.\\|](\\)<cr>:nohl<cr>"             , NS)

      local custom_augroup = vim.api.nvim_create_augroup("CustomMoltenCommands", { clear = true })
      local molten_inited = false
      vim.api.nvim_create_autocmd("User", {
        group = custom_augroup,
        pattern = "MoltenInitPost",
        callback = function()
          molten_inited = true
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = custom_augroup,
        pattern = { "*.md" },
        callback = function()
          if molten_inited then
            vim.cmd("MoltenSave")
          end
        end,
      })
    end
  }
