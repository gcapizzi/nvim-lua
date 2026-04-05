vim.pack.add({
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/gbprod/yanky.nvim',
  'https://github.com/gbprod/substitute.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/vim-test/vim-test',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/tpope/vim-unimpaired',
  'https://github.com/tpope/vim-eunuch',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
})

-- base

vim.o.number = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.updatetime = 500
vim.opt.listchars = {
  eol = "¬",
  space = "·",
  extends = "«",
  precedes = "»",
  tab = "‣ ",
}

vim.cmd.colorscheme('catppuccin-macchiato')

vim.g.mapleader = ","

vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>")

-- lsp

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'gopls', 'rust_analyzer', 'sorbet', 'ty', 'ruff' },
})

vim.lsp.config('sorbet', {
  cmd = { "env", "SRB_SKIP_GEM_RBIS=1", ".vscode/run-sorbet", "--lsp" }
})
vim.lsp.enable('sorbet')

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", { buffer = args["buf"], callback = function() vim.lsp.buf.format() end })
    end

    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, { buffer = args["buf"], callback = function() vim.lsp.buf.document_highlight() end })
      vim.api.nvim_create_autocmd("CursorMoved", { buffer = args["buf"], callback = function() vim.lsp.buf.clear_references() end })
    end
  end,
})

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)

-- diagnostics

vim.diagnostic.config({
  virtual_lines = true
})

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

-- snacks

require("snacks").setup({
  bufdelete = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { icon = " ", title = "Recent Files ", file = vim.fn.fnamemodify(".", ":~") },
      { section = "recent_files", cwd = true, limit = 8, indent = 2, padding = 1 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    },
  },
  indent = { enabled = true, animate = { enabled = false } },
  input = { enabled = true },
})

vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end)
vim.keymap.set("n", "<leader>bD", function() Snacks.bufdelete({ force = true }) end)

-- mini

require('mini.ai').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┃', delete = '▁' },
  },
})
require('mini.statusline').setup()
require('mini.misc').setup_auto_root()
require('mini.trailspace').setup()
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = function(args)
    vim.b[args.buf].minitrailspace_disable = true
  end,
})

-- yanky / substitute

require('yanky').setup()

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

local substitute = require('substitute')
substitute.setup({
  on_substitute = require('yanky.integration').substitute(),
})

vim.keymap.set("n", "s", substitute.operator, { noremap = true })
vim.keymap.set("n", "ss", substitute.line, { noremap = true })
vim.keymap.set("n", "S", substitute.eol, { noremap = true })
vim.keymap.set("x", "s", substitute.visual, { noremap = true })

-- oil

require('oil').setup({
  delete_to_trash = true
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- vim-test

vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>")
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>")

-- bufferline

require('bufferline').setup({
  options = {
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    custom_filter = function(buf, buf_nums)
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

-- others

require('blink.cmp').setup()
require('fidget').setup()
