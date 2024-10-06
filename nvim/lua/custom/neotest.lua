require("neotest").setup({
	adapters = {
		require("neotest-mocha")({
			command = "npx mocha --require ts-node/register --require dotenv/config",
			command_args = function(context)
				-- The context contains:
				--   results_path: The file that json results are written to
				--   test_name_pattern: The generated pattern for the test
				--   path: The path to the test file
				--
				-- It should return a string array of arguments
				--
				-- Not specifying 'command_args' will use the defaults below
				return {
					"--full-trace",
					"--reporter=json",
					"--reporter-options=output=" .. context.results_path,
					"--grep=" .. context.test_name_pattern,
					context.path,
				}
			end,
			env = { CI = true },
			cwd = function(_)
				return vim.fn.getcwd()
			end,
		}),
	},
})

vim.keymap.set("n", "<leader>Ts", "<cmd>Neotest summary<cr>", { desc = "[T]est [s]ummary" })
vim.keymap.set("n", "<leader>Tc", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "[T]est [c]losest" })
vim.keymap.set("n", "<leader>Tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[T]est all in [f]ile" })
vim.keymap.set("n", "<leader>Tl", function()
	require("neotest").run.run_last({ strategy = "dap" })
end, { desc = "[T]est run [l]ast" })
vim.keymap.set("n", "<leader>TS", function()
	require("neotest").run.stop()
end, { desc = "[T]est [S]stop!" })
vim.keymap.set("n", "<leader>Twt", function()
	require("neotest").watch.toggle()
end, { desc = "[T]est watch [t]oggle" })
vim.keymap.set("n", "<leader>Tws", function()
	require("neotest").watch.stop()
end, { desc = "[T]est watch [s]top" })
