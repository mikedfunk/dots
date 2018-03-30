local M = {}

---@vararg any
---@return nil
function M.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

---@param module string
---@return boolean
function M.is_installed(module)
  local is_module_installed, _ = pcall(require, module)

  return is_module_installed
end

---@param plugin string
---@return boolean
function M.is_plugin_installed(plugin)
  return packer_plugins and packer_plugins[plugin]
  -- and packer_plugins[plugin].loaded
end

return M
