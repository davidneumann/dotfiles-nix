if vim.g.did_load_nixlsp_plugin then
	return
end
vim.g.did_load_nixlsp_plugin = true

-- Sourced from https://github.com/nix-community/kickstart-nix.nvim/blob/881b465b81376ea6a08cdc4318c2e7585d6870e7/nvim/ftplugin/nix.lua

-- Exit if the language server isn't available
if vim.fn.executable("nil") ~= 1 then
	return
end

local root_files = {
	"flake.nix",
	"default.nix",
	"shell.nix",
	".git",
}

require("lspconfig").nil_ls.setup({
	autostart = true,
	capabilities = require("custom.lsp").make_client_capabilities(),
	cmd = { "nil" },
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})
