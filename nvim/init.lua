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

require "lazy_setup"
require "polish"

return {
  plugins = {
    init = {
      {
        "abecodes/tabout.nvim",
        wants = { "nvim-treesitter" },
        after = { "nvim-cmp" },
        config = function()
          require("tabout").setup {
            tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
            backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
            act_as_tab = true, -- shift content if tab out is not possible
            act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
            default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
            default_shift_tab = "<C-d>", -- reverse shift default action,
            enable_backwards = true, -- well ...
            completion = true, -- if the tabkey is used in a completion pum
            tabouts = {
              { open = "'", close = "'" },
              { open = '"', close = '"' },
              { open = "`", close = "`" },
              { open = "(", close = ")" },
              { open = "[", close = "]" },
              { open = "{", close = "}" },
            },
            ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
            exclude = {}, -- tabout will ignore these filetypes
          }
        end,
      },
    },
    cmp = function(config)
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      config.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      })
      config.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      })

      return config
    end,
  },
}