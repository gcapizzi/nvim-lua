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
    event = "VeryLazy",
    config = true,
    opts = {
      icons = {
        rules = false,
        separator = '>',
      },
    },
    keys = {
      { "<leader>f", group = "Find" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File by name" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "File via live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "File via live grep (current word)" },
      { "<leader>fG", "<cmd>Grepper -tool rg<cr>", desc = "File via batch grep" },
      { "<leader>fW", "<cmd>Grepper -tool rg -cword -noprompt<cr>", desc = "File via batch grep (current word)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffer" },
      { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbol" },
      { "<leader>g", group = "Go to" },
      { "<leader>gd", vim.lsp.buf.definition, desc = "Definition" },
      { "<leader>gi", vim.lsp.buf.implementation, desc = "Implementation" },
      { "<leader>gr", vim.lsp.buf.references, desc = "References" },
      { "<leader>c", group = "Code" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Action", mode = { "n", "v" } },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>dd", vim.diagnostic.open_float, desc = "Show" },
      { "<leader>dl", vim.diagnostic.setloclist, desc = "List" },
      { "<leader>l", "<cmd>set hlsearch!<cr>", desc = "Toggle search highligting" },
      { "<leader>y", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },
      { "<leader>b", group = "Buffer" },
      { "<leader>bn", "<cmd>enew<cr>", desc = "New" },
      { "<leader>bd", "<cmd>BDelete this<cr>", desc = "Delete" },
      { "<leader>bD", "<cmd>BDelete! this<cr>", desc = "Delete" },
      { "<leader>bo", "<cmd>BDelete other<cr>", desc = "Delete others" },
      { "<leader>t", group = "Test" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "File" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Last" },
      { "<leader>s", group = "Swap" },
      { "<leader>sa", desc = "Argument right" },
      { "<leader>sA", desc = "Argument left" },
      { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
      { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    }
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end
  },
  {
    "goolord/alpha-nvim",
    config = function ()
      local startify = require('alpha.themes.startify')
      startify.nvim_web_devicons.enabled = false
      require('alpha').setup(startify.config)
    end
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
    end
  },
  'mhinz/vim-grepper',
  {
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight-night',
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
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
      })

      vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
      vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
      vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
      vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })
    end
  },
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup({
        delete_to_trash = true
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },
  'vim-test/vim-test',
  'wellle/targets.vim',
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
