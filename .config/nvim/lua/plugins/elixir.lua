return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "elixir",
        "heex",
        "eex",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nextls = {
          cmd = { "nextls", "--stdio" },
        },
      },
    },
  },
}
