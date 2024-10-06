-- Sourced from: https://github.com/nix-community/kickstart-nix.nvim/blob/881b465b81376ea6a08cdc4318c2e7585d6870e7/nvim/lua/user/lsp.lua

---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- Add com_nvim_lsp capabilities
	local cmp_lsp = require("cmp_nvim_lsp")
	local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
	capabilities = vim.tbl_deep_extend("keep", capabilities, cmp_lsp_capabilities)
	-- Add any additional plugin capabilities here.
	-- Make sure to follow the instructions provided in the plugin's docs.
	return capabilities
end

return M
