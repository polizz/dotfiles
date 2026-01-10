
local M = {}

M.calc = function()
  -- Ensure marks are updated by executing a no-op operation in normal mode
  vim.cmd([[execute "normal! \<Esc>"]])
  vim.cmd([[let @@ = @@]])

  -- Get the start and end line numbers of the visual selection
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Fallback method if the marks aren't properly set
  if start_line == 0 or end_line == 0 or start_line > end_line then
    -- Try to get the visual selection using the current mode and cursor positions
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then  -- visual, visual line, or visual block mode
      -- Force update of '< and '> marks
      vim.cmd('normal! gv')
      -- Try again after forcing update
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
      -- Reselect the visual area (because 'normal! gv' might have changed it)
      vim.cmd('normal! gv')
    end
    -- Final check if we now have valid selection
    if start_line == 0 or end_line == 0 or start_line > end_line then
      vim.notify("No valid visual selection detected", vim.log.levels.WARN)
      return
    end
  end

  -- Get the content of the visually selected lines
  local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local input_for_bc = table.concat(selected_lines, "\n")

  -- Execute bc -l with the selected content
  local result = vim.fn.system("bc -l", input_for_bc)
  -- Remove any trailing newline or whitespace
  result = result:gsub("%s+$", "")
  -- Split the result into lines
  local result_lines = vim.split(result, "\n")
  -- Insert the result lines after the visual selection
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, result_lines)
  -- Exit visual mode by sending Escape key
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  -- Move cursor to the first line of the calculation result
  vim.api.nvim_win_set_cursor(0, {end_line + 1, 0})
  -- Notify the user for feedback
  vim.notify("Calculation completed", vim.log.levels.INFO)
end

return M
