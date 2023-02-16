return {
  {
    "ibhagwan/fzf-lua", -- fuzzy finder
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      require "cfg.fzf"
    end
  },
  {
    "akinsho/toggleterm.nvim", -- better terminal integration
    config = function()
      require "cfg.toggleterm"
    end,
    version = "v2.*",
  },
  {
    "liuchengxu/vista.vim", -- symbol browser
    config = function()
      require "cfg.vista"
    end,
  },
  {
    "folke/trouble.nvim", -- diagnostic interface
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      require "cfg.trouble"
    end,
  },
  {
    "radenling/vim-dispatch-neovim", -- async build cmds
    dependencies = "tpope/vim-dispatch",
    config = function()
      vim.g.dispatch_no_maps = 1
    end,
    event = "CmdlineEnter",
  },
  {
    "kristijanhusak/vim-dadbod-ui", -- vim database interface
    dependencies = "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
  },
  {
    "miversen33/netman.nvim",
    config = function()
      require "netman"
    end,
  },
  {
    "knubie/vim-kitty-navigator",
    cond = os.getenv("TERM") == "xterm-kitty",
    config = function()
      require "cfg.kitty-navigator"
    end,
    build = "cp ./*.py ~/.config/kitty/",
  },
}
