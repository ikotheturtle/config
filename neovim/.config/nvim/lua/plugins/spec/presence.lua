return {
  "andweeb/presence.nvim",
  lazy = false,
  config = function()
    require("presence").setup {
      auto_update = true,

      neovim_image_text = "Neovim",
      main_image = "file",

      debounce_timeout = 10,
      enable_line_number = false,
      blacklist = {},
      buttons = true,
      show_time = true,

      -- 🔥 CUSTOM TEXT
      editing_text = "🚀 Ngoding %s",
      file_explorer_text = "📁 Browsing %s",
      git_commit_text = "🔧 Commit changes",
      plugin_manager_text = "⚙️ Managing plugins",
      reading_text = "📖 Reading %s",

      workspace_text = "📁 project: %s",

      line_number_text = "📍 Line %s",

      -- ICON / LABEL FILETYPE
      file_assets = {
        rust = { text = "Rust 🦀" },
        go = { text = "Go 🐹" },
        lua = { text = "Lua 🌙" },
      },
    }
  end,
}
