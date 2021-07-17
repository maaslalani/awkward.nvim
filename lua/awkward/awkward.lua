-- @class Awkward
local M = {}

local AWK = "awk"
local AWK_LEN = #AWK
local AWKWARD_COMMENT = "--"

-- TODO: Make user configurable
local AWKWARD_LOCATION = "/tmp/awkward-data.txt"

function M.setup()
  -- AwkwardExpressions look like plain text by default,
  -- but users can customize this
  vim.cmd [[
  hi def link AwkwardExpression Text
  hi def link AwkwardComment Comment
  hi def link AwkwardResult Text
  ]]

  -- :Awkward<cr>
  vim.cmd [[
  command! Awkward lua require('awkward').Awkward()
  ]]
end

-- Awkward
function M.Awkward()
  -- For development purposes (force reload)
  require'plenary.reload'.reload_module('awkward')

  -- Conceal awk expressions
  -- Add lua-style comments to allow documentation of awk expressions
  vim.cmd [[
  syntax match AwkwardExpression "awk '{\v(.+)}'" conceal cchar=→ 
  syntax match AwkwardComment "\v^-- (.+)$"
  ]]

  -- Conceal AwkwardExpressions with the right arrow character
  vim.cmd [[
  setlocal conceallevel=1
  ]]

  -- Read in entire buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local awkward_expressions = {}
  local awkward_data = ''

  for k, v in pairs(lines) do
    -- Gather the awkward expressions to evaluate later
    if string.sub(v, 1, AWK_LEN) == AWK then
      table.insert(awkward_expressions, {expression = v, line = k-1})
      -- skip empty lines and "comments"
    elseif #v ~= 0 and string.sub(v, 1, #AWKWARD_COMMENT) ~= AWKWARD_COMMENT then
      -- collect awkward data to be processed by the awkward expressions
      awkward_data = awkward_data .. "\n" .. v
    end
  end

  -- Write data to an awkward location, so that AWK can read from this file
  local file = io.open(AWKWARD_LOCATION, "w")
  file:write(awkward_data)
  file:close()

  -- Clear all virtual text
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)

  -- Evaluate awkward expressions and display the results as virtual text
  for k, v in pairs(awkward_expressions) do
    local out = io.popen(v.expression.." "..AWKWARD_LOCATION):read("*a")
    out = out:gsub("%s+$", "")
    vim.api.nvim_buf_set_virtual_text(0, 0, v.line, {{out, "AwkwardResult"}}, {})
  end
end

return M
