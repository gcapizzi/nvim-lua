vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('cursorline', true)
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('undofile', true)

vim.g.mapleader = ","

vim.keymap.set('n', '<leader>l', function()
	vim.api.nvim_set_option('hlsearch', false)
end)

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = {'*.go', '*.rs'},
	callback = vim.lsp.buf.formatting_sync,
})
vim.api.nvim_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
		config = function()
			local t = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', t.find_files)
			vim.keymap.set('n', '<leader>fg', t.live_grep)
			vim.keymap.set('n', '<leader>fb', t.buffers)
			vim.keymap.set('n', '<leader>fs', t.lsp_dynamic_workspace_symbols)
		end
	}
	use {
		'neovim/nvim-lspconfig',
		config = function()
			require('lspconfig').gopls.setup{}
			require('lspconfig').rust_analyzer.setup{}

			vim.keymap.set('n', 'K', vim.lsp.buf.hover)
			vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
			vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
			vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
			vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action)
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

			vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
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
			require('lualine').setup {
				options = {
					theme = 'dracula',
					icons_enabled = false
				}
			}
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
	}
	use {
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
	}
	use 'wellle/targets.vim'
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

	if packer_bootstrap then
		require('packer').sync()
	end
end)
