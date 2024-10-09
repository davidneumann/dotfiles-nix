if vim.g.did_load_golsp_plugin then
	return
end
vim.g.did_load_golsp_plugin = true

-- Sourced from https://github.com/nix-community/kickstart-nix.nvim/blob/881b465b81376ea6a08cdc4318c2e7585d6870e7/nvim/ftplugin/nix.lua

-- Exit if the language server isn't available
if vim.fn.executable("gopls") ~= 1 then
	print("Failed to find gopls")
	return
end

require("lspconfig").gopls.setup({
	autostart = true,
	capabilities = require("custom.lsp").make_client_capabilities(),
})
