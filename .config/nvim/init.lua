-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

-- _G.MinimalFoldExpr = function()
--   -- NATIVE API 1: Ask Tree-sitter for the language at the current line.
--   local lang = vim.treesitter.language.get_lang_at_pos({ vim.v.lnum - 1, 0 })
--
--   -- If the language is JSON, use a native folding strategy for it.
--   if lang == "json" then
--     -- NATIVE API 2: Use Vim's built-in indentation calculation.
--     -- This is the most efficient way to fold bracketed languages.
--     return vim.fn.indent(vim.v.lnum) / vim.o.shiftwidth
--   end
--
--   -- If the language is Markdown, use a native strategy for it.
--   -- A simple pattern match for headings is the most direct approach.
--   local line = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1] or ""
--   local _, _, hashes = line:find("^(#+)")
--   if hashes then
--     -- This tells Vim to start a new fold with a level equal to the number of '#'.
--     return ">" .. #hashes
--   end
--
--   -- For all other lines, continue the current fold level.
--   return "="
-- end
--
-- -- Create an autocommand to apply this logic only to Markdown files.
-- -- This won't interfere with any other filetype.
-- local augroup = vim.api.nvim_create_augroup("MinimalMarkdownFolding", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   pattern = "markdown",
--   callback = function()
--     -- Set vim options to use our new minimal function.
--     vim.wo.foldmethod = "expr"
--     vim.wo.foldexpr = "_G.MinimalFoldExpr()"
--   end,
--   desc = "Apply minimal folding logic for Markdown with injected languages",
-- })


require "set_tmp_dir"
require "autocmds"
require "lazy_setup"
require "polish"
