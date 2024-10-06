function _G.close_all_floating_wins()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
		end
	end

	-- local api = require("nvim-tree.api")
	-- api.tree.close()
end

require("auto-session").setup({
	log_level = "error",
	pre_save_cmds = { _G.close_all_floating_wins },
})

vim.keymap.set("n", "<leader>ur", "<cmd>SessionRestore<cr>", { desc = "[R]estore session" })
vim.keymap.set("n", "<leader>uq", "<cmd>SessionSave<cr><cmd>qa<cr>", { desc = "[Q]uit session" })
vim.keymap.set("n", "<leader>su", "<cmd>SessionSearch<CR>", { desc = "Session search" })
