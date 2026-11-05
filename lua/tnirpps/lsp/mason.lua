
local servers = {
    "clangd"
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("tnirpps.lsp.handlers").on_attach,
		capabilities = require("tnirpps.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "tnirpps.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	vim.lsp.config(server, opts)
end

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = servers,
})
