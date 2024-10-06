if vim.g.did_load_autopairs_plugin then
	return
end
vim.g.did_load_autopairs_plugin = true

require("nvim-autopairs").setup {}
-- If you want to automatically add `(` after selecting a function or method
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-ts-autotag").setup({})
