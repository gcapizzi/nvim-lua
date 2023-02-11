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
    config = function()
      local a = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = a.move_selection_next,
              ["<C-k>"] = a.move_selection_previous,
            }
          }
        }
      }

      local t = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', t.find_files)
      vim.keymap.set('n', '<leader>fg', t.live_grep)
      vim.keymap.set('n', '<leader>fb', t.buffers)
      vim.keymap.set('n', '<leader>fs', t.lsp_dynamic_workspace_symbols)
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').gopls.setup{}
      require('lspconfig').rust_analyzer.setup{}

      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
      vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

      vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float)
      vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)

      vim.cmd('autocmd BufWritePre * lua vim.lsp.buf.format()')
      vim.cmd('autocmd CursorHoldI * lua vim.lsp.buf.signature_help()')
      vim.cmd('autocmd CursorHold * lua vim.lsp.buf.document_highlight()')
      vim.cmd('autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()')
      vim.cmd('autocmd CursorMoved * lua vim.lsp.buf.clear_references()')
    end
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
        ensure_installed = {"go", "rust"},
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
  'wellle/targets.vim',
  'justinmk/vim-dirvish',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'mhinz/vim-signify',
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
