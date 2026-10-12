return {
  "jake-stewart/multicursor.nvim",
  enabled = true,
  lazy = false,
  branch = "1.0",
  keys = {
    { "<C-d>", mode = { "n", "v" } },
    { "<C-q>", mode = { "n", "v" } },
    { "<A-Up>", mode = { "n", "v" } },
    { "<A-Down>", mode = { "n", "v" } },
  },
  config = function(_, opts)
    local mc = require "multicursor-nvim"
    mc.setup(opts)

    local map = vim.keymap.set

    -- =========================
    -- 🔥 VSCode-like Ctrl+D (FIXED)
    -- =========================
    map("n", "<C-d>", function()
      -- kalau belum ada multicursor → select word dulu
      if not mc.hasCursors() then
        vim.cmd "normal! viw"
      end
      mc.matchAddCursor(1)
    end, { desc = "Add next match (VSCode style)" })

    map("v", "<C-d>", function()
      mc.matchAddCursor(1)
    end)

    -- =========================
    -- 🔥 Select all matches
    -- =========================
    map("n", "<C-S-d>", function()
      if not mc.hasCursors() then
        vim.cmd "normal! viw"
      end
      mc.matchAllAddCursors()
    end, { desc = "Select all matches" })

    map("v", "<C-S-d>", mc.matchAllAddCursors)

    -- =========================
    -- 🔥 Toggle multicursor
    -- =========================
    map({ "n", "v" }, "<C-q>", mc.toggleCursor, { desc = "Toggle multicursor" })

    -- =========================
    -- 🔥 FREE CURSOR MODE (tanpa match)
    -- =========================
    map("n", "<A-Up>", function()
      mc.lineAddCursor(-1)
    end, { desc = "Add cursor above" })

    map("n", "<A-Down>", function()
      mc.lineAddCursor(1)
    end, { desc = "Add cursor below" })

    -- alternatif (optional)
    map("n", "<C-Up>", function()
      mc.lineAddCursor(-1)
    end)

    map("n", "<C-Down>", function()
      mc.lineAddCursor(1)
    end)

    -- =========================
    -- 🔥 NAVIGATION
    -- =========================
    map({ "n", "v" }, "<leader>x", mc.deleteCursor, { desc = "Delete cursor" })
    map({ "n", "v" }, "<leader>A", mc.matchAllAddCursors)

    map({ "n", "v" }, "<S-Left>", mc.nextCursor)
    map({ "n", "v" }, "<S-Right>", mc.prevCursor)

    -- =========================
    -- 🔥 ESC FIX (IMPORTANT)
    -- =========================
    -- map({ "n", "v" }, "<Esc>", function()
    --   if mc.hasCursors() then
    --     mc.clearCursors()
    --     return
    --   end
    --
    --   if mc.cursorsEnabled() then
    --     mc.disableCursors()
    --     return
    --   end
    --
    --   -- fallback default
    --   vim.cmd "stopinsert"
    --   vim.cmd "noh"
    -- end, {
    --   desc = "Exit multicursor / clear highlight",
    --   silent = true,
    -- })

    -- =========================
    -- 🔥 MOUSE SUPPORT
    -- =========================
    map("n", "<C-LeftMouse>", mc.handleMouse)

    -- =========================
    -- 🔥 HIGHLIGHT
    -- =========================
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
