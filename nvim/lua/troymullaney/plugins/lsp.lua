return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- LSP Support
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },

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
				"tsserver",
				"eslint",
				"lua_ls",
				"solargraph",
			},
			handlers = {
				function(server)
					require("lspconfig")[server].setup({})
				end,
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

		require("lspconfig").html.setup({
			init_options = {
				provideFormatter = false,
			},
		})

		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					format = {
						enable = false,
					},
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		require("lspconfig").solargraph.setup({
			init_options = {
				formatting = false,
			},
		})

		require("lspconfig").eslint.setup({
			format = false,
		})

		require("lspconfig").jsonls.setup({
			init_options = {
				provideFormatter = false,
			},
		})

		require("lspconfig").tsserver.setup({
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			signs = {
				severity_limit = "Warning",
			},
			virtual_text = {
				severity_limit = "Warning",
			},
		})
	end,
}
