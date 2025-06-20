-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {
		'mfussenegger/nvim-jdtls',
		ft = 'java',
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end})
		use('nvim-treesitter/nvim-treesitter', {run =':TSUpdate'})
		use('nvim-treesitter/playground')
		use('mbbill/undotree')
		use('theprimeagen/harpoon')
		use {
			'VonHeikemen/lsp-zero.nvim',
			branch = 'v3.x',
			requires = {
				{'neovim/nvim-lspconfig'},
				{'williamboman/mason.nvim'},
				{'williamboman/mason-lspconfig.nvim'},

				{'hrsh7th/nvim-cmp'},
				{'hrsh7th/cmp-buffer'},
				{'hrsh7th/cmp-path'},
				{'saadparwaiz1/cmp_luasnip'},
				{'hrsh7th/cmp-nvim-lsp'},
				{'hrsh7th/cmp-nvim-lua'},

				{'L3MON4D3/LuaSnip'},
				{'rafamadriz/friendly-snippets'},
			}
		}

		use {
			'windwp/nvim-autopairs',
			config = function()
				require('nvim-autopairs').setup {}

				-- If you're using nvim-cmp, integrate with autopairs
				local cmp_status, cmp = pcall(require, 'cmp')
				if cmp_status then
					local cmp_autopairs = require('nvim-autopairs.completion.cmp')
					cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
				end
			end
		}

	end) 
