require'nvim-treesitter.configs'.setup {
  autotag = { enable = true, },
  highlight = { enable = true, },
  context_commentstring = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      scope_incremental = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["c"] = { query = "@class.outer", desc = "select outer part of class"},
        ["ic"] = { query = "@class.outer", desc = "select outer part of class"},
        ["f"] = { query = "@function.outer", desc = "select outer part of function"},
        ["if"] = { query = "@function.inner", desc = "select inner part of function"},
      },
    },
  },
}
  
