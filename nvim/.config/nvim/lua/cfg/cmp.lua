local cmp = require("cmp")
local cmp_git = require("cmp_git")
local cmp_dap = require("cmp_dap")
local snippy = require("snippy")
local snippy_mappings = require("snippy.mapping")
local lspkind = require("lspkind")

imap("<Tab>", snippy_mappings.expand_or_advance("<Tab>"))
smap("<Tab>", snippy_mappings.next("<Tab>"))
ismap("S-<Tab>", snippy_mappings.previous("S-<Tab>"))
xmap("<Tab>", snippy_mappings.cut_text, {remap = true})
nmap("g<Tab>", snippy_mappings.cut_text, {remap = true})

-- cmp mappings
local function ctrln(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local function ctrlp(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

local function ctrlj(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local function ctrlk(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

local function ctrld(fallback)
  if cmp.visible() then
    cmp.close()
  else
    fallback()
  end
end

local function ctrla(fallback)
  if cmp.visible() then
    cmp.abort()
  else
    fallback()
  end
end

local function cr(fallback)
  if cmp.visible() then
    cmp.confirm({select = true})
  else
    fallback()
  end
end

local cmp_mappings = {
  ["<C-n>"]     = cmp.mapping(ctrln),
  ["<C-p>"]     = cmp.mapping(ctrlp),

  ["<C-k>"]     = cmp.mapping(ctrlk),
  ["<C-j>"]     = cmp.mapping(ctrlj),

  ["<C-a>"]     = cmp.mapping(ctrla),
  ["<C-d>"]     = cmp.mapping(ctrld),

  ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
  ["<C-f>"]     = cmp.mapping.scroll_docs(4),

  ["<CR>"]      = cmp.mapping(cr),
  ["<C-space>"] = cmp.mapping.complete,
}

-- setup cmp
cmp.setup{
  -- for dap/dapui
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or cmp_dap.is_dap_buffer()
    end,
  -- nvim snippy
  snippet = {
    expand = function(args) snippy.expand_snippet(args.body) end,
  },
  view = {
    entries = { name = "custom", selection_order = "near_cursor" }
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  --add extra comparator for underscores
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require("cmp-under-comparator").under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = cmp.mapping.preset.insert(cmp_mappings),
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      menu = {
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[LSP]",
        nvim_lsp_document_symbol = "[LSP]",
        treesitter = "[TS]",
        snippy = "[Snip]",
        latex_symbols = "[TeX]",
        nvim_lua = "[API]",
        doxygen = "[Doc]",
        git = "[Git]",
        path = "[Path]",
        rg = "[Ripgrep]",
        calc = "[Calc]",
        dap = "[DAP]",
        commandline = "[CMD]",
      },
      -- icon reference: https://www.nerdfonts.com/cheat-sheet
      symbol_map = {
        Text = " ",
        Method = " ",
        Function = " ",
        Constructor = " ",
        Field = "ﰠ",
        Variable = "",
        Class = " ",
        Interface = "ﳤ",
        Module = " ",
        Property = "襁",
        Unit = "塞",
        Value = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        Enum = "練",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = "ﴯ",
        Constant = " ",
        Struct = "פּ ",
        Event = "",
        Operator =  "",
        TypeParameter = " ",
      },
    }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lua", priority = 1 },
    { name = "nvim_lsp_signature_help", priority = 2 },
    { name = "nvim_lsp", priority = 2 },
    { name = "snippy", priority = 2},
    { name = "calc", priority = 3 },
    { name = "lua_latex_symbols", priority = 3 },
    -- { name = "buffer", priority = 4},
    { name = "rg", priority = 4 },
    -- { name = "rg", priority = 4, max_item_count = 15 },
    { name = "path",  priority = 5},
  })
}

-- treesitter experimentation
-- cmp.setup.filetype({"query", "tsplayground"}, {
--   sources = cmp.config.sources({
--     { name = "treesitter" }
--   }, {
--     { name = "buffer" }
--   })
-- })

-- dadbod integration
cmp.setup.filetype({"sql", "mysql", "plsql"}, {
  sources = cmp.config.sources({
    { name = "vim-dadbod-completion" }
  }, {
    { name = "buffer" }
  })
})

-- Set configuration for specific filetype (i.e. git commit).
cmp_git.setup{}
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git", priority = 1 },
    { name = "snippy", priority = 2 },
    { name = "buffer", priority = 3 }
  })
})

-- set up DAP filetype completion
cmp.setup.filetype({"dap-repl", "dapui-watches", "dapui-hover"}, {
  sources = cmp.config.sources({
    { name = "dap" },
  })
})

cmp.setup.filetype("tex", {
  sources = cmp.config.sources({
    { name = "omni", priority = 1 },
    { name = "snippy", priority = 2 },
    { name = "buffer", priority = 3 },
  })
})

-- use buffer and lsp document symbol source for `/`
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings),
  view = {
    entries = { name = "wildmenu", separator = "|" }
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" }
  }, {
    { name = "buffer" }
  })
})

-- use cmdline & path source for ':'
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(cmp_mappings),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" }
  })
})
