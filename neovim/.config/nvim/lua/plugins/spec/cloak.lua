---@type NvPluginSpec
return {
  "laytan/cloak.nvim",
  lazy = false,

  init = function()
    vim.keymap.set("n", "<leader>cv", "<cmd>CloakToggle<CR>", {
      desc = "Toggle env visibility",
    })
  end,

  opts = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      enabled = true,
      cloak_character = "*",
      highlight_group = "LazyOperator",
      cloak_length = 12,
      try_all_patterns = true,
      cloak_telescope = true,

      patterns = {
        {
          file_pattern = ".env*",
          cloak_pattern = "=.+",
          replace = nil,
        },
      },
    })

    return opts
  end,

  config = function(_, opts)
    local cloak = require "cloak"

    cloak.setup(opts)

    -- Saat masuk insert mode -> tampilkan value asli
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        cloak.disable()
      end,
    })

    -- Saat keluar insert mode -> sembunyikan lagi
    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        cloak.enable()
      end,
    })
  end,
}
