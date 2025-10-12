local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local configs = {
    cord = {
        editor = {
            tooltip = "Neovim"
        },
        display = {
            theme = "atom",
            flavor = "accent"
        }
    },
    snacks = {
        dashboard = { enabled = true }
    },
    treesitter = {
        indent = { enable = true },
        highlight = { enable = true },
        folds = { enable = true },
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "printf",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml"
        }
    }
}

require("lazy").setup({
    { "Mofiqul/vscode.nvim", lazy = false, priority = 1000, opts = {} },
    { "vyfor/cord.nvim", build = ':Cord update', lazy = false, opts = configs.cord },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate", opts = configs.treesitter },
    { "pmizio/typescript-tools.nvim", event = "BufEnter", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }, opts = {} },
    { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer" }, opts = {} },
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, opts = {} },
    { "folke/snacks.nvim", priority = 999, lazy = false, opts = configs.snacks },
    { 'nvim-mini/mini.pairs', version = '*', opts = {} },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
    { "nvim-tree/nvim-tree.lua", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} }
})

require("typescript-tools").setup({})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.cmd.colorscheme "vscode"

vim.o.background = 'dark'

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- vim.diagnostic.disable()
