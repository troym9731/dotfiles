return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					if pcall(vim.treesitter.start) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
			-- Excludes parsers bundled with nix-wrapped neovim: c, lua, markdown,
			-- markdown_inline, query, vim, vimdoc
			require("nvim-treesitter").install({
				"dockerfile",
				"eex",
				"elixir",
				"elm",
				"fish",
				"go",
				"gomod",
				"heex",
				"html",
				"javascript",
				"json",
				"nix",
				"ruby",
				"rust",
				"sql",
				"terraform",
				"toml",
				"typescript",
				"yaml",
			})
		end,
	},
}
