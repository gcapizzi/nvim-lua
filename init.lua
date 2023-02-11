vim.o.number = true
vim.o.hidden = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.updatetime = 500

vim.g.mapleader = ","

vim.keymap.set('n', '<leader>l', function()
  vim.o.hlsearch = false
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = true,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').gopls.setup{}
      require('lspconfig').rust_analyzer.setup{}

      vim.cmd('autocmd BufWritePre * lua vim.lsp.buf.format()')
      vim.cmd('autocmd CursorHoldI * lua vim.lsp.buf.signature_help()')
      vim.cmd('autocmd CursorHold * lua vim.lsp.buf.document_highlight()')
      vim.cmd('autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()')
      vim.cmd('autocmd CursorMoved * lua vim.lsp.buf.clear_references()')
    end
  },
  {
    'folke/which-key.nvim',
    config = function()
      local wk = require("which-key")
      wk.setup {
        ignore_missing = true
      }
      wk.register({
        f = {
          name = "Find",
          f = { "<cmd>Telescope find_files<cr>", "File by name" },
          r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
          g = { "<cmd>Telescope live_grep<cr>", "File via grep" },
          b = { "<cmd>Telescope buffers<cr>", "Buffer" },
          s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Symbol" },
        },
        g = {
          name = "Go to",
          d = { vim.lsp.buf.definition, "Definition" },
          i = { vim.lsp.buf.implementation, "Implementation" },
          r = { vim.lsp.buf.references, "References" },
        },
        c = {
          name = "Code",
          r = { vim.lsp.buf.rename, "Rename" },
          a = { vim.lsp.buf.code_action, "Action", mode = {"n", "v"}},
        },
        d = {
          name = "Diagnostics",
          d = { vim.diagnostic.open_float, "Show" },
          l = { vim.diagnostic.setloclist, "List" },
        },
      }, { prefix = "<leader>" })
      wk.register({
        ['K'] = { vim.lsp.buf.hover, "Hover" },
        [']d'] = { vim.diagnostic.goto_next, "Next diagnostic" },
        ['[d'] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
      })
    end,
  },
  {
    'dracula/vim',
    config = function()
      vim.o.termguicolors = true
      vim.cmd('colorscheme dracula')
      vim.cmd('highlight LspSignatureActiveParameter gui=bold')
    end
  },
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_change_to_vcs_root = true
    end
  },
  {
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'dracula',
          icons_enabled = false,
          section_separators = '',
          component_separators = ''
        },
        tabline = {
          lualine_a = {'buffers'},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {'tabs'}
        }
      }
    end
  },
  {
    'ajh17/VimCompletesMe',
    config = function()
      vim.o.completeopt = 'menu'
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {"vim", "lua", "go", "rust"},
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "=",
            node_decremental = "-",
            scope_incremental = "+",
          },
        },
        indent = {
          enable = true
        }
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sa"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sA"] = "@parameter.inner",
            },
          },
        },

      }
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  {
    'j-hui/fidget.nvim',
    config = true,
  },
  'wellle/targets.vim',
  'justinmk/vim-dirvish',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'wincent/terminus',
}, {
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
