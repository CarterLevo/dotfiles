return {
  "chrisbra/csv.vim",

  "vim-scripts/cscope.vim",
  "vim-scripts/cpp_cppcheck.vim",
  "vim-scripts/a.vim",

  "mpickering/hlint-refactor-vim",
  "neovimhaskell/haskell-vim",
  "vmchale/pointfree",

  "mboughaba/i3config.vim",
  "Fymyte/mbsync.vim",
  "kmonad/kmonad-vim",
  "jbmorgado/vim-pine-script",

  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_inded_enabled = 1
      vim.g.vimtex_complete_closed_braces = 1
      vim.g.vimtex_view_method = os.getenv("READER")
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_browser = os.getenv("BROWSER")
    end,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = {"markdown", "Rmd"},
  },
  {
    "jghauser/follow-md-links.nvim",
    ft = {"markdown", "Rmd"},
  }
}
