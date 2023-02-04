local Job = require "plenary.job"
local commands = {}

local function convertToPdf(from, to, open)
  open = open or false
  Job:new({
    command = "pandoc",
    args = { from, "-o", to, "-t", "pdf" },
    on_exit = vim.schedule_wrap(function(_, return_val)
      if return_val == 1 then
        vim.notify("Could not comvert to PDF", vim.log.levels.ERROR)
        return
      end

      if open then
        os.execute("zathura --fork " .. to)
      end
    end),
  }):start()
end

local start = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local tmpFile = os.tmpname()
  local mdFile = vim.fn.expand "%"
  if mdFile == nil then
    return
  end

  local group = vim.api.nvim_create_augroup("Markdown", { clear = true })
  local id = vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      convertToPdf(mdFile, tmpFile)
    end,
  })

  commands[bufnr] = id

  convertToPdf(mdFile, tmpFile, true)
end

local stop = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if commands[bufnr] ~= nil then
    vim.api.nvim_del_autocmd(commands[bufnr])
  end
end

local setup = function ()
  vim.api.nvim_create_user_command("MarkdownPreviewStart", start, {})
  vim.api.nvim_create_user_command("MarkdownPreviewStop", stop, {})
end

return {
  start = start,
  stop = stop,
  setup = setup,
}
