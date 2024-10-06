if vim.g.did_load_dap_plugin then
	return
end
vim.g.did_load_dap_plugin = true

-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

local dap = require("dap")
local dapui = require("dapui")

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup({
	-- Set icons to characters that are more likely to work in every terminal.
	--    Feel free to remove or use ones that you like more! :)
	--    Don't feel like these are good choices.
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Install golang specific config
require("dap-go").setup({
	delve = {
		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		detached = vim.fn.has("win32") == 0,
	},
})

-- dap.adapters['pwa-node'] = {
--   type = 'server',
--   host = 'localhost',
--   port = '${port}',
--   executable = {
--     command = vim.fn.exepath 'js-debug-adapter',
--     args = { '${port}' },
--   },
--   rootPath = '${workspaceFolder}',
--   cwd = '${workspaceFolder}',
-- }

for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
	dap.adapters[adapter] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = vim.fn.exepath("js-debug-adapter"),
			args = { "${port}" },
		},
		rootPath = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		enrich_config = function(finalConfig, on_config)
			local final_config = vim.deepcopy(finalConfig)

			-- Placeholder expansion for launch directives
			local placeholders = {
				["${file}"] = function(_)
					return vim.fn.expand("%:p")
				end,
				["${fileBasename}"] = function(_)
					return vim.fn.expand("%:t")
				end,
				["${fileBasenameNoExtension}"] = function(_)
					return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
				end,
				["${fileDirname}"] = function(_)
					return vim.fn.expand("%:p:h")
				end,
				["${fileExtname}"] = function(_)
					return vim.fn.expand("%:e")
				end,
				["${relativeFile}"] = function(_)
					return vim.fn.expand("%:.")
				end,
				["${relativeFileDirname}"] = function(_)
					return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
				end,
				["${workspaceFolder}"] = function(_)
					return vim.fn.getcwd()
				end,
				["${workspaceFolderBasename}"] = function(_)
					return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				end,
				["${env:([%w_]+)}"] = function(match)
					return os.getenv(match) or ""
				end,
			}

			if final_config.envFile then
				local filePath = final_config.envFile
				for key, fn in pairs(placeholders) do
					filePath = filePath:gsub(key, fn)
				end

				for line in io.lines(filePath) do
					local words = {}
					for word in string.gmatch(line, "[^=]+") do
						table.insert(words, word)
					end
					if not final_config.env then
						final_config.env = {}
					end
					final_config.env[words[1]] = words[2]
				end
			end

			on_config(final_config)
		end,
	}
end

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "[node] Launch file",
			-- program = '${file}',
			cwd = "${workspaceFolder}",
			args = { "${file}" },
			-- runtimeExecutable = "npm",
			runtimeArgs = { "-r", "ts-node/register" },
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "[node] Launch dev",
			-- program = '${file}',
			runtimeExecutable = "npm",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			args = { "run", "dev" },
			-- runtimeArgs = { '-r', 'ts-node/register' },
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
			outFiles = { "${workspaceFolder}/dist/**/*.js" },
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js", "<node_internals>/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "[node] Launch develop",
			-- program = '${file}',
			runtimeExecutable = "npm",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			args = { "run", "develop" },
			-- runtimeArgs = { '-r', 'ts-node/register' },
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
			outFiles = { "${workspaceFolder}/dist/**/*.js" },
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js", "<node_internals>/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "[node] Launch dev tsx",
			-- program = '${file}',
			runtimeExecutable = "npx",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			-- rootPath = vim.fn.getcwd(),
			-- cwd = vim.fn.getcwd(),
			-- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
			args = { "src/server.ts" },
			runtimeArgs = { "ts-node-dev", "--transpile-only", "--require", "dotenv/config" },
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
			outFiles = { "${workspaceFolder}/dist/**/*.js" },
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js", "<node_internals>/**" },
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "[node] Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Program (pwa-node)",
			cwd = vim.fn.getcwd(),
			args = { "${file}" },
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Program (pwa-node with ts-node)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "--loader", "ts-node/esm" },
			runtimeExecutable = "node",
			args = { "${file}" },
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Program (pwa-node with deno)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
			runtimeExecutable = "deno",
			attachSimplePort = 9229,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Program (pwa-node with jest)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
			runtimeExecutable = "node",
			args = { "${file}", "--coverage", "false" },
			rootPath = "${workspaceFolder}",
			sourceMaps = true,
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			skipFiles = { "<node_internals>/**", "node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Program (pwa-node with vitest)",
			cwd = vim.fn.getcwd(),
			program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
			args = { "run", "${file}" },
			autoAttachChildProcesses = true,
			smartStep = true,
			skipFiles = { "<node_internals>/**", "node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Test Program (pwa-node with deno)",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
			runtimeExecutable = "deno",
			attachSimplePort = 9229,
		},
		{
			type = "pwa-chrome",
			request = "attach",
			name = "Attach Program (pwa-chrome = { port: 9222 })",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			type = "node2",
			request = "attach",
			name = "Attach Program (Node2)",
			processId = require("dap.utils").pick_process,
		},
		{
			type = "node2",
			request = "attach",
			name = "Attach Program (Node2 with ts-node)",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			port = 9229,
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach Program (pwa-node)",
			cwd = vim.fn.getcwd(),
			processId = require("dap.utils").pick_process,
			skipFiles = { "<node_internals>/**" },
		},
	}
end

-- -- Attempt to load vscode launch.json but I think this isn't suppose to be here
-- require('dap.ext.vscode').load_launchjs()

-- Persistent breakpoints
require("persistent-breakpoints").setup({
	load_breakpoints_event = { "BufReadPost" },
})

require("nvim-dap-virtual-text").setup()

require("nvim-dap-projects").config_paths = { "./.vscode/nvim-dap.lua" }
require("nvim-dap-projects").search_project_config()

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set("n", "<F5>", function()
	-- (Re-)reads launch.json if present
	if vim.fn.filereadable(".vscode/launch.json") then
		require("dap.ext.vscode").load_launchjs(nil, {
			["pwa-node"] = js_based_languages,
			["chrome"] = js_based_languages,
			["pwa-chrome"] = js_based_languages,
		})
	end
	require("dap").continue()
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "S-<F11>", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set(
	"n",
	"<leader>b",
	require("persistent-breakpoints.api").toggle_breakpoint,
	{ desc = "Debug: Toggle Breakpoint" }
)
vim.keymap.set(
	"n",
	"<leader>B",
	require("persistent-breakpoints.api").set_conditional_breakpoint,
	-- function()
	--   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
	-- end,
	{ desc = "Debug: Set Breakpoint" }
)
vim.keymap.set(
	"n",
	"<leader>Dc",
	require("persistent-breakpoints.api").clear_all_breakpoints,
	{ desc = "Clear all breakpoints" }
)
vim.keymap.set("n", "<leader>Dl", require("persistent-breakpoints.api").set_log_point, { desc = "Set log point" })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
