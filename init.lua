vim.o.number = true
vim.o.hidden = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.updatetime = 500
vim.opt.listchars = {
  eol = '¬',
  space = '·',
  extends = '«',
  precedes = '»',
  tab = '‣ ',
}

vim.g.mapleader = ","

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
    'williamboman/mason.nvim',
    config = true,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {'gopls', 'rust_analyzer', 'ruby_lsp', 'sorbet'},
      }
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').gopls.setup{}
      require('lspconfig').rust_analyzer.setup{}
      require('lspconfig').ruby_lsp.setup{}
      require('lspconfig').sorbet.setup{}

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', { callback = function() vim.lsp.buf.format() end })
          end
          if client.supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd('CursorHold', { callback = function() vim.lsp.buf.document_highlight() end })
            vim.api.nvim_create_autocmd('CursorHoldI', { callback = function() vim.lsp.buf.document_highlight() end })
            vim.api.nvim_create_autocmd('CursorMoved', { callback = function() vim.lsp.buf.clear_references() end })
          end
        end,
      })
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
          g = { "<cmd>Telescope live_grep<cr>", "File via live grep" },
          w = { "<cmd>Telescope grep_string<cr>", "File via live grep (current word)" },
          G = { "<cmd>Grepper -tool rg<cr>", "File via batch grep" },
          W = { "<cmd>Grepper -tool rg -cword -noprompt<cr>", "File via batch grep (current word)" },
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
        l = { "<cmd>set hlsearch!<cr>", "Toggle search highligting" },
        y = { "<cmd>Telescope yank_history<cr>", "Yank history" },
        b = {
          name = "Buffer",
          n = { "<cmd>enew<cr>",  "New" },
          d = { "<cmd>BDelete this<cr>",  "Delete" },
          D = { "<cmd>BDelete! this<cr>",  "Delete" },
          o = { "<cmd>BDelete other<cr>",  "Delete others" },
        },
        t = {
          name = "Test",
          f = { "<cmd>TestFile<cr>", "File" },
          l = { "<cmd>TestLast<cr>", "Last" },
        },
        s = {
          name = "Swap",
          a = { "Argument right" },
          A = { "Argument left" },
        },
      }, { prefix = "<leader>" })
      wk.register({
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
    end
  },
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_change_to_vcs_root = true
    end
  },
  'mhinz/vim-grepper',
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
    'vim-scripts/VimCompletesMe',
    config = function()
      vim.o.completeopt = 'menu'
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {"vim", "lua", "go", "rust", "ruby", "bash"},
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
  'nvim-treesitter/nvim-treesitter-context',
  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    tag = "v1.4.5",
    config = true,
  },
  {
    'kazhala/close-buffers.nvim',
    config = true,
  },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({})
      require("telescope").load_extension("yank_history")

      vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    end
  },
  'vim-test/vim-test',
  'wellle/targets.vim',
  'justinmk/vim-dirvish',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
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
