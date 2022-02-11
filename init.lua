vim.api.nvim_set_option('number', true)
vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('cursorline', true)
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('undofile', true)

vim.g.mapleader = ","

vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>noh<cr>', { noremap = true})

vim.api.nvim_command('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()')
vim.api.nvim_command('autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync()')
vim.api.nvim_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')

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
			require('lspconfig').rust_analyzer.setup{}

			vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})

			vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', {noremap = true})
			vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {noremap = true})
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
