local M = {}

function M.open_claude_terminal()
  vim.cmd('vsplit | terminal claude')
  vim.cmd('startinsert')
end

function M.send_visual_to_claude()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    print("No text selected")
    return
  end

  local selected_text = table.concat(lines, "\n")
  local prompt = vim.fn.input("Claude prompt: ")

  if prompt == "" then
    return
  end

  local tmpfile = vim.fn.tempname()
  local f = io.open(tmpfile, "w")
  if f then
    f:write(selected_text)
    f:close()
  end

  local cmd = string.format('vsplit | terminal claude -p "%s" %s', prompt, tmpfile)
  vim.cmd(cmd)
  vim.cmd('startinsert')
end

function M.claude_current_file(prompt)
  local filepath = vim.fn.expand('%:p')
  if filepath == '' then
    print("No file in current buffer")
    return
  end

  local cmd
  if prompt and prompt ~= "" then
    -- Escape quotes in prompt and filepath
    local escaped_prompt = prompt:gsub('"', '\\"')
    cmd = string.format('vsplit | terminal claude %s "%s"', vim.fn.shellescape(filepath), escaped_prompt)
  else
    cmd = string.format('vsplit | terminal claude %s', vim.fn.shellescape(filepath))
  end

  vim.cmd(cmd)
  vim.cmd('startinsert')
end

function M.claude_fix_current_file()
  M.claude_current_file("Fix any issues in this file")
end

function M.claude_explain_current_file()
  M.claude_current_file("Explain what this file does")
end

function M.claude_refactor_current_file()
  M.claude_current_file("Suggest refactoring improvements for this file")
end

return M
