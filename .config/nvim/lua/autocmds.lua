-- This is view handling code. This is used to save code fold state
-- for buffers per session, so folds do not re-collapse when navigating
-- between buffers.
--
-- Get the user's AstroNvim configuration path or a general plugins setup file
-- e.g., in ~/.config/nvim/lua/user/init.lua or a dedicated plugins/config file

-- Create an autocommand group to manage these autocommands
local persist_folds_group = vim.api.nvim_create_augroup("PersistentFolds", { clear = true })

-- Define filetypes to ignore for view saving/loading
-- (e.g., special buffers where folds aren't relevant or cause issues)
local ignored_fts = {
  "TelescopePrompt", "DressingSelect", "DressingInput",
  "toggleterm", "gitcommit", "gitrebase", "svn", "hgcommit",
  "help", "qf", "fugitive", "fugitiveblame", "nerdtree",
  "vista", "vista_kind", "DiffviewFiles", "DiffviewFileHistory", "DiffviewTree",
  "lazy", "mason", "alpha", "terminal", "OverseerForm", "OverseerRun",
  "packer", -- if still using packer, though AstroNvim uses lazy.nvim
  "", -- empty filetype (e.g. new unnamed buffer)
}

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  group = persist_folds_group,
  pattern = "*", -- Apply to all buffers
  callback = function()
    local buftype = vim.bo.buftype
    local ft = vim.bo.filetype
    -- Check if current filetype is in ignored_fts or buftype is special
    if vim.tbl_contains(ignored_fts, ft) or buftype == "nofile" or buftype == "prompt" or buftype == "terminal" then
      return
    end
    -- Silently make a view. The 'silent!' suppresses errors if e.g. 'viewdir' is not writable.
    vim.cmd("silent! mkview")
  end,
  desc = "Save view (including folds) when leaving a buffer's window",
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = persist_folds_group,
  pattern = "*", -- Apply to all buffers
  callback = function()
    local buftype = vim.bo.buftype
    local ft = vim.bo.filetype
    if vim.tbl_contains(ignored_fts, ft) or buftype == "nofile" or buftype == "prompt" or buftype == "terminal" then
      return
    end
    -- Only load the view if the buffer is not new and has a file name
    if vim.fn.filereadable(vim.fn.expand("<afile>")) == 1 and vim.fn.bufname("%") ~= "" then
        -- Check if view file exists (optional, loadview handles it silently)
        -- local view_path = vim.fn.expand(vim.o.viewdir .. "/" .. vim.fn.fnamemodify(vim.fn.bufname("%"), ":=") .. "=")
        -- if vim.fn.filereadable(view_path) then
        vim.cmd("silent! loadview")
        -- end
    end
  end,
  desc = "Load view (including folds) when entering a buffer's window",
})
