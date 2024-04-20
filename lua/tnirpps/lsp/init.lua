local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "tnirpps.lsp.mason"
require("tnirpps.lsp.handlers").setup()
require "tnirpps.lsp.null-ls"
