function rm_trails()
	local view  = vim.fn.winsaveview()
	vim.cmd([[keepp %s/\s\+$//e]])
	vim.cmd("update")
	vim.fn.winrestview(view)
end

vim.api.nvim_create_user_command("Rmt", function()
	_G.rm_trails()
end,{})
