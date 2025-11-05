vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
-- In ~/.config/nvim/init.lua
vim.opt.runtimepath:append("/home/cian/Work/java-refactor-tool/nvim-plugin")

require("cian")
