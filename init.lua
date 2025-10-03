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
    cmp = function()

    end,
}

require("lazy").setup({
    { "Mofiqul/vscode.nvim", lazy = false, priority = 1000, opts = {} },
    { "vyfor/cord.nvim", build = ':Cord update', lazy = false, opts = configs.cord },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
    { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }, opts = {} },
    { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer" }, config = configs.cmp }
})

require("typescript-tools").setup({})

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

-- vim.diagnostic.disable()
