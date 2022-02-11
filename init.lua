vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('cursorline', true)
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('undofile', true)

vim.g.mapleader = ","

vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>noh<cr>', { noremap = true})

vim.api.nvim_command('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()')

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.api.nvim_command('packadd packer.nvim')
return require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}
	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
		end
	}
	use {
		'neovim/nvim-lspconfig',
		config = function()
			require('lspconfig').gopls.setup{}
		end
	}
	use {
		'glepnir/lspsaga.nvim',
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>Lspsaga lsp_finder<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('v', '<leader>ca', '<cmd><c-u>Lspsaga range_code_action<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>Lspsaga rename<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>Lspsaga preview_definition<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gn', '<cmd>Lspsaga diagnostic_jump_next<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>Lspsaga diagnostic_jump_prev<cr>', { noremap = true, silent = true })

			require("lspsaga").init_lsp_saga {
				error_sign = '❌',
				warn_sign = '⚠️',
				hint_sign = '💡',
				infor_sign = 'ℹ️',
				dianostic_header_icon = ' 🚒 ',
				code_action_icon = '💡',
				code_action_keys = {
					quit = '<esc>',
					exec = '<cr>'
				},
				finder_definition_icon = '📖 ',
				finder_reference_icon = '🔖 ',
				finder_action_keys = {
					open = '<cr>',
					split = 's',
					vsplit = 'v',
					quit = '<esc>',
					scroll_down = '<c-f>',
					scroll_up = '<c-b>'
				},
				code_action_keys = {
					quit = '<esc>',
					exec = '<cr>'
				},
				rename_action_keys = {
					quit = '<esc>',
					exec = '<cr>'
				},
				definition_preview_icon = '📖 '
			}
		end
	}
	use {
		'dracula/vim',
		config = function()
			vim.api.nvim_set_option('termguicolors', true)
			vim.api.nvim_command('colorscheme dracula')
		end
	}
	use {
		'mhinz/vim-startify',
		config = function()
			vim.api.nvim_set_var('startify_change_to_vcs_root', true)
		end
	}
	use {
		'hoob3rt/lualine.nvim',
		config = function()
			local lualine = require('lualine')
			lualine.options.theme = 'dracula'
			lualine.options.icons_enabled = false
			lualine.status()
		end
	}
	use {
		'ajh17/VimCompletesMe',
		config = function()
			vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
			vim.api.nvim_set_option('completeopt', 'menu')
		end
	}
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = "go",
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
	}
	use 'justinmk/vim-dirvish'
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-eunuch'
	use 'tpope/vim-sleuth'
	use 'tpope/vim-commentary'
	use 'tpope/vim-fugitive'
	use 'mhinz/vim-signify'
	use 'mhinz/vim-grepper'
	use 'wincent/terminus'
end)
