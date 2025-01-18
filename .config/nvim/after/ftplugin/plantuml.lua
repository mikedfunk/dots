---@return nil
local open_uml_image = function()
  local file_path = vim.fn.expand("%")
  if file_path == nil then
    vim.notify("No file name", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("plantuml " .. file_path .. " -tsvg")
  vim.fn.system("open " .. file_path:gsub("%..-$", ".svg")) -- lua regex is weird
end

---@return nil
local refresh_uml_image = function()
  local file_path = vim.fn.expand("%")
  if file_path == nil then
    vim.notify("No file name", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("plantuml " .. file_path .. " -tsvg")
  vim.fn.system('terminal-notifier -message "uml diagram reloaded"')
  -- vim.cmd('echom "UML diagram reloaded"')
end

local ok, which_key = pcall(require, "which-key")

if ok then
  which_key.add({
    { "<leader>i", noremap = true, buffer = true, group = "+uml", icon = "" },
    { "<leader>io", open_uml_image, noremap = true, buffer = true, desc = "Open SVG" },
    { "<leader>ir", refresh_uml_image, noremap = true, buffer = true, desc = "Refresh SVG" },
  })
end
