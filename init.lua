vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/gbprod/yanky.nvim",
  "https://github.com/gbprod/substitute.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/RRethy/vim-illuminate",
  "https://github.com/vim-test/vim-test",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  { src = "https://github.com/catppuccin/nvim",                     name = "catppuccin" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" },
  { src = "https://github.com/saghen/blink.cmp",                    version = vim.version.range("1.x") },
})

-- base

vim.cmd.colorscheme("catppuccin-macchiato")

vim.g.mapleader = ","

vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>")
vim.keymap.set("n", "<leader>pu", vim.pack.update)

-- lsp

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "rust_analyzer", "sorbet", "ty", "ruff", "lua_ls" },
})

vim.lsp.config("sorbet", {
  cmd = { "env", "SRB_SKIP_GEM_RBIS=1", ".vscode/run-sorbet", "--lsp" }
})
vim.lsp.enable("sorbet")

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)

-- diagnostics

vim.diagnostic.config({
  virtual_lines = true
})

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- mini

require("mini.ai").setup()
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "┃", change = "┃", delete = "▁" },
  },
})
require("mini.statusline").setup()
require("mini.misc").setup_auto_root()
require("mini.trailspace").setup()
local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  items = {
    starter.sections.builtin_actions(),
    starter.sections.recent_files(5, false),
    starter.sections.recent_files(5, true),
  },
})
require("mini.bufremove").setup()
require('mini.notify').setup()
local indentscope = require("mini.indentscope")
indentscope.setup({
  draw = { animation = indentscope.gen_animation.none() },
  options = { try_as_border = true },
  symbol = "│",
})
require("mini.basics").setup({
  options = { basic = true, extra_ui = true },
  mappings = { basic = true, windows = true },
})
require("mini.bracketed").setup()
require("mini.move").setup({
  mappings = { line_down = "]e", line_up = "[e" },
})
require("mini.surround").setup()

vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete() end)
vim.keymap.set("n", "<leader>bD", function() MiniBufremove.delete(0, true) end)

-- yanky / substitute

require("yanky").setup()

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

local substitute = require("substitute")
substitute.setup({
  on_substitute = require("yanky.integration").substitute(),
})

vim.keymap.set("n", "s", substitute.operator, { noremap = true })
vim.keymap.set("n", "ss", substitute.line, { noremap = true })
vim.keymap.set("n", "S", substitute.eol, { noremap = true })
vim.keymap.set("x", "s", substitute.visual, { noremap = true })

-- oil

require("oil").setup({
  delete_to_trash = true
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

-- vim-test

vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>")
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>")

-- bufferline

require("bufferline").setup({
  options = {
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    custom_filter = function(buf)
      return vim.bo[buf].filetype ~= "qf"
    end
  }
})

vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "]B", "<cmd>BufferLineGoToBuffer -1<cr>")
vim.keymap.set("n", "[B", "<cmd>BufferLineGoToBuffer 1<cr>")
vim.keymap.set("n", "]v", "<cmd>BufferLineMoveNext<cr>")
vim.keymap.set("n", "[v", "<cmd>BufferLineMovePrev<cr>")
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>")
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>")
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>")
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>")

-- fzf-lua

local fzf_lua = require("fzf-lua")
fzf_lua.setup({
  actions = {
    files = {
      ["enter"] = fzf_lua.actions.file_edit,
    },
  }
})
fzf_lua.register_ui_select()

vim.keymap.set("n", "<leader>ff", fzf_lua.global)
vim.keymap.set("n", "<leader>fr", fzf_lua.oldfiles)
vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep)
vim.keymap.set("n", "<leader>fw", fzf_lua.grep_cword)
vim.keymap.set("n", "<leader>fG", fzf_lua.grep)
vim.keymap.set("n", "<leader>fb", fzf_lua.buffers)
vim.keymap.set("n", "<leader>fs", fzf_lua.lsp_workspace_symbols)
vim.keymap.set("n", "<leader>gd", fzf_lua.lsp_definitions)
vim.keymap.set("n", "<leader>gi", fzf_lua.lsp_implementations)
vim.keymap.set("n", "<leader>gr", fzf_lua.lsp_references)
vim.keymap.set("n", "<leader>ca", fzf_lua.lsp_code_actions)
vim.keymap.set("n", "<leader>fl", fzf_lua.resume)

-- conform

require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- indent-blankline

require("ibl").setup({
  indent = { char = "│" }
})

-- others

require("blink.cmp").setup({})
require("illuminate").configure({})
require("lazydev").setup({})
