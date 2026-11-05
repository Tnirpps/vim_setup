local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
  return
end

local parsers = { "bash", "c", "cpp", "lua", "python" }

treesitter.setup()
treesitter.install(parsers)

-- A VS Code-inspired palette without error-like red delimiters.
local rainbow_highlights = {
  { "RainbowDelimiterViolet", "#C586C0" },
  { "RainbowDelimiterBlue", "#569CD6" },
  { "RainbowDelimiterGold", "#DCDCAA" },
  { "RainbowDelimiterCyan", "#4EC9B0" },
  { "RainbowDelimiterPink", "#D16D9E" },
  { "RainbowDelimiterLightBlue", "#9CDCFE" },
}

vim.g.rainbow_delimiters = {
  highlight = vim.tbl_map(function(item)
    return item[1]
  end, rainbow_highlights),
}

local function set_rainbow_highlights()
  for _, item in ipairs(rainbow_highlights) do
    vim.api.nvim_set_hl(0, item[1], { fg = item[2] })
  end
end

set_rainbow_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("rainbow_delimiter_colors", { clear = true }),
  callback = set_rainbow_highlights,
})

-- nvim-treesitter's current API delegates highlighting to Neovim itself.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "bash", "c", "cpp", "lua", "python", "sh" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)

    -- Tree-sitter indentation is still experimental; keep Python's native
    -- indentation, which behaves better for this configuration.
    if vim.bo[args.buf].filetype ~= "python" then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
