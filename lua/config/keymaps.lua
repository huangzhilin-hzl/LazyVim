-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function copy_buffer_path(relative)
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local value = path
  if relative then
    local root = LazyVim.root() or vim.uv.cwd()
    value = vim.fs.relpath(root, path) or vim.fn.fnamemodify(path, ":.")
  end

  vim.fn.setreg("+", value)
  vim.notify("Copied path: " .. value)
end

vim.keymap.set("n", "<leader>fy", function()
  copy_buffer_path(true)
end, { desc = "Copy Relative Path" })

vim.keymap.set("n", "<leader>fY", function()
  copy_buffer_path(false)
end, { desc = "Copy Absolute Path" })

vim.keymap.set("n", "<leader>mt", function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Current buffer is not markdown", vim.log.levels.WARN)
    return
  end

  local ok, render_markdown = pcall(require, "render-markdown")
  if not ok then
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
      lazy.load({ plugins = { "render-markdown.nvim" } })
      ok, render_markdown = pcall(require, "render-markdown")
    end
    if not ok then
      vim.notify("render-markdown.nvim is not available. Restart Neovim once and try again.", vim.log.levels.WARN)
      return
    end
  end

  render_markdown.set(not render_markdown.get())
end, { desc = "Markdown Render Toggle" })

vim.keymap.set("n", "<leader>mp", function()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Current buffer is not markdown", vim.log.levels.WARN)
    return
  end

  local ok, lazy = pcall(require, "lazy")
  if ok then
    lazy.load({ plugins = { "markdown-preview.nvim" } })
  end

  vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown Preview Toggle" })
