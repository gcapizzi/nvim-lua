vim.o.number = true
vim.o.hidden = true
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

vim.g.mapleader = ","

vim.diagnostic.config({
  virtual_lines = true
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bufdelete = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", file = vim.fn.fnamemodify(".", ":~") },
          { section = "recent_files", cwd = true, limit = 8, indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
    },
  },
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.diff').setup({
        view = {
          style = 'sign',
          signs = { add = '┃', change = '┃', delete = '▁' },
        },
      })
      require('mini.statusline').setup()

      require('mini.misc').setup_auto_root()
    end,
  },
  {
    "nvim-mini/mini.trailspace",
    version = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "rust_analyzer", "sorbet", "pyright", "ruff" },
      })

      vim.lsp.config('sorbet', {
        cmd = { "env", "SRB_SKIP_GEM_RBIS=1", ".vscode/run-sorbet", "--lsp" }
      })
      vim.lsp.enable('sorbet')

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre",
              { buffer = args["buf"], callback = function() vim.lsp.buf.format() end })
          end
          if client:supports_method("textDocument/documentHighlight") then
            vim.api.nvim_create_autocmd("CursorHold",
              { buffer = args["buf"], callback = function() vim.lsp.buf.document_highlight() end })
            vim.api.nvim_create_autocmd("CursorHoldI",
              { buffer = args["buf"], callback = function() vim.lsp.buf.document_highlight() end })
            vim.api.nvim_create_autocmd("CursorMoved",
              { buffer = args["buf"], callback = function() vim.lsp.buf.clear_references() end })
          end
        end,
      })
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        rules = false,
        separator = ">",
      },
      spec = {
        { "<leader>f",  group = "Find" },
        { "<leader>ff", function() require('fzf-lua').global() end,                  desc = "Global" },
        { "<leader>fr", function() require('fzf-lua').oldfiles() end,                desc = "Recent File" },
        { "<leader>fg", function() require('fzf-lua').live_grep() end,               desc = "File via live grep" },
        { "<leader>fw", function() require('fzf-lua').grep_cword() end,              desc = "File via live grep (current word)" },
        { "<leader>fG", function() require('fzf-lua').grep() end,                    desc = "File via batch grep" },
        { "<leader>fb", function() require('fzf-lua').buffers() end,                 desc = "Buffer" },
        { "<leader>fs", function() require('fzf-lua').lsp_workspace_symbols() end,   desc = "Symbol" },
        { "<leader>fl", function() require('fzf-lua').resume() end,                  desc = "Last search" },
        { "<leader>g",  group = "Go to" },
        { "<leader>gd", function() require('fzf-lua').lsp_definitions() end,         desc = "Definition" },
        { "<leader>gi", function() require('fzf-lua').lsp_implementations() end,     desc = "Implementation" },
        { "<leader>gr", function() require('fzf-lua').lsp_references() end,          desc = "References" },
        { "<leader>c",  group = "Code" },
        { "<leader>cr", vim.lsp.buf.rename,                                          desc = "Rename" },
        { "<leader>ca", function() require('fzf-lua').lsp_code_actions() end,        desc = "Action", mode = { "n", "v" } },
        { "<leader>d",  group = "Diagnostics" },
        { "<leader>dd", vim.diagnostic.open_float,                                   desc = "Show" },
        { "<leader>dl", vim.diagnostic.setloclist,                                   desc = "List" },
        { "<leader>b",  group = "Buffer" },
        { "<leader>bn", "<cmd>enew<cr>",                                             desc = "New" },
        { "<leader>bd", function() Snacks.bufdelete() end,                           desc = "Delete" },
        { "<leader>bD", function() Snacks.bufdelete({ force = true }) end,           desc = "Force delete" },
        { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",                            desc = "Delete others" },
        { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",                              desc = "Delete on the left" },
        { "<leader>br", "<cmd>BufferLineCloseRight<cr>",                             desc = "Delete on the right" },
        { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",                              desc = "Pin" },
        { "<leader>t",  group = "Test" },
        { "<leader>tf", "<cmd>TestFile<cr>",                                         desc = "File" },
        { "<leader>tl", "<cmd>TestLast<cr>",                                         desc = "Last" },
        { "<leader>tn", "<cmd>TestNearest<cr>",                                      desc = "Nearest" },
        { "<leader>q",  function() require("quicker").toggle() end,                  desc = "Toggle quickfix" },
        { "<leader>r",  "<cmd>ToggleTerm<cr>",                                       desc = "Toggle terminal" },
        { "<leader>v",  group = "Version Control" },
        { "<leader>vo", "<cmd>DiffviewOpen<cr>",                                     desc = "Open diff" },
        { "<leader>vc", "<cmd>DiffviewClose<cr>",                                    desc = "Close diff" },
        { "]b",         "<cmd>BufferLineCycleNext<cr>",                              desc = "Next buffer" },
        { "[b",         "<cmd>BufferLineCyclePrev<cr>",                              desc = "Previous buffer" },
        { "]B",         "<cmd>BufferLineGoToBuffer -1<cr>",                          desc = "First buffer" },
        { "[B",         "<cmd>BufferLineGoToBuffer 1<cr>",                           desc = "Last buffer" },
        { "]v",         "<cmd>BufferLineMoveNext<cr>",                               desc = "Move buffer right" },
        { "[v",         "<cmd>BufferLineMovePrev<cr>",                               desc = "Move buffer left" },
      }
    },
  },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme catppuccin-macchiato")
    end
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "vim", "lua", "go", "rust", "ruby", "bash" },
        highlight = {
          enable = true
        },
        indent = {
          enable = true
        }
      })
    end
  },
  {
    "j-hui/fidget.nvim",
    tag = "v1.4.5",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "p",     "<Plug>(YankyPutAfter)",     mode = { "n", "x" } },
      { "P",     "<Plug>(YankyPutBefore)",    mode = { "n", "x" } },
      { "gp",    "<Plug>(YankyGPutAfter)",    mode = { "n", "x" } },
      { "gP",    "<Plug>(YankyGPutBefore)",   mode = { "n", "x" } },
      { "<c-p>", "<Plug>(YankyPreviousEntry)" },
      { "<c-n>", "<Plug>(YankyNextEntry)" },
    },
    opts = {},
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
      })

      vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
      vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
      vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
    end
  },
  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" }
    },
  },
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#strategy"] = "toggleterm"
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    opts = {
      options = {
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        custom_filter = function(buf, buf_nums)
          return vim.bo[buf].filetype ~= "qf"
        end
      }
    }
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      size = 20,
      persist_size = false,
    },
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    opts = {},
  },
  "ibhagwan/fzf-lua",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-unimpaired",
  "tpope/vim-eunuch",
  "tpope/vim-sleuth",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "github/copilot.vim",
  "sindrets/diffview.nvim",
})
