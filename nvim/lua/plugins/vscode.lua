-- don't do anything in non-vscode instances
  if not vim.g.vscode then
    return {}
  end
  
  -- a list of known working plugins with vscode-neovim, update with your own plugins
  local plugins = {
    "lazy.nvim",
    "AstroNvim",
    "astrocore",
    "astroui",
    "Comment.nvim",
    "nvim-autopairs",
    "nvim-treesitter",
    "nvim-ts-autotag",
    "nvim-treesitter-textobjects",
    "nvim-ts-context-commentstring",
    "flash.nvim",

  }
  
  local Config = require("lazy.core.config")
  -- disable plugin update checking
  Config.options.checker.enabled = false
  Config.options.change_detection.enabled = false
  -- replace the default `cond`
  Config.options.defaults.cond = function(plugin)
    return vim.tbl_contains(plugins, plugin.name)
  end
  
  ---@type LazySpec
  return {
    -- add a few keybindings
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<Leader>ff"] = "<CMD>Find<CR>",
            ["<Leader>fw"] = "<CMD>call VSCodeNotify('workbench.action.findInFiles')<CR>",
            ["<Leader>ls"] = "<CMD>call VSCodeNotify('workbench.action.gotoSymbol')<CR>",
            ["za"] = "<Cmd>call VSCodeNotify('editor.toggleFold')<CR>",
            ["zc"] = "<Cmd>call VSCodeNotify('editor.fold')<CR>",
            ["zo"] = "<Cmd>call VSCodeNotify('editor.unfold')<CR>",
            ["zr"] = "<Cmd>call VSCodeNotify('editor.unfoldAll')<CR>",
            ["zm"] = "<Cmd>call VSCodeNotify('editor.foldAll')<CR>",
            ["zO"] = "<Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>",
            ["z1"] = "<Cmd>call VSCodeNotify('editor.foldLevel1')<CR>",
            ["z2"] = "<Cmd>call VSCodeNotify('editor.foldLevel2')<CR>",
            ["z3"] = "<Cmd>call VSCodeNotify('editor.foldLevel3')<CR>",
            ["z4"] = "<Cmd>call VSCodeNotify('editor.foldLevel4')<CR>",
            ["z5"] = "<Cmd>call VSCodeNotify('editor.foldLevel5')<CR>",
            ["z6"] = "<Cmd>call VSCodeNotify('editor.foldLevel6')<CR>",
            ["z7"] = "<Cmd>call VSCodeNotify('editor.foldLevel7')<CR>",

            ["zj"] = "<Cmd>call VSCodeNotify('editor.gotoNextFold')<CR>",
            ["zk"] = "<Cmd>call VSCodeNotify('editor.gotoPreviousFold')<CR>"
          },
        }
      },
    },
    -- disable colorscheme setting
    { "AstroNvim/astroui", opts = { colorscheme = false } },
    -- disable treesitter highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      opts = { highlight = { enable = false } },
    },
  }