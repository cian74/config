local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- plugin list
local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"mfussenegger/nvim-jdtls"
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	{ "nvim-treesitter/playground" },
	{ "mbbill/undotree" },
	{ "theprimeagen/harpoon" },

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					automatic_enable = {
						exclude = {
							'jdtls'
						}
					}
				}
			},

			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",

			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup {}

			-- If you're using nvim-cmp, integrate with autopairs
			local cmp_status, cmp = pcall(require, "cmp")
			if cmp_status then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},
}

require("lazy").setup(plugins)

