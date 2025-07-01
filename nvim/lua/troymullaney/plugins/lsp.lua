return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- LSP Support
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "creativenull/efmls-configs-nvim" },

		-- Autocompletion
		{
			"hrsh7th/nvim-cmp",
		},
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },

		-- Snippets
		{ "L3MON4D3/LuaSnip" },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"html",
				"jsonls",
				"lua_ls",
				"taplo",
				"ts_ls",
			},
		})

		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})

		require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.dotfiles/snippets" })

		vim.lsp.enable("gopls")
		vim.lsp.enable("html")
		vim.lsp.enable("lexical")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("taplo")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("efm")
		local prettierd = require("efmls-configs.formatters.prettier_d")
		local fs = require("efmls-configs.fs")
		vim.lsp.config("efm", {
			init_options = { documentFormatting = true },
			settings = {
				rootMarkers = { ".git/" },
				languages = {
					elixir = {
						{
							formatCommand = string.format("%s %s", fs.executable("mix"), "format -"),
							formatStdin = true,
							rootMarkers = {
								".formatter.exs",
								"mix.exs",
							},
						},
					},
					go = {
						require("efmls-configs.formatters.gofmt"),
					},
					javascript = { prettierd },
					javascriptreact = { prettierd },
					json = { require("efmls-configs.formatters.fixjson") },
					lua = {
						require("efmls-configs.formatters.stylua"),
					},
					nix = {
						require("efmls-configs.formatters.nixfmt"),
					},
					ruby = { prettierd },
					toml = {
						require("efmls-configs.formatters.taplo"),
					},
					typescript = { prettierd },
					typescriptreact = { prettierd },
				},
			},
		})

		local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = lsp_fmt_group,
			callback = function(ev)
				local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

				if vim.tbl_isempty(efm) then
					return
				end

				vim.lsp.buf.format({ name = "efm", async = true })
			end,
		})

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			-- signs = {
			-- 	severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
			-- },
			-- virtual_text = {
			-- 	severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
			-- },
		})
	end,
}
