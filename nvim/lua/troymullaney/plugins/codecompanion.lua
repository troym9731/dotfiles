return {
	"olimorris/codecompanion.nvim",
	opts = {},
	config = function()
		require("codecompanion").setup({
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = 'cmd:op read "op://private/anthropic api key/notes" --no-newline',
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>cc", ":CodeCompanionChat Toggle<CR>", { silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>ci", ":CodeCompanion")
	end,
}
